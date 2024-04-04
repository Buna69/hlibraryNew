import 'package:flutter/material.dart';
import 'package:hlibrary/StartPage/splash_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../widgets/menu_widget.dart';
import 'ChangePasswordPage/change_password_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const EditProfilePage({Key? key, this.onProfileUpdated}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  void saveProfile() async {
    String newUsername = _newNameController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (newUsername.isNotEmpty && newEmail.isNotEmpty) {
      try {
        // Update username in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'username': newUsername});

        // Update email in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'email': newEmail});

        // Update email in Firebase Authentication
        await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);

        // Invoke the callback to notify the parent widget (Pages) about the profile update
        widget.onProfileUpdated?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 1),
          ),
        );

      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username and email cannot be empty'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                try {
                  // Delete user data from Firestore
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .delete();

                  // Delete user from Firebase Authentication
                  await FirebaseAuth.instance.currentUser!.delete();

                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted successfully'),
                      duration: Duration(seconds: 3),
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                } catch (e) {
                  print('Error deleting account: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete account. Please try again later.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 55),
            child: Text('Edit Profile', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/images/default.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB800),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(LineAwesomeIcons.retro_camera),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 50),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    var userData = snapshot.data as DocumentSnapshot;
                    var userDataMap = userData.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> or nullable
                    var username = userDataMap?['username'] ?? 'Username'; // Safely access data with null check
                    var email = userDataMap?['email'] ?? 'Email'; // Safely access data with null check
                    _newNameController.text = username; // Set the username to the text controller
                    _newEmailController.text = email; // Set the email to the text controller
                    return Column(
                      children: [
                        TextFormField(
                          controller: _newNameController,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outlined),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _newEmailController,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Error fetching user data');
                  }
                },
              ),
              const SizedBox(height: 10),
              MenuWidget(
                title: "Change Password",
                icon: LineAwesomeIcons.lock,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: MaterialButton(
                  onPressed: saveProfile,
                  height: 50,
                  color: const Color(0xFFFFB800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text("Save Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 230),
              Row(
                children: [
                  const Text(""), // Placeholder for creation time
                  const Spacer(),
                  SizedBox(
                    width: 100,
                    child: MaterialButton(
                      onPressed: _showDeleteConfirmationDialog,
                      height: 50,
                      color: const Color.fromARGB(255, 255, 17, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text("Delete", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
