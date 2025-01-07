import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mi_que/domain/db/firebase_data_source.dart';
import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/domain/interfaces/iuser_model.dart';

class UserRepository implements IUserModel {

   final FirebaseDataSource _fDataSource = FirebaseDataSource();

  @override
  Future<String> create(UserModel t) async{
   try {
      UserCredential credential = await _fDataSource.auth.createUserWithEmailAndPassword(
          email: t.email, password: t.password!);
      await _fDataSource.firestore
          .collection("User")
          .doc(credential.user!.uid)
          .set(t.toFirestore());
      return credential.user!.uid;

    
    } catch (e) {
      throw Exception("Problemas con el servidor");
    }
  }

  @override
  Future<bool> delete(UserModel t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserById(String id)async {
    try {
      DocumentSnapshot userDoc =
          await _fDataSource.firestore.collection("User").doc(id).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>,userDoc.id, []);
      } else {
        throw Exception("No existe el usuario");
      }
    } catch (e) {
      throw Exception("Problemas con el servidor");
    }
  }

  @override
  Future<List<UserModel>> read() {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithGoogle() async{
 try {
      final GoogleSignInAccount? googleSignInAccount =
          await _fDataSource.googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential credential =
            await _fDataSource.auth.signInWithCredential(authCredential);
        User? firebaseUser = credential.user;
        if (firebaseUser != null) {
          UserModel userGoogle = UserModel(
            
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '', id: '', books: [],
            
       
          );
          await _fDataSource.firestore
              .collection("User")
              .doc(firebaseUser.uid)
              .set(userGoogle.toFirestore());
        }
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      throw Exception("Problemas con el servidor");
    }
  }

  @override
  Future<bool> update(UserModel t) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<UserModel> verifyUser(String userName, String password)async {
    try {
      UserCredential userCredential = await _fDataSource.auth.signInWithEmailAndPassword(
          email: userName, password: password);
      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await _fDataSource.firestore.collection("User").doc(uid).get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>, userDoc.id, []);
        return user;
      } else {
        throw Exception("El usuario no existe en la base de datos.");
      }
    } catch (e) {
      throw Exception("Usuario o contraseña incorrectos");
    }
  }
}