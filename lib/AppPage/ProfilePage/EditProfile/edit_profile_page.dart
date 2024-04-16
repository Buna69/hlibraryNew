import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hlibrary/StartPage/splash_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../app_page.dart';
import '../widgets/menu_widget.dart';
import 'ChangePasswordPage/change_password_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  EditProfilePage({Key? key, this.onProfileUpdated}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UploadTask? uploadTask;
  PlatformFile? pickedFile;
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  Map<String, dynamic>? userDataMap;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var userDataSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDataSnapshot.exists) {
      setState(() {
        userDataMap = userDataSnapshot.data() as Map<String, dynamic>?;
        var username = userDataMap?['username'] ?? 'Username';
        var email = userDataMap?['email'] ?? 'Email';
        _newNameController.text = username;
        _newEmailController.text = email;
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'userProfilePic/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    try {
      final snapshot = await uploadTask!;
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
    } catch (e) {
      print('Error uploading file: $e');
    } finally {
      if (mounted) {
        setState(() {
          uploadTask = null;
        });
      }
    }
  }

  void saveProfile() async {
    String newUsername = _newNameController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (userDataMap == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching user data'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    var currentUsername = userDataMap?['username'] ?? '';
    var currentEmail = userDataMap?['email'] ?? '';

    bool hasChanges = newUsername != currentUsername ||
        newEmail != currentEmail ||
        pickedFile != null;

    if (hasChanges) {
      try {
        if (newUsername.isNotEmpty && newUsername != currentUsername) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'username': newUsername});
          setState(() {
            userDataMap?['username'] = newUsername;
          });
        }

        if (newEmail.isNotEmpty && newEmail != currentEmail) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'email': newEmail});

          await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
          setState(() {
            userDataMap?['email'] = newEmail;
          });
        }

        if (pickedFile != null) {
          await uploadFile();
          String? profilePicUrl = await getProfilePicUrl();
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'profilePic': profilePicUrl});
          setState(() {
            userDataMap?['profilePic'] = profilePicUrl;
          });
        }

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
          content: Text('No changes to save'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }



  Future<String?> getProfilePicUrl() async {
    if (pickedFile != null) {
      final path = 'userProfilePic/${pickedFile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      final urlDownload = await ref.getDownloadURL();
      return urlDownload;
    } else {
      return null;
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
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .delete();

                  await FirebaseAuth.instance.currentUser!.delete();

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
                  if (pickedFile != null)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(
                        File(pickedFile!.path!),
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (userDataMap != null && userDataMap!.containsKey('profilePic'))
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(userDataMap!['profilePic']),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/default.png'),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB800),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(LineAwesomeIcons.retro_camera),
                        onPressed: selectFile,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 50),
              Column(
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
                  onPressed:() {
                    saveProfile();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppPage(), // Replace AppPage with your desired destination
                      ),
                    );
                  },

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
              const SizedBox(height: 180),
              Row(
                children: [
                  const Text(""),
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
