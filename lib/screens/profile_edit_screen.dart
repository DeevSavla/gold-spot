part of '../main.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    super.key,
    required this.user,
    required this.onBack,
    required this.onSave,
    required this.onUploadProfilePicture,
  });

  final AuthUser user;
  final VoidCallback onBack;
  final Future<void> Function(ProfileUpdatePayload payload) onSave;
  final Future<void> Function(SignupImageFile image) onUploadProfilePicture;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _nameController = TextEditingController(text: widget.user.name);
  late final TextEditingController _heightController =
      TextEditingController(text: widget.user.height?.toStringAsFixed(0) ?? '');
  late final TextEditingController _weightController =
      TextEditingController(text: widget.user.weight?.toStringAsFixed(0) ?? '');
  late final TextEditingController _bioController = TextEditingController(text: widget.user.bio);

  DateTime? _birthdate;
  late String _focus = widget.user.focus;
  late int _weeklyDays = widget.user.weeklyDays;
  bool _dirty = false;
  bool _uploadingPhoto = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.user.birthdate != null) {
      _birthdate = DateTime.tryParse(widget.user.birthdate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String _formatBirthdateLabel() {
    if (_birthdate == null) {
      return 'Select your birthdate';
    }
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_birthdate!.month - 1]} ${_birthdate!.day}, ${_birthdate!.year}';
  }

  String _formatBirthdateApi() {
    final DateTime value = _birthdate!;
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String _ageLabel() {
    if (_birthdate == null) {
      return '--';
    }
    final DateTime now = DateTime.now();
    int age = now.year - _birthdate!.year;
    if (now.month < _birthdate!.month ||
        (now.month == _birthdate!.month && now.day < _birthdate!.day)) {
      age -= 1;
    }
    return age >= 0 ? '$age' : '--';
  }

  Future<void> _pickBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB7FF00),
              onPrimary: Color(0xFF252525),
              surface: Color(0xFF1F1F1F),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1F1F1F),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFB7FF00),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
        _dirty = true;
      });
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) {
      return;
    }

    setState(() {
      _uploadingPhoto = true;
    });
    try {
      await widget.onUploadProfilePicture(
        SignupImageFile(
          filename: file.name,
          bytes: await file.readAsBytes(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your profile picture has been updated.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final double? height = double.tryParse(_heightController.text.trim());
    final double? weight = double.tryParse(_weightController.text.trim());
    if (_nameController.text.trim().length < 2) {
      _showError('Enter a valid name');
      return;
    }
    if (height == null || height < 50 || height > 300) {
      _showError('Height must be between 50 and 300 cm');
      return;
    }
    if (weight == null || weight < 20 || weight > 500) {
      _showError('Weight must be between 20 and 500 kg');
      return;
    }
    if (_birthdate == null) {
      _showError('Select your birthdate');
      return;
    }

    setState(() {
      _saving = true;
    });
    try {
      await widget.onSave(
        ProfileUpdatePayload(
          name: _nameController.text.trim(),
          height: height,
          weight: weight,
          birthdate: _formatBirthdateApi(),
          focus: _focus,
          weeklyDays: _weeklyDays,
          bio: _bioController.text.trim(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your profile has been updated.')),
        );
        widget.onBack();
      }
    } on ApiException catch (error) {
      _showError(error.message);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _dirty = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        widget.user.profile_pic ?? 'https://via.placeholder.com/200x200.png?text=Profile';
    const Map<String, String> focusLabel = <String, String>{
      'endurance': 'ENDURANCE',
      'strength': 'STRENGTH',
      'mobility': 'MOBILITY',
      'nutrition': 'NUTRITION',
    };

    return Scaffold(
      backgroundColor: AppPalette.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 380;
          final double horizontalPadding = compact ? 16 : 24;

          return ListView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 140),
            children: <Widget>[
              _ProfileEditTopBar(onBack: widget.onBack),
              SizedBox(height: compact ? 22 : 26),
              const _ProfileEditHeader(),
              SizedBox(height: compact ? 20 : 24),
              _ProfilePhotoEditCard(
                imageUrl: imageUrl,
                uploading: _uploadingPhoto,
                onPickPhoto: _uploadingPhoto ? () {} : _pickAndUploadPhoto,
              ),
              SizedBox(height: compact ? 20 : 24),
              _ProfileEditPanel(
                title: 'PERSONAL DETAILS',
              children: <Widget>[
                _AuthField(
                  label: 'NAME',
                  controller: _nameController,
                  hintText: 'Your name',
                  onChanged: () => setState(() => _dirty = true),
                ),
                const SizedBox(height: 12),
                if (compact)
                  Column(
                    children: <Widget>[
                      _AuthField(
                        label: 'HEIGHT (CM)',
                        controller: _heightController,
                        hintText: '175',
                        keyboardType: TextInputType.number,
                        onChanged: () => setState(() => _dirty = true),
                      ),
                      const SizedBox(height: 12),
                      _AuthField(
                        label: 'WEIGHT (KG)',
                        controller: _weightController,
                        hintText: '70',
                        keyboardType: TextInputType.number,
                        onChanged: () => setState(() => _dirty = true),
                      ),
                    ],
                  )
                else
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _AuthField(
                          label: 'HEIGHT (CM)',
                          controller: _heightController,
                          hintText: '175',
                          keyboardType: TextInputType.number,
                          onChanged: () => setState(() => _dirty = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AuthField(
                          label: 'WEIGHT (KG)',
                          controller: _weightController,
                          hintText: '70',
                          keyboardType: TextInputType.number,
                          onChanged: () => setState(() => _dirty = true),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                const Text(
                  'BIRTHDATE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppPalette.mutedText,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickBirthdate,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppPalette.surfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppPalette.border),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _formatBirthdateLabel(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _birthdate == null ? AppPalette.mutedText : AppPalette.text,
                              fontSize: compact ? 14 : 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_month, color: Color(0xFFB7FF00)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPalette.surfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'AGE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppPalette.mutedText,
                        ),
                      ),
                      Text(
                        _ageLabel(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB7FF00),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              SizedBox(height: compact ? 20 : 24),
              _ProfileEditPanel(
                title: 'TRAINING SETUP',
              children: <Widget>[
                const Text(
                  'FOCUS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppPalette.mutedText,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: focusLabel.entries.map((MapEntry<String, String> entry) {
                    final bool selected = _focus == entry.key;
                    return SizedBox(
                      width: compact ? double.infinity : 160,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _focus = entry.key;
                          _dirty = true;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFFB7FF00) : AppPalette.surfaceAlt,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: selected ? const Color(0xFFB7FF00) : AppPalette.border),
                          ),
                          child: Center(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                color: selected ? Colors.black : AppPalette.mutedText,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'WEEKLY TRAINING DAYS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppPalette.mutedText,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List<Widget>.generate(7, (int index) {
                    final int day = index + 1;
                    final bool selected = _weeklyDays == day;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _weeklyDays = day;
                        _dirty = true;
                      }),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? const Color(0xFFB7FF00) : const Color(0xFF272727),
                          border: Border.all(
                            color: selected ? const Color(0xFFB7FF00) : const Color(0x22FFFFFF),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: selected ? Colors.black : AppPalette.mutedText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                _AuthField(
                  label: 'BIO',
                  controller: _bioController,
                  hintText: 'What do you want to achieve?',
                  maxLines: 5,
                  onChanged: () => setState(() => _dirty = true),
                ),
              ],
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.sizeOf(context).width < 380 ? 16 : 24,
          12,
          MediaQuery.sizeOf(context).width < 380 ? 16 : 24,
          16,
        ),
        decoration: const BoxDecoration(
          color: AppPalette.background,
          border: Border(top: BorderSide(color: AppPalette.border)),
        ),
        child: _ProfileEditSaveButton(
          label: _saving ? 'SAVING...' : 'SAVE CHANGES',
          onTap: (!_dirty || _saving) ? () {} : _saveProfile,
          enabled: _dirty && !_saving,
        ),
      ),
    );
  }
}

class _ProfileEditTopBar extends StatelessWidget {
  const _ProfileEditTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          color: const Color(0xFF2A2A2A),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
        const Spacer(),
        const Text(
          'EDIT PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 40, height: 40),
      ],
    );
  }
}

class _ProfileEditHeader extends StatelessWidget {
  const _ProfileEditHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PERSONAL DETAILS',
              style: TextStyle(
                color: const Color(0xFFB7FF00),
                fontSize: compact ? 19 : 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            SizedBox(height: compact ? 30 : 36),
            Text(
              'UPDATE YOUR PROFILE',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 22 : 25,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Keep your account and training data current.',
              style: TextStyle(
                color: const Color(0xFFA4A4A4),
                fontSize: compact ? 15 : 17,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfilePhotoEditCard extends StatelessWidget {
  const _ProfilePhotoEditCard({
    required this.imageUrl,
    required this.uploading,
    required this.onPickPhoto,
  });

  final String imageUrl;
  final bool uploading;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;
        final double avatarSize = compact ? 86 : 104;

        return Container(
          constraints: BoxConstraints(minHeight: compact ? 174 : 190),
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
                Positioned(
                  right: compact ? -42 : -34,
                  top: compact ? 24 : 12,
                  child: _RibbedChallengeOrb(
                    size: compact ? 132 : 162,
                    tint: const Color(0xFF344D39),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.12),
                          const Color(0xFF1F1F1F),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(compact ? 18 : 22),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB7FF00), width: 2),
                        ),
                        child: _ProfileAvatar(imageUrl: imageUrl, radius: (avatarSize - 6) / 2),
                      ),
                      SizedBox(width: compact ? 16 : 20),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _ProfileEditPill(label: 'Photo'),
                            const SizedBox(height: 14),
                            const SizedBox(height: 14),
                            _ProfileEditSmallButton(
                              label: uploading ? 'UPLOADING...' : 'CHANGE PHOTO',
                              onTap: onPickPhoto,
                              compact: compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileEditPanel extends StatelessWidget {
  const _ProfileEditPanel({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Container(
          padding: EdgeInsets.all(compact ? 18 : 22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFB7FF00),
                  fontSize: compact ? 11 : 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        );
      },
    );
  }
}

class _ProfileEditPill extends StatelessWidget {
  const _ProfileEditPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF60382F),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFF8F72),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _ProfileEditSmallButton extends StatelessWidget {
  const _ProfileEditSmallButton({
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 42 : 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFB7FF00),
          foregroundColor: const Color(0xFF252525),
          padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _ProfileEditSaveButton extends StatelessWidget {
  const _ProfileEditSaveButton({
    required this.label,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: enabled ? const Color(0xFFB7FF00) : const Color(0xFF2A2A2A),
          foregroundColor: enabled ? const Color(0xFF252525) : const Color(0xFF777777),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
