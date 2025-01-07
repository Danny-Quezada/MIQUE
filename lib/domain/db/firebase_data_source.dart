import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseDataSource {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
 FirebaseAuth get auth => FirebaseAuth.instance;
   GoogleSignIn get googleSignIn => GoogleSignIn();

  String newId() {
    return firestore.collection('tmp').doc().id;
  }
}