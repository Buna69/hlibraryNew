import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hlibrary/AppPage/BookDetailPage/book_detail.dart';

class LibraryPage extends StatefulWidget {
  final List<Map<String, dynamic>> books;

  LibraryPage({required this.books});
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<Map<String, dynamic>>> _fetchBooksFuture;

  @override
  void initState() {
    super.initState();
    _fetchBooksFuture = fetchBooks();
  }

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('books').get();

    List<DocumentSnapshot> bookDocs = querySnapshot.docs;
    List<Map<String, dynamic>> books = bookDocs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return books;
  }

  Future<void> _refreshData() async {
    setState(() {
      _fetchBooksFuture = fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> books = snapshot.data!;

            return _buildGridView(books);
          }
        },
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> books) {
    List<Map<String, dynamic>> books = widget.books;
    double screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth / 2;
    double height = width * 1.5;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (width / height),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              _navigateToBookDetail(context, book);
            },
            child: SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Stack(
                    children: [
                      Image.network(
                        book['coverUrl'] ?? '',
                        fit: BoxFit.fill,
                        height: height,
                      ),
                      Positioned(
                        width: width - 5,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          color: const Color.fromARGB(126, 0, 0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              book['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToBookDetail(BuildContext context, Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(bookDetails: book),
      ),
    );
  }
}
