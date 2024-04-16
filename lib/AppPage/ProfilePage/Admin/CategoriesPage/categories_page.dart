import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CategoryBook/category_books.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String>? categories; // Nullable list to hold categories

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      categories = null; // Set categories to null to trigger loading indicator
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      List<String> categoryNames = [];
      querySnapshot.docs.forEach((doc) {
        categoryNames.add(doc['categoryName'] as String); // Explicitly cast to String
      });
      setState(() {
        categories = categoryNames;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        categories = []; // Set categories to empty list if an error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: categories == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.separated(
        itemCount: categories!.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text(categories![index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryBooks(categoryName: categories![index]),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteCategory(categories![index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange, // Customize the color if needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Adjust the location as needed
    );
  }

  // Method to show dialog for adding a category
  void _showAddCategoryDialog(BuildContext context) {
    String newCategoryName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            onChanged: (value) {
              newCategoryName = value;
            },
            decoration: InputDecoration(hintText: 'Enter Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addCategory(newCategoryName); // Call the function to add the category
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addCategory(String categoryName) {
    FirebaseFirestore.instance.collection('categories').add({'categoryName': categoryName}).then((categoryDoc) {
      // Add a dummy document to create the "books" collection inside the category document
      categoryDoc.collection('Book Collection').doc('Books').set({'Name': 'name','Author':'author'});
    }).catchError((error) {
      print('Error adding category: $error');
    }).then((_) {
      fetchCategories(); // Refresh the list of categories
    });
  }

  void _deleteCategory(String categoryName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDeleteCategory(categoryName);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDeleteCategory(String categoryName) {
    FirebaseFirestore.instance.collection('categories').where('categoryName', isEqualTo: categoryName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((_) {
          // Delete the subcollection
          FirebaseFirestore.instance.collection('categories').doc(doc.id).collection('Book Collection').doc('Books').delete().then((_) {
            print('Category deleted successfully');
            fetchCategories(); // Refresh the list of categories
          }).catchError((error) {
            print('Error deleting subcollection: $error');
          });
        }).catchError((error) {
          print('Error deleting category: $error');
        });
      });
    }).catchError((error) {
      print('Error fetching category to delete: $error');
    });
  }
}
