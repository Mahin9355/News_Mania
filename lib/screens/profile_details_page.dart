import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_mania/screens/main_screen.dart';
import 'package:news_mania/screens/settings_screen.dart';

class ProfileDetailsPage extends StatefulWidget {
  final bool isReg;

  const ProfileDetailsPage({super.key, required this.isReg});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _nameController = TextEditingController();

  // ✅ Lists for selection
  final List<String> _apiList = [
    'TheNewsAPI',
    'GNews',
    'MediaStack',
    'NewsData',
    'The Guardian',
    'NY Times',
    'BBC News',
  ];

  final List<String> _categories = [
    'Technology',
    'Business',
    'Sports',
    'Health',
    'Entertainment',
    'Science',
    'Politics',
  ];

  final Set<String> _selectedApis = {};
  final Set<String> _selectedCategories = {};
  bool _isSaving = false;
  bool _isLoading = true;

  /// ✅ Load user data if exists
  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('newsmania_users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _selectedApis.addAll(List<String>.from(data['fav_apis'] ?? []));
        _selectedCategories
            .addAll(List<String>.from(data['fav_category'] ?? []));
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Save or Update data in Firestore
  Future<void> _saveUserPreferences() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (_selectedApis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one News API')),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one category')),
      );
      return;
    }

    try {
      setState(() => _isSaving = true);
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('newsmania_users').doc(uid).set({
        'name': name,
        'fav_apis': _selectedApis.toList(),
        'fav_category': _selectedCategories.toList(),
        'uid': uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isReg
              ? 'Profile updated successfully!'
              : 'Registered successfully!'),
        ),
      );

      // Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryYellow = Colors.amber.shade600;
    final Color lightYellow = Colors.amber.shade50;
    final Color darkYellow = Colors.amber.shade800;

    return Scaffold(
      appBar: AppBar(
        leading: widget.isReg
            ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back))
            : null,
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryYellow,
        centerTitle: true,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Name Input
              Text(
                'Your Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkYellow,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                cursorColor: primaryYellow,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  filled: true,
                  fillColor: lightYellow,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.amber.shade200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: primaryYellow, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Colors.black54),
                ),
              ),

              const SizedBox(height: 24),

              // 🌐 News APIs
              Text(
                'Select Your Favorite News APIs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkYellow,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _apiList.map((api) {
                  final isSelected = _selectedApis.contains(api);
                  return FilterChip(
                    label: Text(
                      api,
                      style: TextStyle(
                        color:
                        isSelected ? Colors.black : Colors.grey[800],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: lightYellow,
                    selectedColor: primaryYellow,
                    checkmarkColor: Colors.black,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedApis.add(api);
                        } else {
                          _selectedApis.remove(api);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 📰 News Categories
              Text(
                'Select Your Favorite Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkYellow,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected =
                  _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color:
                        isSelected ? Colors.black : Colors.grey[800],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: lightYellow,
                    selectedColor: primaryYellow,
                    checkmarkColor: Colors.black,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // 💾 Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveUserPreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    widget.isReg
                        ? 'Save Preferences'
                        : 'Register',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
