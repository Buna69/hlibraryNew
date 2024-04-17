import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserDetailsScreen({required this.userData});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _adminController;
  late String _profilePicUrl;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData['username'] ?? '');
    _adminController = TextEditingController(text: widget.userData['admin'] ?? '');
    _profilePicUrl = widget.userData['profilePic'] ?? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_profilePicUrl),
                  radius: 80,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${widget.userData['email']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _adminController,
                decoration: InputDecoration(labelText: 'Admin'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateUserProfile();
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _deleteUser();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Delete User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUserProfile() async {
    String newUsername = _usernameController.text.trim();
    String newAdmin = _adminController.text.trim();

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be empty'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      String userId = widget.userData['userId'];

      Map<String, dynamic> updateData = {};

      if (widget.userData['username'] != newUsername) {
        updateData['username'] = newUsername;
      }
      if (widget.userData['admin'] != newAdmin) {
        updateData['admin'] = newAdmin;
      }

      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update(updateData);

        setState(() {
          if (updateData.containsKey('username')) {
            widget.userData['username'] = newUsername;
          }
          if (updateData.containsKey('admin')) {
            widget.userData['admin'] = newAdmin;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No changes to save'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _deleteUser() async {
    try {
      String userId = widget.userData['userId'];

      await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
      await FirebaseAuth.instance.currentUser!.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete user. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
