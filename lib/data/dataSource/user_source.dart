import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';

class UserSource{

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  Future<AppUser?> getUser(String uid) async{
    final doc = await _firestore.collection("users").doc(uid).get();
    return AppUser.fromMap(doc.data()!);
  }

  Future<AppUser?> getCurrentUser() async{
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    final doc = await _firestore.collection("users").doc(user.uid).get();
    return AppUser.fromMap(doc.data()!);
  }

  Stream<AppUser?> getCurrentUserStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }
    return _firestore.collection("users").doc(user.uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return AppUser.fromMap(data);
    });
  }

  Future<void> updateUser(AppUser user)async{
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }
}