part of '../main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.initialRole,
    required this.onBack,
    required this.onSubmit,
    required this.onLogin,
  });

  final AuthRole? initialRole;
  final VoidCallback onBack;
  final Future<void> Function(SignupPayload payload) onSubmit;
  final VoidCallback onLogin;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  int _step = 0;
  late AuthRole _role = widget.initialRole ?? AuthRole.user;
  bool _showPassword = false;
  bool _submitting = false;
  String? _errorText;
  DateTime? _birthdate;
  String _focus = 'endurance';
  int _weeklyDays = 3;
  SignupImageFile? _profileImage;

  @override
  void didUpdateWidget(covariant SignupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRole != null && widget.initialRole != oldWidget.initialRole) {
      _role = widget.initialRole!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String get _normalizedEmail => _emailController.text.trim().toLowerCase();

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email);
  }

  bool _isAllowedEmailProvider(String email) {
    final int atIndex = email.lastIndexOf('@');
    if (atIndex == -1 || atIndex == email.length - 1) {
      return false;
    }

    final String domain = email.substring(atIndex + 1);
    return domain.contains('.') && !domain.startsWith('.') && !domain.endsWith('.');
  }

  int? _calculateAge(DateTime? birthdate) {
    if (birthdate == null) {
      return null;
    }

    final DateTime today = DateTime.now();
    int age = today.year - birthdate.year;
    final bool beforeBirthday =
        today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day);
    if (beforeBirthday) {
      age -= 1;
    }
    return age >= 0 ? age : null;
  }

  String? _validateStepOne() {
    if (_nameController.text.trim().length < 2) {
      return 'Enter your name';
    }
    if (_normalizedEmail.isEmpty) {
      return 'Enter your email';
    }
    if (!_isValidEmail(_normalizedEmail)) {
      return 'Enter a valid email address';
    }
    if (!_isAllowedEmailProvider(_normalizedEmail)) {
      return 'Use a valid email provider';
    }
    if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateStepTwo() {
    final double? height = double.tryParse(_heightController.text.trim());
    final double? weight = double.tryParse(_weightController.text.trim());
    if (height == null || height < 50 || height > 300) {
      return 'Height must be between 50 and 300 cm';
    }
    if (weight == null || weight < 20 || weight > 500) {
      return 'Weight must be between 20 and 500 kg';
    }
    if (_birthdate == null || _calculateAge(_birthdate) == null) {
      return 'Select a valid birthdate';
    }
    return null;
  }

  Future<void> _pickBirthdate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) {
      return;
    }

    final Uint8List bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() {
      _profileImage = SignupImageFile(
        filename: file.name,
        bytes: bytes,
      );
    });
  }

  void _openNextStep() {
    final String? message = _step == 0 ? _validateStepOne() : _validateStepTwo();
    if (message != null) {
      setState(() {
        _errorText = message;
      });
      return;
    }

    setState(() {
      _errorText = null;
      _step += 1;
    });
  }

  void _goBack() {
    setState(() {
      _errorText = null;
      if (_step > 0) {
        _step -= 1;
      } else {
        widget.onBack();
      }
    });
  }

  Future<void> _submitSignup() async {
    final String? stepOneError = _validateStepOne();
    final String? stepTwoError = _validateStepTwo();
    final String? message = stepOneError ?? stepTwoError;
    if (message != null) {
      setState(() {
        _errorText = message;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });

    try {
      await widget.onSubmit(
        SignupPayload(
          name: _nameController.text.trim(),
          email: _normalizedEmail,
          password: _passwordController.text,
          role: _role,
          height: double.parse(_heightController.text.trim()),
          weight: double.parse(_weightController.text.trim()),
          birthdate: _formatBirthdateForApi(_birthdate!),
          focus: _focus,
          weeklyDays: _weeklyDays,
          bio: _bioController.text.trim(),
          profileImage: _profileImage,
        ),
      );
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorText = error.message;
        });
      }
    } on BackendConnectionException catch (error) {
      if (mounted) {
        setState(() {
          _errorText = error.message;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorText = 'Signup failed unexpectedly: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  String _formatBirthdateForApi(DateTime value) {
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
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

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    final List<String> focusOptions = <String>['endurance', 'strength', 'mobility', 'nutrition'];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.black,
            _authBlack,
            Colors.black,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isTablet = constraints.maxWidth >= 720;
          final double maxWidth = isTablet ? 620 : constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, viewPadding.top + 20, 20, viewPadding.bottom + 40),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: _authPanel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.18)),
                        ),
                        child: IconButton(
                          onPressed: _goBack,
                          icon: const Icon(Icons.arrow_back),
                          color: AppPalette.text,
                          tooltip: 'Back',
                        ),
                      ),
                      Text(
                        'STEP ${_step + 1} OF 3',
                        style: const TextStyle(
                          color: _kineticNeon,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List<Widget>.generate(3, (int index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                          height: 6,
                          decoration: BoxDecoration(
                            color: index <= _step ? _kineticNeon : _authPanel,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: index <= _step
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: _kineticNeon.withValues(alpha: 0.28),
                                      blurRadius: 16,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: _authPanelDark,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _kineticNeon.withValues(alpha: 0.48)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: _kineticNeon.withValues(alpha: 0.18),
                          blurRadius: 34,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'CREATE YOUR ACCOUNT',
                          style: TextStyle(
                            color: _kineticNeon,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _step == 0
                              ? 'Let\'s start with the basics.'
                              : _step == 1
                              ? 'Tell us about your body metrics.'
                              : 'Finish your training setup.',
                          style: const TextStyle(
                            color: AppPalette.text,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _step == 0
                              ? 'Your account details come first, then we will guide you through the rest of onboarding.'
                              : _step == 1
                              ? 'We will use these details to personalize your profile.'
                              : 'Pick your focus, weekly commitment, and optional profile photo.',
                          style: const TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_step == 0) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _RoleSelectorButton(
                            label: 'USER',
                            selected: _role == AuthRole.user,
                            onTap: () => setState(() => _role = AuthRole.user),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RoleSelectorButton(
                            label: 'TRAINER',
                            selected: _role == AuthRole.trainer,
                            onTap: () => setState(() => _role = AuthRole.trainer),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _AuthField(
                      label: 'NAME',
                      controller: _nameController,
                      hintText: _role == AuthRole.trainer ? 'Trainer name' : 'Your name',
                    ),
                    const SizedBox(height: 12),
                    _AuthField(
                      label: 'EMAIL',
                      controller: _emailController,
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _AuthField(
                      label: 'PASSWORD',
                      controller: _passwordController,
                      hintText: 'At least 6 characters',
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ),
                    ),
                  ],
                  if (_step == 1) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _AuthField(
                            label: 'HEIGHT (CM)',
                            controller: _heightController,
                            hintText: '175',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AuthField(
                            label: 'WEIGHT (KG)',
                            controller: _weightController,
                            hintText: '70',
                            keyboardType: TextInputType.number,
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
                        color: _kineticNeon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickBirthdate,
                      borderRadius: BorderRadius.circular(14),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: _authPanel,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _formatBirthdateLabel(),
                              style: TextStyle(
                                color: _birthdate == null ? AppPalette.mutedText : AppPalette.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Icon(Icons.calendar_month, color: _kineticNeon),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_step == 2) ...<Widget>[
                    const Text(
                      'FOCUS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: _kineticNeon,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: focusOptions.map((String option) {
                        final bool selected = _focus == option;
                        return GestureDetector(
                          onTap: () => setState(() => _focus = option),
                          child: Container(
                            width: isTablet ? 286 : (maxWidth - 50) / 2,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: selected ? _kineticNeon : _authPanel,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected ? _kineticNeon : const Color.fromRGBO(215, 255, 0, 0.12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                option.toUpperCase(),
                                style: TextStyle(
                                  color: selected ? Colors.black : AppPalette.mutedText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
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
                        color: _kineticNeon,
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
                          onTap: () => setState(() => _weeklyDays = day),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: selected ? _kineticNeon : _authPanel,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? _kineticNeon : const Color.fromRGBO(215, 255, 0, 0.12),
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
                      label: 'BIO (OPTIONAL)',
                      controller: _bioController,
                      hintText: 'What do you want to achieve?',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PROFILE PICTURE (OPTIONAL)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: _kineticNeon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickProfileImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _authPanel,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.12)),
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: _kineticNeon.withValues(alpha: 0.18),
                              backgroundImage:
                                  _profileImage == null ? null : MemoryImage(_profileImage!.bytes),
                              child: _profileImage == null
                                  ? const Icon(Icons.person, color: _kineticNeon)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _profileImage == null
                                    ? 'Tap to choose a profile picture'
                                    : _profileImage!.filename,
                                style: const TextStyle(
                                  color: AppPalette.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppPalette.mutedText),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (_errorText != null) ...<Widget>[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppPalette.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppPalette.danger.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        _errorText!,
                        style: const TextStyle(
                          color: AppPalette.danger,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting
                          ? null
                          : _step < 2
                          ? _openNextStep
                          : _submitSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kineticNeon,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: _kineticNeon.withValues(alpha: 0.45),
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        _step < 2
                            ? 'NEXT'
                            : _submitting
                            ? 'CREATING ACCOUNT...'
                            : 'CREATE ACCOUNT',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.mutedText,
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: _kineticNeon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
          );
        },
      ),
    );
  }
}

