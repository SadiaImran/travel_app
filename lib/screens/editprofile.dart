import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key , required this.username}) : super(key: key);
  final String username;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from Firebase Realtime Database
  void _loadUserData() async {
    final User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      DatabaseReference userRef = databaseRef.child('users/$uid');

      DatabaseEvent event = await userRef.once();
      if (event.snapshot.value != null) {
        final userData = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          username = userData['username'];
          firstNameController.text = userData['firstName'] ?? '';
          lastNameController.text = userData['lastName'] ?? '';
          locationController.text = userData['location'] ?? '';
          mobileNumberController.text = userData['mobileNumber'] ?? '';
        });
      }
    }
  }

  // Save updated user profile data to Firebase for the logged-in user
  Future<void> _saveProfileData() async {
    final User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      DatabaseReference userRef = databaseRef.child('users/$uid');

      await userRef.update({
        'username': username,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'location': locationController.text,
        'mobileNumber': mobileNumberController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfileData,
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profilephoto.png'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                },
                child: const Text(
                  'Change Profile Picture',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 30),
              buildTextField('First Name', firstNameController),
              const SizedBox(height: 20),
              buildTextField('Last Name', lastNameController),
              const SizedBox(height: 20),
              buildTextField('Location', locationController),
              const SizedBox(height: 20),
              buildTextField('Mobile Number', mobileNumberController),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.check, color: Colors.blue),
      ),
    );
  }
}
