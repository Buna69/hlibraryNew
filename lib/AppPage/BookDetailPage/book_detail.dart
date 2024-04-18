import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetailPage extends StatefulWidget {
  final Map<String, dynamic> bookDetails;

  const BookDetailPage({Key? key, required this.bookDetails}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool inLibrary = false;

  @override
  void initState() {
    super.initState();
    checkInLibrary();
  }

  Future<void> checkInLibrary() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('library')) {
          final List<dynamic> library = data['library'];
          final bool isInLibrary = library.any((book) =>
          book['name'] == widget.bookDetails['name'] &&
              book['author'] == widget.bookDetails['author'] &&
              book['description'] == widget.bookDetails['description'] &&
              book['coverUrl'] == widget.bookDetails['coverUrl'] &&
              book['pdfUrl'] == widget.bookDetails['pdfUrl']
          );
          setState(() {
            inLibrary = isInLibrary;
          });
        }
      }
    }
  }


  Future<void> toggleLibraryStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

      if (inLibrary) {
        await userDoc.update({
          'library': FieldValue.arrayRemove([
            {
              'name': widget.bookDetails['name'],
              'author': widget.bookDetails['author'],
              'description': widget.bookDetails['description'],
              'coverUrl': widget.bookDetails['coverUrl'],
              'pdfUrl': widget.bookDetails['pdfUrl'],
            }
          ]),
        });
      } else {
        await userDoc.update({
          'library': FieldValue.arrayUnion([
            {
              'name': widget.bookDetails['name'],
              'author': widget.bookDetails['author'],
              'description': widget.bookDetails['description'],
              'coverUrl': widget.bookDetails['coverUrl'],
              'pdfUrl': widget.bookDetails['pdfUrl'],
            }
          ]),
        });
      }
      setState(() {
        inLibrary = !inLibrary;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 110),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: media.width * 0.7,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.bookDetails['coverUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10),
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.bookDetails['coverUrl'] ?? '',
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
                                const SizedBox(height: 30),
                                Text(
                                  '${widget.bookDetails['name'] ?? ''}'.replaceAllMapped(
                                      RegExp(r'(.{40})'), (match) => '${match.group(0)}\n'),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 20),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        _formatAuthors(widget.bookDetails['author']),
                                        style: const TextStyle(fontSize: 18),
                                      ),
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
              _buildDescription(),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerPage(
                              name: widget.bookDetails['name'] ?? '',
                              pdfUrl: widget.bookDetails['pdfUrl'] ?? '',
                            ),
                          ),
                        );
                      },
                      height: 50,
                      minWidth: 50,
                      color: const Color(0xFFFFB800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(Icons.menu_book, size: 25),
                            SizedBox(width: 5),
                            Text("Read", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: toggleLibraryStatus,
                      height: 50,
                      minWidth: 50,
                      color: const Color(0xFFFFB800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(inLibrary ? Icons.favorite : Icons.favorite_outline_outlined, size: 25),
                            const SizedBox(height: 10),
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
    final description = widget.bookDetails['description'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          ExpandableText(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            linkTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            trimType: TrimType.lines,
            trim: 14,
          ),
        ],
      ),
    );
  }

  String _formatAuthors(String? authors) {
    if (authors == null) return '';

    final authorList = authors.split(',');

    return authorList.map((author) => ' $author\n').join('');
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;
  final String name;

  const PdfViewerPage({Key? key, required this.name, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        pageLayoutMode: PdfPageLayoutMode.single,
        canShowPaginationDialog: true,
      ),
    );
  }
}
