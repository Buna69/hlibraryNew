import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/app_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'CategoriesPage/categories_page.dart';
import 'FeedbacksPage/feedback_page.dart';
import 'UsersPage/users_page.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: const Color(0xFFFFB800), // Set AppBar color here
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String currentPage = 'Categories'; // Default page
  List<String> categories = []; // List to hold categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    var userData = snapshot.data as DocumentSnapshot;
                    var userDataMap = userData.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> or nullable
                    var username = userDataMap?['username'] ?? 'Username'; // Safely access data with null check
                    var email = userDataMap?['email'] ?? 'email@example.com'; // Safely access email with null check
                    var profilePic = userDataMap?['profilePic'] ?? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'; // Safely access profile pic with null check or use a default image
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(profilePic),
                        ),
                        SizedBox(height: 10),
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),

            ListTile(
              title: Text('Categories'),
              onTap: () {
                setState(() {
                  currentPage = 'Categories';
                });
                navigatorKey.currentState!.pushReplacementNamed('/categories');
                Navigator.pop(context);
              },
              selected: currentPage == 'Categories',
              leading: Icon(Icons.category_outlined),
            ),
            ListTile(
              title: Text('Users'),
              onTap: () {
                setState(() {
                  currentPage = 'Users';
                });
                navigatorKey.currentState!.pushReplacementNamed('/users');
                Navigator.pop(context);
              },
              selected: currentPage == 'Users',
              leading: Icon(Icons.person_outlined),
            ),
            ListTile(
              title: Text('Feedbacks'),
              onTap: () {
                setState(() {
                  currentPage = 'Feedbacks';
                });
                navigatorKey.currentState!.pushReplacementNamed('/feedbacks');
                Navigator.pop(context);
              },
              selected: currentPage == 'Feedbacks',
              leading: Icon(LineAwesomeIcons.pen),
            ),
            ListTile(
              title: Text('Go back'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AppPage()),
                );
              },
              leading: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/categories':
              return MaterialPageRoute(builder: (_) => CategoriesScreen());
            case '/users':
              return MaterialPageRoute(builder: (_) => UsersScreen());
            case '/feedbacks':
              return MaterialPageRoute(builder: (_) => FeedbacksScreen());
            default:
              return MaterialPageRoute(builder: (_) => CategoriesScreen());
          }
        },
      ),
    );
  }
}
