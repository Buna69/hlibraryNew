import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hlibrary/AppPage/ProfilePage/AboutUsPage/about_us_page.dart';
import 'package:hlibrary/AppPage/ProfilePage/SendFeedbackPage/send_feedback_page.dart';
import 'package:hlibrary/AppPage/ProfilePage/EditProfile/edit_profile_page.dart';
import 'package:hlibrary/AppPage/ProfilePage/widgets/menu_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                    return Column(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: userProfileImageWidget(context, userDataMap?['userProfilePic']),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(username, style: const TextStyle(fontSize: 17)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset('assets/images/default.png'), // Display default image
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Username', style: TextStyle(fontSize: 17)),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  height: 50,
                  color: const Color(0xFFFFB800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Divider(),
              const SizedBox(height: 10),
              MenuWidget(title: "Download History", icon: LineAwesomeIcons.download, onPress: () {}),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              MenuWidget(
                title: "Send Feedback",
                icon: LineAwesomeIcons.pen,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendFeedbackPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              MenuWidget(
                title: "About Us",
                icon: LineAwesomeIcons.info,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              MenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userProfileImageWidget(BuildContext context, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(imageUrl);
    } else {
      return  Image.asset('assets/images/default.png');
    }
  }
}
