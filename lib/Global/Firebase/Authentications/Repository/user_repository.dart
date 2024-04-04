import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hlibrary/Global/Firebase/Authentications/Models/user_model.dart';

class UserRepository {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
      print("User added to Firestore successfully");
    } catch (e) {
      print("Error adding user to Firestore: $e");
      // Handle error here
      throw e;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
      print("User updated in Firestore successfully");
    } catch (e) {
      print("Error updating user in Firestore: $e");
      // Handle error here
      throw e;
    }
  }
}
