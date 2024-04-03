import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRightMember('assets/images/default.png', 'Team Leader: Buna'),
            const SizedBox(height: 10),
            _buildLeftMember('assets/images/default.png', 'Team Member: John'),
            const SizedBox(height: 10),
            _buildRightMember('assets/images/default.png', 'Team Member: Sarah'),
            const SizedBox(height: 10),
            _buildLeftMember('assets/images/default.png', 'Team Member: Mike'),
            const SizedBox(height: 10),
            _buildRightMember('assets/images/default.png', 'Team Member: Dave'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftMember(String imagePath, String text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
       const SizedBox(width: 10),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightMember(String imagePath, String text) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
