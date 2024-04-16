import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbacksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      body: FeedbackList(),
    );
  }
}

class FeedbackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var feedbackDocs = snapshot.data!.docs;

        if (feedbackDocs.isEmpty) {
          return Center(
            child: Text('There is no feedback.'),
          );
        }

        return ListView.builder(
          itemCount: feedbackDocs.length * 2 - 1,
          itemBuilder: (context, index) {
            if (index.isOdd) return Divider();

            var feedbackIndex = index ~/ 2;
            var feedback = feedbackDocs[feedbackIndex];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackDetailsPage(feedback:feedback as QueryDocumentSnapshot<Map<String, dynamic>>),
                  ),
                );
              },
              child: ListTile(
                title: Text('Feedback ${feedbackIndex + 1}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteFeedback(context, feedback);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteFeedback(BuildContext context, QueryDocumentSnapshot feedback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this feedback?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Delete the feedback
                FirebaseFirestore.instance.collection('feedback').doc(feedback.id).delete();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

class FeedbackDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> feedback;

  const FeedbackDetailsPage({required this.feedback});

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = feedback['timestamp'] as Timestamp;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${feedback['feedback']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'Timestamp: ${timestamp.toDate().toString()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
