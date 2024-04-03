import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/ProfilePage/profile_page.dart';

class SendFeedbackPage extends StatelessWidget {
  const SendFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding:  EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFEFE0), // Set your desired background color here
                    hintText: 'Enter a feedback',
                  ),
                ),
              ),

            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
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
                    "Send",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
