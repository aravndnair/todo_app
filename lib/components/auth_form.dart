import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ios_text_field.dart';
import 'ios_button.dart';

class AuthForm extends StatefulWidget {
  final bool isSignUp;
  final VoidCallback onToggle;
  final Function(Map<String, String>) onSubmit;

  const AuthForm({
    super.key,
    required this.isSignUp,
    required this.onToggle,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.isSignUp) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        } else {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        }
        widget.onSubmit({
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          IOSTextField(
            controller: _emailController,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password Field
          IOSTextField(
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          // Confirm Password Field (only for sign up)
          if (widget.isSignUp) ...[
            const SizedBox(height: 16),
            IOSTextField(
              controller: _confirmPasswordController,
              placeholder: 'Confirm Password',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],

          const SizedBox(height: 32),

          // Submit Button
          IOSButton(
            text: widget.isSignUp ? 'Sign Up' : 'Sign In',
            onPressed: _handleSubmit,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 24),

          // Toggle Sign Up/Sign In
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isSignUp 
                  ? 'Already have an account? '
                  : "Don't have an account? ",
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: widget.onToggle,
                child: Text(
                  widget.isSignUp ? 'Login' : 'Sign Up',
                  style: const TextStyle(
                    color: Color(0xFF007AFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}