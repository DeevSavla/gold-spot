part of '../main.dart';

class BodyCompositionScreen extends StatefulWidget {
  const BodyCompositionScreen({
    super.key,
    required this.user,
    required this.onBack,
    this.onReadingCaptured,
  });

  final AuthUser user;
  final VoidCallback onBack;
  final ValueChanged<BodyCompositionReading>? onReadingCaptured;

  @override
  State<BodyCompositionScreen> createState() => _BodyCompositionScreenState();
}

class _BodyCompositionScreenState extends State<BodyCompositionScreen>
    implements ICDeviceManagerDelegate, ICScanDeviceDelegate {
  static const MethodChannel _platform = MethodChannel('flutter.native/helper');

  final List<ICScanDeviceInfo> _devices = <ICScanDeviceInfo>[];
  bool _isScanning = false;
  bool _isConnected = false;
  bool _isInitializing = true;
  String _status = 'Preparing Bluetooth scale integration...';
  ICDevice? _connectedDevice;
  ICWeightData? _lastData;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _prepareSdk();
  }

  Future<void> _prepareSdk() async {
    setState(() {
      _isInitializing = true;
      _status = 'Checking Bluetooth and Location services...';
    });

    final bool bluetoothEnabled = await _isBluetoothEnabled();
    final bool locationEnabled = await _isLocationEnabled();

    if (!bluetoothEnabled || !locationEnabled) {
      setState(() {
        _isInitializing = false;
        _status = 'Enable ${!bluetoothEnabled ? 'Bluetooth' : ''}'
            '${!bluetoothEnabled && !locationEnabled ? ' and ' : ''}'
            '${!locationEnabled ? 'Location' : ''} to scan for a scale.';
      });
      return;
    }

    final bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      setState(() {
        _isInitializing = false;
        _status = 'Bluetooth and Location permissions are required to find the weighing machine.';
      });
      return;
    }

    final ICDeviceManagerConfig config = ICDeviceManagerConfig();
    IcBluetoothSdk.instance.setDeviceManagerDelegate(this);
    IcBluetoothSdk.instance.initSDK(config);

    setState(() {
      _isInitializing = false;
      _status = 'Ready to scan for body composition devices.';
    });
  }

  Future<bool> _isBluetoothEnabled() async {
    try {
      return await _platform.invokeMethod<bool>('isBluetoothEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isLocationEnabled() async {
    try {
      return await _platform.invokeMethod<bool>('isLocationEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _requestPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await <Permission>[
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

    final bool bluetoothScanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? true;
    final bool bluetoothConnectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? true;
    final bool locationGranted = (statuses[Permission.location]?.isGranted ?? false) ||
        (statuses[Permission.locationWhenInUse]?.isGranted ?? false);

    return bluetoothScanGranted && bluetoothConnectGranted && locationGranted;
  }

  Future<void> _startScanning() async {
    final bool bluetoothEnabled = await _isBluetoothEnabled();
    final bool locationEnabled = await _isLocationEnabled();
    final bool permissionsGranted = await _requestPermissions();

    if (!bluetoothEnabled || !locationEnabled || !permissionsGranted) {
      setState(() {
        _status = 'Turn on Bluetooth and Location, then allow nearby-device permissions before scanning.';
      });
      return;
    }

    setState(() {
      _devices.clear();
      _isScanning = true;
      _status = 'Scanning for nearby scales...';
    });

    IcBluetoothSdk.instance.scanDevice(this);
    _scanTimer?.cancel();
    _scanTimer = Timer(const Duration(seconds: 30), _stopScanning);
  }

  void _stopScanning() {
    _scanTimer?.cancel();
    IcBluetoothSdk.instance.stopScan();
    if (!mounted) {
      return;
    }

    setState(() {
      _isScanning = false;
      _status = _devices.isEmpty ? 'No devices found. Turn on the scale and scan again.' : 'Scan stopped.';
    });
  }

  void _connectToDevice(ICScanDeviceInfo deviceInfo) {
    final String? macAddress = deviceInfo.macAddr;
    if (macAddress == null || macAddress.isEmpty) {
      setState(() {
        _status = 'This device did not provide a Bluetooth address.';
      });
      return;
    }

    _stopScanning();
    final ICDevice device = ICDevice(macAddress);
    _connectedDevice = device;
    IcBluetoothSdk.instance.updateUserInfo(_userInfoFromProfile());
    IcBluetoothSdk.instance.addDevice(
      device,
      ICAddDeviceCallBack(
        callBack: (ICDevice icDevice, ICAddDeviceCallBackCode code) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isConnected = code == ICAddDeviceCallBackCode.ICAddDeviceCallBackCodeSuccess;
            _status = _isConnected
                ? 'Connected. Step on the scale to receive data.'
                : 'Connection failed: $code';
          });
        },
      ),
    );

    setState(() {
      _status = 'Connecting to ${deviceInfo.name ?? macAddress}...';
    });
  }

  void _disconnectDevice() {
    final ICDevice? device = _connectedDevice;
    if (device == null) {
      return;
    }

    IcBluetoothSdk.instance.removeDevice(
      device,
      ICRemoveDeviceCallBack(
        callBack: (_, __) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isConnected = false;
            _connectedDevice = null;
            _status = 'Device disconnected.';
          });
        },
      ),
    );
  }

  ICUserInfo _userInfoFromProfile() {
    final ICUserInfo info = ICUserInfo()
      ..nickName = widget.user.name
      ..height = (widget.user.height ?? 172).round()
      ..weight = widget.user.weight ?? 60
      ..targetWeight = widget.user.weight ?? 60
      ..age = _ageFromBirthdate(widget.user.birthdate)
      ..sex = ICSexType.ICSexTypeMale;
    return info;
  }

  int _ageFromBirthdate(String? value) {
    if (value == null || value.isEmpty) {
      return 24;
    }

    final DateTime? birthdate = DateTime.tryParse(value);
    if (birthdate == null) {
      return 24;
    }

    final DateTime now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age.clamp(1, 120);
  }

  @override
  void onScanResult(ICScanDeviceInfo deviceInfo) {
    final String? macAddress = deviceInfo.macAddr;
    if (macAddress == null || macAddress.isEmpty) {
      return;
    }

    setState(() {
      final bool exists = _devices.any((ICScanDeviceInfo device) => device.macAddr == macAddress);
      if (!exists) {
        _devices.add(deviceInfo);
      }
      _status = '${_devices.length} device${_devices.length == 1 ? '' : 's'} found.';
    });
  }

  @override
  void onInitFinish(bool bSuccess) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = bSuccess ? 'Body composition SDK initialized.' : 'Body composition SDK failed to initialize.';
    });
  }

  @override
  void onBleState(ICBleState state) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Bluetooth state: $state';
    });
  }

  @override
  void onDeviceConnectionChanged(ICDevice device, ICDeviceConnectState state) {
    if (!mounted) {
      return;
    }
    setState(() {
      _isConnected = state == ICDeviceConnectState.ICDeviceConnectStateConnected;
      _status = _isConnected ? 'Device connected.' : 'Device disconnected.';
    });
  }

  @override
  void onReceiveWeightData(ICDevice device, ICWeightData data) {
    if (!mounted) {
      return;
    }
    setState(() {
      _lastData = data;
      _status = data.isStabilized ? 'Stable measurement received.' : 'Measuring... keep standing still.';
    });
  }

  BodyCompositionReading _readingFromWeightData(ICWeightData data) {
    return BodyCompositionReading(
      weight: data.weight_kg,
      bmi: data.bmi,
      bodyFat: data.bodyFatPercent,
      subcutaneousFat: data.subcutaneousFatPercent,
      visceralFat: data.visceralFat,
      muscleMass: data.musclePercent,
      skeletalMuscle: data.smPercent,
      muscleRate: data.musclePercent,
      waterContent: data.moisturePercent,
      protein: data.proteinPercent,
      bmr: data.bmr.toDouble(),
      boneMass: data.boneMass,
      physicalAge: data.physicalAge,
      bodyScore: data.bodyScore,
    );
  }

  void _useLatestReading() {
    final ICWeightData? data = _lastData;
    final ValueChanged<BodyCompositionReading>? callback = widget.onReadingCaptured;
    if (data == null || callback == null) {
      return;
    }

    callback(_readingFromWeightData(data));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      children: <Widget>[
        const _BodyCompositionHeader(),
        const SizedBox(height: 26),
        _BodyStatusCard(
          status: _status,
          isConnected: _isConnected,
          isScanning: _isScanning,
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Expanded(
              child: _BodyActionButton(
                label: _isScanning ? 'STOP SCAN' : 'SCAN DEVICES',
                icon: _isScanning ? Icons.stop_rounded : Icons.bluetooth_searching_rounded,
                foregroundColor: const Color(0xFF252525),
                backgroundColor: const Color(0xFFB7FF00),
                onTap: _isInitializing
                    ? () {}
                    : _isScanning
                        ? _stopScanning
                        : () => _startScanning(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BodyActionButton(
                label: _isConnected ? 'DISCONNECT' : 'BACK',
                icon: _isConnected ? Icons.link_off_rounded : Icons.arrow_back_rounded,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF2A2A2A),
                onTap: _isConnected ? _disconnectDevice : widget.onBack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_lastData != null) ...<Widget>[
          _WeightResultCard(data: _lastData!),
          if (widget.onReadingCaptured != null) ...<Widget>[
            const SizedBox(height: 12),
            _BodyActionButton(
              label: 'USE IN CHECK-IN',
              icon: Icons.check_rounded,
              foregroundColor: const Color(0xFF252525),
              backgroundColor: const Color(0xFFB7FF00),
              onTap: _lastData!.isStabilized
                  ? _useLatestReading
                  : () {
                      setState(() {
                        _status = 'Wait for a stable measurement before using this reading.';
                      });
                    },
            ),
          ],
          const SizedBox(height: 24),
        ],
        if (_devices.isNotEmpty) ...<Widget>[
          const _BodySectionTitle(title: 'NEARBY SCALES'),
          const SizedBox(height: 12),
          ..._devices.map((ICScanDeviceInfo device) {
            return _ScaleDeviceCard(
              device: device,
              onConnect: () => _connectToDevice(device),
            );
          }),
        ] else if (!_isScanning) ...<Widget>[
          const _BodyHintCard(),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    IcBluetoothSdk.instance.stopScan();
    IcBluetoothSdk.instance.setDeviceManagerDelegate(null);
    super.dispose();
  }

  @override
  void onNodeConnectionChanged(ICDevice device, int nodeId, ICDeviceConnectState state) {}
  @override
  void onReceiveKitchenScaleData(ICDevice device, ICKitchenScaleData data) {}
  @override
  void onReceiveKitchenScaleUnitChanged(ICDevice device, ICKitchenScaleUnit unit) {}
  @override
  void onReceiveCoordData(ICDevice device, ICCoordData data) {}
  @override
  void onReceiveRulerData(ICDevice device, ICRulerData data) {}
  @override
  void onReceiveRulerHistoryData(ICDevice device, ICRulerData data) {}
  @override
  void onReceiveWeightCenterData(ICDevice device, ICWeightCenterData data) {}
  @override
  void onReceiveWeightUnitChanged(ICDevice device, ICWeightUnit unit) {}
  @override
  void onReceiveRulerUnitChanged(ICDevice device, ICRulerUnit unit) {}
  @override
  void onReceiveRulerMeasureModeChanged(ICDevice device, ICRulerMeasureMode mode) {}
  @override
  void onReceiveMeasureStepData(ICDevice device, ICMeasureStep step, Object data) {}
  @override
  void onReceiveWeightHistoryData(ICDevice device, ICWeightHistoryData data) {}
  @override
  void onReceiveSkipData(ICDevice device, ICSkipData data) {}
  @override
  void onReceiveHistorySkipData(ICDevice device, ICSkipData data) {}
  @override
  void onReceiveBattery(ICDevice device, int battery, Object ext) {}
  @override
  void onReceiveUpgradePercent(ICDevice device, ICUpgradeStatus status, int percent) {}
  @override
  void onReceiveDeviceInfo(ICDevice device, ICDeviceInfo deviceInfo) {}
  @override
  void onReceiveDebugData(ICDevice device, int type, Object obj) {}
  @override
  void onReceiveConfigWifiResult(ICDevice device, ICConfigWifiState state) {}
  @override
  void onReceiveHR(ICDevice device, int hr) {}
}

class _BodyCompositionHeader extends StatelessWidget {
  const _BodyCompositionHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'BODY COMPOSITION',
          style: TextStyle(
            color: Color(0xFFB7FF00),
            fontSize: 22,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        SizedBox(height: 36),
        Text(
          'CONNECT YOUR SCALE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Capture weight, BMI, and body metrics.',
          style: TextStyle(
            color: Color(0xFFA4A4A4),
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _BodyStatusCard extends StatelessWidget {
  const _BodyStatusCard({
    required this.status,
    required this.isConnected,
    required this.isScanning,
  });

  final String status;
  final bool isConnected;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    final String label = isConnected
        ? 'Connected'
        : isScanning
            ? 'Scanning'
            : 'Device Status';
    final IconData icon = isConnected
        ? Icons.bluetooth_connected_rounded
        : isScanning
            ? Icons.radar_rounded
            : Icons.monitor_weight_outlined;

    return Container(
      height: 224,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: <Widget>[
            const Positioned(
              right: -38,
              top: 8,
              child: _RibbedChallengeOrb(
                size: 178,
                tint: Color(0xFF324D5B),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: <Color>[
                      Colors.black.withValues(alpha: 0.10),
                      const Color(0xFF1F1F1F),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7FF00).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: const Color(0xFFB7FF00), size: 28),
                  ),
                  const Spacer(),
                  _BodyPill(label: label),
                  const SizedBox(height: 14),
                  Text(
                    status,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyPill extends StatelessWidget {
  const _BodyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF60382F),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFF8F72),
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.4,
        ),
      ),
    );
  }
}

class _BodyActionButton extends StatelessWidget {
  const _BodyActionButton({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 19),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}

class _BodySectionTitle extends StatelessWidget {
  const _BodySectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ScaleDeviceCard extends StatelessWidget {
  const _ScaleDeviceCard({
    required this.device,
    required this.onConnect,
  });

  final ICScanDeviceInfo device;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final String name = device.name?.isNotEmpty == true ? device.name! : 'Unknown Scale';
    final String address = device.macAddr ?? 'No address';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onConnect,
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFFB7FF00)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$address - RSSI ${device.rssi}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFA4A4A4),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFB7FF00)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyHintCard extends StatelessWidget {
  const _BodyHintCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.info_outline_rounded, color: Color(0xFFB7FF00)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Turn on your scale, keep it nearby, then scan for devices.',
              style: TextStyle(
                color: Color(0xFFA4A4A4),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightResultCard extends StatelessWidget {
  const _WeightResultCard({required this.data});

  final ICWeightData data;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[
      _MetricTile(label: 'BMI', value: data.bmi.toStringAsFixed(1)),
      _MetricTile(label: 'BODY FAT', value: '${data.bodyFatPercent.toStringAsFixed(1)}%'),
      _MetricTile(
        label: 'SUBCUTANEOUS',
        value: '${data.subcutaneousFatPercent.toStringAsFixed(1)}%',
      ),
      _MetricTile(label: 'VISCERAL FAT', value: data.visceralFat.toStringAsFixed(1)),
      _MetricTile(label: 'WATER', value: '${data.moisturePercent.toStringAsFixed(1)}%'),
      _MetricTile(label: 'SKELETAL MUSCLE', value: '${data.smPercent.toStringAsFixed(1)}%'),
      _MetricTile(label: 'PROTEIN', value: '${data.proteinPercent.toStringAsFixed(1)}%'),
      _MetricTile(label: 'MUSCLE RATE', value: '${data.musclePercent.toStringAsFixed(1)}%'),
      _MetricTile(label: 'BMR', value: '${data.bmr}', suffix: 'KCAL'),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'LATEST READING',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              _BodyPill(label: data.isStabilized ? 'Stable' : 'Measuring'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            data.weight_kg.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xFFB7FF00),
              fontSize: 50,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'KG',
            style: TextStyle(
              color: Color(0xFFA4A4A4),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 22),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: rows,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.suffix,
  });

  final String label;
  final String value;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFA4A4A4),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              if (suffix != null) ...<Widget>[
                const SizedBox(width: 4),
                Text(
                  suffix!,
                  style: const TextStyle(
                    color: Color(0xFFB7FF00),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
