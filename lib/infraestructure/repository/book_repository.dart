import 'package:mi_que/domain/db/firebase_data_source.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/domain/interfaces/ibook_model.dart';

class BookRepository implements IBookModel {
  final FirebaseDataSource _fDataSource = FirebaseDataSource();

  @override
  Future<int> createTransaction(
      TransactionModel transaction, String bookId, String userId) {
    // TODO: implement createTranasaction
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTransaction(
      TransactionModel transaction, String bookId, String userId) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<bool> deteleBook(String bookId, String userId) async {
    try {
      // Referencia al documento del libro dentro de la subcolección 'books' de un usuario
      final bookRef = _fDataSource.firestore
          .collection('User') // Colección de usuarios
          .doc(userId) // Documento del usuario
          .collection('Book') // Subcolección de libros
          .doc(bookId); // Documento del libro a eliminar

      // Eliminar el documento
      await bookRef.delete();

      // Retornar true si se elimina correctamente
      return true;
    } catch (e) {
      // Manejo de errores: imprimir el error y retornar false
      print('Error eliminando libro: $e');
      return false;
    }
  }

  @override
  Stream<Iterable<BookModel>> readBooks(String userId) {
    // Escuchar cambios en la subcolección 'books' de un usuario específico
    return _fDataSource.firestore
        .collection('User') // Colección de usuarios
        .doc(userId) // Documento del usuario
        .collection('Book') // Subcolección de libros
        .snapshots() // Escucha en tiempo real
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookModel.fromFirestore(doc.data(), doc.id, []);
      });
    });
  }

  @override
  Stream<Iterable<TransactionModel>> readTransactions(
      String userId, String bookId) {
    // TODO: implement readTransactions
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTransaction(
      TransactionModel transaction, String bookId, String userId) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  Future<int> create(BookModel book, String userId) async {
    try {
      // Generar un nuevo ID para el libro
      final String newBookId = _fDataSource.newId();

      // Referencia a la subcolección 'books' dentro del usuario
      final bookRef = _fDataSource.firestore
          .collection('User') // Colección de usuarios
          .doc(userId) // Documento del usuario
          .collection('Book') // Subcolección de libros
          .doc(newBookId); // Documento con el nuevo ID del libro

      // Convertir el objeto BookModel a formato Firestore
      final bookData = book.toFirestore();

      // Guardar el libro en Firestore
      await bookRef.set(bookData);

      // Retornar éxito
      return 1;
    } catch (e) {
      // Imprimir el error y retornar 0 en caso de fallo

      return 0;
    }
  }

  @override
  Future<bool> updateName(String name, String userId, String bookId) async {
    try {
      await _fDataSource.firestore
          .collection('User')
          .doc(userId)
          .collection('Book')
          .doc(bookId)
          .update({'title': name});
      return true;
    } catch (e) {
      print('Error updating name: $e');
      return false;
    }
  }
}
