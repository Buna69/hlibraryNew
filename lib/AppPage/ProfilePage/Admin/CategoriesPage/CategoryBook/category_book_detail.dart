import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'category_books.dart'; // Import Book class from another file

class CategoryBookDetail extends StatelessWidget {
  final Book book;

  CategoryBookDetail({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  book.coverUrl,
                  width: 150,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${book.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Author: ${book.author}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Description:\n',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Center(
                child:  ExpandableText(
                  '${book.description}',
                  style: TextStyle(fontSize: 16,color: Colors.black),
                  linkTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.black),
                  trimType: TrimType.lines,
                  trim: 5,
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfUrl: book.pdfUrl),
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
                    "Read PDF",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(
       pdfUrl,
          pageLayoutMode: PdfPageLayoutMode.single
      ),
    );
  }
}
