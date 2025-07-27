import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'auth_screen.dart';
import 'utils/string_extensions.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const TasksTab(),
    const DietTab(),
    const GymTab(),
    const GoalsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final email = user?.email ?? '';
    final username = email.split('@').first.capitalize();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Hello, $username',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF007AFF),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell, color: Color(0xFF007AFF)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.profile_circled, color: Color(0xFF007AFF)),
            onPressed: () async {
              await authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF007AFF),
        unselectedItemColor: const Color(0xFF8E8E93),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.sportscourt),
            label: 'Gym',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.flag),
            label: 'Goals',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF007AFF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Show add task/item dialog based on selected tab
          _showAddItemDialog();
        },
      ),
    );
  }

  void _showAddItemDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007AFF),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter item title',
                    filled: true,
                    fillColor: const Color(0xFFF2F2F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Tab screens
class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tasks tab - Coming soon'),
    );
  }
}

class DietTab extends StatelessWidget {
  const DietTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Diet tab - Coming soon'),
    );
  }
}

class GymTab extends StatelessWidget {
  const GymTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gym tab - Coming soon'),
    );
  }
}

class GoalsTab extends StatelessWidget {
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Goals tab - Coming soon'),
    );
  }
}

// Remove the StringExtension class from this file