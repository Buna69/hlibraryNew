import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/BookDetailPage/book_detail.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> allBooks; // Pass the list of books
  const SearchPage({Key? key, required this.allBooks}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = []; // To hold search results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SearchTextField(
          onChanged: _onSearchTextChanged,
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final book = _searchResults[index];
          return ListTile(
            title: Text(book['name']),
            subtitle: Text(book['author']),
            leading: Image.network(
              book['coverUrl'], // Display image from coverUrl
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(bookDetails: book),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _searchResults = _filterBooks(text);
    });
  }

  List<Map<String, dynamic>> _filterBooks(String query) {
    List<Map<String, dynamic>> filteredBooks = [];
    // Search in allBooks list passed from HomePage
    for (var book in widget.allBooks) {
      if (book['name'].toLowerCase().contains(query.toLowerCase()) ||
          book['author'].toLowerCase().contains(query.toLowerCase())) {
        filteredBooks.add(book);
      }
    }
    return filteredBooks;
  }
}

class SearchTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchTextField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {},
        ),
      ),
    );
  }
}
