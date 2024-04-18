import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'category_book_detail.dart'; // Import CategoryBookDetail class from another file

class CategoryBooks extends StatefulWidget {
  final String categoryName;

  CategoryBooks({required this.categoryName});

  @override
  _CategoryBooksState createState() => _CategoryBooksState();
}

class _CategoryBooksState extends State<CategoryBooks> {
  late Stream<List<Book>> _bookStream;
  File? _image;
  File? _pdf;

  @override
  void initState() {
    super.initState();
    _bookStream = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryName)
        .collection('Book Collection')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Avoid resizing when keyboard appears
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: StreamBuilder<List<Book>>(
        stream: _bookStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Book> books = snapshot.data ?? [];
            if (books.isEmpty) {
              return Center(child: Text('No books available'));
            }
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _buildBookCoverImage(books[index].coverUrl),
                  title: Text(books[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(books[index].author),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryBookDetail(book: books[index]),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _confirmDeleteBook(context, books[index].name);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookCoverImage(String coverUrl) {
    return CachedNetworkImage(
      imageUrl: coverUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }

  void _showAddBookDialog(BuildContext context) async {
    String bookName = '';
    String authorName = '';
    String description = '';

    bool isAddingBook = false;

    showDialog(
      context: context,
      barrierDismissible: !isAddingBook, // Prevent closing the dialog while adding book
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Book'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        bookName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Book Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        authorName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Author Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    SizedBox(height: 20),
                    _image != null
                        ? Image.file(
                      _image!,
                      height: 100,
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            _image = File(result.files.single.path!);
                          });
                        }
                      },
                      child: Text('Pick Book Cover Image'),
                    ),
                    SizedBox(height: 20),
                    _pdf != null
                        ? Text(
                      'PDF Selected',
                      style: TextStyle(color: Colors.green),
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          setState(() {
                            _pdf = File(result.files.single.path!);
                          });
                        }
                      },
                      child: Text('Pick PDF'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (!isAddingBook) {
                      setState(() {
                        _image = null; // Reset _image
                        _pdf = null; // Reset _pdf
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (!isAddingBook) {
                      setState(() {
                        isAddingBook = true;
                      });
                      try {
                        if (bookName.isNotEmpty &&
                            authorName.isNotEmpty &&
                            _image != null &&
                            _pdf != null &&
                            description.isNotEmpty) {
                          await addBookToCollection(bookName, authorName, description);
                          setState(() {
                            _image = null; // Reset _image
                            _pdf = null; // Reset _pdf
                            isAddingBook = false;
                          });
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please enter book name, author name, description, select an image, and select a PDF.'),
                            ),
                          );
                          setState(() {
                            isAddingBook = false;
                          });
                        }
                      } catch (error) {
                        print('Error adding book: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add book. Please try again later.'),
                          ),
                        );
                        setState(() {
                          isAddingBook = false;
                        });
                      }
                    }
                  },
                  child: isAddingBook
                      ? CircularProgressIndicator() // Show loading indicator while adding book
                      : Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteBook(BuildContext context, String bookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteBook(bookName);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addBookToCollection(String bookName, String authorName, String description) async {
    try {
      final Reference imageRef = FirebaseStorage.instance.ref().child('bookCover').child(bookName);
      final Reference pdfRef = FirebaseStorage.instance.ref().child('bookPDF').child(bookName);

      final imageUploadTask = imageRef.putFile(
        _image!,
        SettableMetadata(
          contentType: 'image/png',
          // Change the content type according to the image format
        ),
      );
      final pdfUploadTask = pdfRef.putFile(
        _pdf!,
        SettableMetadata(
          contentType: 'application/pdf', // Set content type to application/pdf for PDF files
        ),
      );

      final imageDownloadUrl = await (await imageUploadTask).ref.getDownloadURL();
      final pdfDownloadUrl = await (await pdfUploadTask).ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('categories').doc(widget.categoryName).collection('Book Collection').doc(bookName).set({
        'name': bookName,
        'author': authorName,
        'description': description,
        'coverUrl': imageDownloadUrl,
        'pdfUrl': pdfDownloadUrl,
      });

      print('Book added successfully');
    } catch (error) {
      print('Failed to add book: $error');
      throw error; // Rethrow the error to handle it in _showAddBookDialog
    }
  }

  void _deleteBook(String bookName) async {
    try {
      await FirebaseStorage.instance.ref().child('bookCover').child(bookName).delete();
      await FirebaseStorage.instance.ref().child('bookPDF').child(bookName).delete();
      await FirebaseFirestore.instance.collection('categories').doc(widget.categoryName).collection('Book Collection').doc(bookName).delete();
      print('Book deleted successfully');
    } catch (error) {
      print('Failed to delete book: $error');
    }
  }
}

class Book {
  late final String name;
  final String author;
  final String description;
  final String coverUrl;
  final String pdfUrl;

  Book({
    required this.name,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.pdfUrl,
  });

  // Factory method to create Book object from Firestore DocumentSnapshot
  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Explicit casting
    return Book(
      name: doc.id,
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
    );
  }
}
