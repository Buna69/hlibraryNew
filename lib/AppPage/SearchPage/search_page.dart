import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/SearchPage/widgets/search_text_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
        title: const SearchTextField(),
      ),
      body: const Center(
        child: Text('Search content',style: TextStyle(fontSize: 30)),
      ),
    );
  }
}