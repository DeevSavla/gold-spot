part of '../main.dart';

const Color _kineticNeon = Color(0xFFD7FF00);
const Color _authBlack = Color(0xFF080808);
const Color _authPanel = Color(0xFF1F1F1F);
const Color _authPanelDark = Color(0xFF141414);

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.initialRole,
    required this.onBack,
    required this.onSignup,
    required this.onSubmit,
  });

  final AuthRole? initialRole;
  final VoidCallback onBack;
  final VoidCallback onSignup;
  final Future<void> Function(LoginPayload payload) onSubmit;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorText;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _handleLogin() async {
    final String email = _normalizedEmail;
    final String password = _passwordController.text;
    final AuthRole role = widget.initialRole ?? AuthRole.user;

    setState(() {
      if (email.isNotEmpty && !_isValidEmail(email)) {
        _errorText = 'Enter a valid email address';
      } else if (email.isNotEmpty && !_isAllowedEmailProvider(email)) {
        _errorText = 'Use valid email address';
      } else if (password.isEmpty) {
        _errorText = 'Enter your password';
      } else {
        _errorText = null;
      }
    });

    if (_errorText != null) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await widget.onSubmit(
        LoginPayload(
          email: email,
          password: password,
          role: role,
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
          _errorText = 'Login failed unexpectedly: $error';
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

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    final bool isTrainer = widget.initialRole == AuthRole.trainer;
    const Color accentColor = _kineticNeon;

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
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isTablet = constraints.maxWidth >= 700;
            final double horizontalPadding = isTablet ? 32 : 20;
            final double contentWidth = isTablet ? 560 : constraints.maxWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                viewPadding.top + 20,
                horizontalPadding,
                viewPadding.bottom + 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: _authPanel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.18)),
                        ),
                        child: IconButton(
                          onPressed: widget.onBack,
                          icon: const Icon(Icons.arrow_back),
                          color: AppPalette.text,
                          tooltip: 'Back',
                        ),
                      ),
                      const SizedBox(height: 26),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: _authPanelDark,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accentColor.withValues(alpha: 0.48)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.2),
                              blurRadius: 34,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                                  ),
                                  child: Icon(
                                    isTrainer ? Icons.workspace_premium : Icons.bolt,
                                    color: accentColor,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                                color: AppPalette.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Enter your credentials to continue your training flow.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: AppPalette.mutedText,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _AuthField(
                              label: 'EMAIL',
                              controller: _emailController,
                              hintText: 'you@example.com',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            _AuthField(
                              label: 'PASSWORD',
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                            ),
                            if (_errorText != null) ...<Widget>[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppPalette.danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppPalette.danger.withValues(alpha: 0.35),
                                  ),
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
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitting ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: accentColor.withValues(alpha: 0.45),
                                  padding: const EdgeInsets.symmetric(vertical: 17),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (_submitting) ...<Widget>[
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    Text(
                                      _submitting ? 'LOGGING IN' : 'LOGIN',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.4,
                                      ),
                                    ),
                                    if (!_submitting) ...<Widget>[
                                      const SizedBox(width: 10),
                                      const Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: _authPanel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.12)),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: Text(
                                'New here?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.mutedText,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: widget.onSignup,
                              icon: const Icon(Icons.person_add_alt_1, size: 18),
                              label: Text('Create account'),
                              style: TextButton.styleFrom(
                                foregroundColor: accentColor,
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
            color: _kineticNeon,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          minLines: maxLines > 1 ? maxLines : 1,
          onChanged: (_) => onChanged?.call(),
          cursorColor: _kineticNeon,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppPalette.text,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(154, 166, 187, 0.48),
              fontWeight: FontWeight.w700,
            ),
            filled: true,
            fillColor: _authPanel,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _kineticNeon, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppPalette.danger),
            ),
          ),
        ),
      ],
    );
  }
}
