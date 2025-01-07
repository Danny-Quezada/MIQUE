

import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/domain/interfaces/imodel.dart';

abstract class IUserModel extends IModel<UserModel> {
  Future<UserModel> verifyUser(String userName, String password);
  Future<bool> signInWithGoogle();
  Future<UserModel> getUserById(String id);
 
}