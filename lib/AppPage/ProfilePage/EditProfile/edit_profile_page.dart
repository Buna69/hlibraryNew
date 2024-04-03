import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../Global/toast.dart';
import '../widgets/menu_widget.dart';
import 'ChangePasswordPage/change_password_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  void saveProfile() async {}

  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController(text: 'example.gmail.com');

  changePassword() {
    // Implement your password change logic here
    // For example, you could simulate a change by showing a toast message
    showToastMsg(message: "Profile Saved");
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
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
              onPressed: () {
                // Implement delete account logic here
                // For example, you could show a toast message
                showToastMsg(message: "Account Deleted");
                Navigator.of(context).pop();
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
              TextFormField(
                controller: _newNameController,
                onChanged: (value) {},
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outlined),
                  hintText: 'Buna',
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
                      onPressed: () {
                        _showDeleteConfirmationDialog();
                      },
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
