import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendFeedbackPage extends StatelessWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: TextField(
                  controller: feedbackController, // Assign controller here
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFEFE0),
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
                  String feedback = feedbackController.text;

                  FirebaseFirestore.instance.collection("feedback").add({
                    "feedback": feedback,
                    "timestamp": FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback sent successfully!'),
                    ),
                  );

                  Navigator.pop(context);
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
