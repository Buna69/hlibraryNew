import 'package:flutter/material.dart';
import '../../BookDetailPage/book_detail.dart';

class InsideCategoryPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> books;

  const InsideCategoryPage({Key? key, required this.category, required this.books})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(category)),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(bookDetails: book),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book['coverUrl'], // Assuming 'coverUrl' is the key for cover image URL
                      width: 100, // Adjust width as needed
                      height: 150, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['name'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Author: ${book['author']}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        // Show only a portion of the description with ellipsis
                        Text(
                          book['description'],
                          maxLines: 3, // Show only 3 lines
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
