import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/glass_card.dart';
import 'components/auth_form.dart';
import 'components/confetti_success.dart';
import 'services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = true;
  bool _showSuccess = false;
  String _errorMessage = '';

  void _handleToggle() {
    setState(() {
      _isSignUp = !_isSignUp;
      _errorMessage = '';
    });
  }

  void _handleSubmit(Map<String, String> data) async {
    setState(() {
      _errorMessage = '';
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      if (_isSignUp) {
        await authService.signUp(data['email']!, data['password']!);
        setState(() {
          _showSuccess = true;
        });
      } else {
        await authService.signIn(data['email']!, data['password']!);
        _navigateToWelcome();
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getFirebaseErrorMessage(e.toString());
      });
    }
  }

  String _getFirebaseErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('user-not-found') || error.contains('wrong-password')) {
      return 'Invalid email or password';
    }
    return 'An error occurred. Please try again.';
  }

  void _handleSuccessComplete() {
    setState(() {
      _showSuccess = false;
    });
    Navigator.pushReplacementNamed(context, '/username');
  }

  void _navigateToWelcome() {
    Navigator.of(context).pushReplacementNamed('/greeting');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F4FD),
                  Color(0xFFD6EBFA),
                  Color(0xFFC4E2F7),
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: GlassCard(
                            borderRadius: 24.0,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/TodoLogo.png',
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  const Text(
                                    'Stride',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF007AFF),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isSignUp
                                        ? 'Sign up to get started'
                                        : 'Welcome back! Please sign in',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  if (_errorMessage.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  AuthForm(
                                    isSignUp: _isSignUp,
                                    onToggle: _handleToggle,
                                    onSubmit: _handleSubmit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_showSuccess)
            ConfettiSuccess(
              onComplete: _handleSuccessComplete,
              message: 'Success!',
            ),
        ],
      ),
    );
  }
}
