import 'package:mi_que/domain/entities/book_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<BookModel> books;
  String? password;
  UserModel(
      {required this.id,
      required this.name,
      required this.books,
      required this.email});

  // Convertir de Firestore a objeto Dart
  factory UserModel.fromFirestore(
      Map<String, dynamic> data, String documentId, List<BookModel> books) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      books: books,
      email: data['email'] ?? '',
    );
  }

  // Convertir de objeto Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name ?? 'Nombre no disponible',
      'email': email ?? 'Correo no disponible',
      if (password != null) 'password': password,
    };
  }
}
