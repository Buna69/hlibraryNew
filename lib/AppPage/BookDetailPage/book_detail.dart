import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BookDetailPage extends StatefulWidget {
  final Map<String, dynamic> bookDetails;

  const BookDetailPage({super.key, required this.bookDetails});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool inLibrary = false; // State variable to track if the book is in the library or not

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar elevation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LineAwesomeIcons.download, size: 35),
            onPressed: () {
              // Handle download action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 110,),
          child: Column(
            children: [
              // Container for book details with background image
              Container(
                width: double.infinity,
                height: media.width * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.bookDetails['images']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Blurred background
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10), // Increase blur effect
                        child: Container(
                          color: Colors.white.withOpacity(0.5), // Adjust opacity as needed
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              widget.bookDetails['images'],
                              width: media.width * 0.32,
                              height: media.width * 0.47,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 45),
                                // Display book name
                                Text(
                                  '${widget.bookDetails['name']}',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                // Display author name with icon
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 20), // Icon
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.bookDetails['author']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Display category
                                Row(
                                  children: [
                                    const Icon(Icons.category_outlined, size: 20), // Icon
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.bookDetails['category']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Description
              _buildDescription(),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      height: 50,
                      minWidth: 50,
                      color: const Color(0xFFFFB800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(Icons.menu_book, size: 25), // Icon
                            SizedBox(width: 5),
                            Text("Read", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          inLibrary = !inLibrary; // Toggle the state when the button is pressed
                        });
                      },
                      height: 50,
                      minWidth: 50,
                      color: const Color(0xFFFFB800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child:  Center(
                        child: Row(
                          children: [
                            Icon(inLibrary ? Icons.favorite : Icons.favorite_outline_outlined, size: 25), // Icon
                            const SizedBox(width: 5),
                            Text(inLibrary ? "In Library" : "Add to Library", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    String description = widget.bookDetails['description'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
