import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hlibrary/AppPage/ProfilePage/Admin/UsersPage/user_detail_page.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data != null) {
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;
              var username = userData['username'] ?? 'Username';
              var userId = users[index].id; // Get the user ID
              userData['userId'] = userId; // Add the user ID to userData
              var email = userData['email'] ?? 'email@example.com';
              var admin = userData['admin'] ?? 'Admin';
              var profilePic = userData['profilePic'] ?? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                ),
                title: Text(username),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsScreen(userData: userData)),
                  );
                },
              );
            },
          );
        } else {
          return Center(child: Text('No users found'));
        }
      },
    );
  }
}
