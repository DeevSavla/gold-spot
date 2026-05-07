part of '../main.dart';

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
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorText = 'Unable to reach the backend. Check that the server is running.';
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
    final String subtitle = widget.initialRole == null
        ? 'Welcome back'
        : 'Sign in as ${isTrainer ? 'Trainer' : 'User'}';

    return SafeArea(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: widget.onBack,
                          icon: const Icon(Icons.arrow_back),
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: AppPalette.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                      hintText: '••••••••',
                      obscureText: true,
                    ),
                    if (_errorText != null) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(
                        _errorText!,
                        style: const TextStyle(
                          color: AppPalette.danger,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primary,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: AppPalette.primary.withValues(alpha: 0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          _submitting ? 'LOGGING IN...' : 'LOGIN',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.mutedText,
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onSignup,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppPalette.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: widget.onSignup,
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.06)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Create ${isTrainer ? 'Trainer' : 'User'} account',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppPalette.mutedText,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Color.fromRGBO(209, 252, 0, 0.9),
                            ),
                          ],
                        ),
                      ),
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
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppPalette.mutedText,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.text,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color.fromRGBO(173, 170, 170, 0.45)),
            filled: true,
            fillColor: AppPalette.surfaceAlt,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppPalette.primary),
            ),
          ),
        ),
      ],
    );
  }
}

