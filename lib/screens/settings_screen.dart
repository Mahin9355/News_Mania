import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_mania/screens/profile_details_page.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = "English";

  final user = FirebaseAuth.instance.currentUser;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword(BuildContext context) async {
    try {
      if (_passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password cannot be empty")),
        );
        return;
      }
      await user?.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Profile Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            readOnly: false,
            decoration: InputDecoration(
              labelText: user?.email,
              border: const OutlineInputBorder(),
              hintText: user?.email ?? "No email found",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "New Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.lock_reset),
            label: const Text("Change Password",style: TextStyle(color: Colors.black),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => _changePassword(context),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile",style: TextStyle(color: Colors.black),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileDetailsPage(isReg : true)),
            ),
          ),
          const SizedBox(height: 30),

          const Divider(),

          SwitchListTile(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(selectedLanguage),
            onTap: () async {
              final lang = await showDialog<String>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text("Select Language"),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, "English"),
                        child: const Text("English"),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, "Bangla"),
                        child: const Text("Bangla"),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, "Spanish"),
                        child: const Text("Spanish"),
                      ),
                    ],
                  );
                },
              );

              if (lang != null) {
                setState(() {
                  selectedLanguage = lang;
                });
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "NewsMania",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.newspaper),
                children: const [
                  Text(
                    "NewsMania is a smart news app that collects, categorizes, and summarizes news.",
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          // Logout button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout,color: Colors.white,),
            label: const Text("Logout",style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }
}