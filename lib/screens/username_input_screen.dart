import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsernameInputScreen extends StatefulWidget {
  const UsernameInputScreen({super.key});

  @override
  State<UsernameInputScreen> createState() => _UsernameInputScreenState();
}

class _UsernameInputScreenState extends State<UsernameInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _saveUsername() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() {
        _error = "Please enter a name";
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _error = "User not logged in";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'username': name}, SetOptions(merge: true));

      Navigator.pushReplacementNamed(context, '/greeting');
    } catch (e) {
      setState(() {
        _error = "Failed to save name: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What should I call you?",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(),
                errorText: _error,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveUsername,
                    child: const Text("Continue"),
                  ),
          ],
        ),
      ),
    );
  }
}
