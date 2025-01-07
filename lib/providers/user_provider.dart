
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/domain/interfaces/iuser_model.dart';

class UserProvider extends ChangeNotifier {

  IUserModel iUserModel;
  User? firebaseUser;
  UserModel? userModel;
  UserProvider({required this.iUserModel});

   Future<void> loadCurrentUser() async {
    try {
      firebaseUser = FirebaseAuth.instance.currentUser;
      userModel = await iUserModel
          .getUserById(FirebaseAuth.instance.currentUser!.uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> closeSession()async{
    try{
      await FirebaseAuth.instance.signOut();
      
    }catch(e){
      rethrow;
    }
  }
  Future<String> createUser(UserModel user) async {
    try {
      return await iUserModel.create(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> verifyUser(String correo, String password) async {
    try {
      return await iUserModel.verifyUser(correo, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      return await iUserModel.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  
  

}