import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/HomePage/home_page.dart';
import 'package:hlibrary/AppPage/ProfilePage/profile_page.dart';
import '../LibraryPage/library_page.dart';
import '../SearchPage/widgets/search_bar_with_clear.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Scaffold(
      body: HomePage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> books = []; // Add books list

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch books data
  }

  Future<void> fetchBooks() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        final List<dynamic>? library = docSnapshot.data()?['library'] as List<dynamic>?;
        if (library == null || library.isEmpty) {
          setState(() {
            books = [];
          });
        } else {
          setState(() {
            books = List<Map<String, dynamic>>.from(library);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: LibraryPage(books: books), // Pass books data to LibraryPage
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Scaffold(
      body: ProfilePage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
