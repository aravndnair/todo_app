import 'package:flutter/material.dart';
import '../components/glass_card.dart';
import '../components/auth_form.dart';
import '../components/success_animation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = true;
  bool _showSuccess = false;

  void _handleToggle() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _handleSubmit(Map<String, String> data) {
    print('Form submitted: $data');
    setState(() {
      _showSuccess = true;
    });
  }

  void _handleSuccessComplete() {
    setState(() {
      _showSuccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                      ),
                      child: GlassCard(
                        borderRadius: 24.0,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App Icon
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

                              // Title
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF007AFF),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              
                              const SizedBox(height: 8),

                              // Subtitle
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

                              const SizedBox(height: 32),

                              // Auth Form
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
            }
          ),
        ),
      ),
    );
  }
}