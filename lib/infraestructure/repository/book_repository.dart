import 'package:mi_que/domain/db/firebase_data_source.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/domain/interfaces/ibook_model.dart';

class BookRepository implements IBookModel {
  final FirebaseDataSource _fDataSource = FirebaseDataSource();

  @override
  Future<int> createTransaction(
      TransactionModel transaction, String bookId, String userId) async {
    try {
      final firestore = _fDataSource.firestore;

      final transactionRef = firestore
          .collection('User')
          .doc(userId)
          .collection('Book')
          .doc(bookId)
          .collection('Transaction');

      final bookRef = firestore
          .collection('User')
          .doc(userId)
          .collection('Book')
          .doc(bookId);

      // Ejecutar la transacción de manera correcta
      await firestore.runTransaction((transactionBatch) async {
        // Obtener el snapshot del libro (lectura primero)
        final bookSnapshot = await transactionBatch.get(bookRef);

        if (bookSnapshot.exists) {
          double currentAmount =
              (bookSnapshot.data()?['amount'] ?? 0.0).toDouble();

          // Calcular nuevo amount
          double updatedAmount = currentAmount + transaction.amount;

          // Escribir la nueva transacción (después de la lectura)
          final newTransactionRef = transactionRef.doc();
          transactionBatch.set(newTransactionRef, transaction.toFirestore());

          // Actualizar el amount del libro
          transactionBatch.update(
              bookRef, {'amount': updatedAmount, 'date': transaction.date});
        }
      });

      return 1; // Éxito
    } catch (e) {
      print('Error creating transaction: $e');
      return 0; // Error
    }
  }

  @override
  Future<bool> deleteTransaction(TransactionModel transaction, String bookId,
      String userId, String date) async {
    try {
      // Referencia al documento del libro
      var bookRef = _fDataSource.firestore
          .collection('User')
          .doc(userId)
          .collection('Book')
          .doc(bookId);

      // Referencia a la transacción dentro del libro
      var transactionRef =
          bookRef.collection('Transaction').doc(transaction.id);

      // Ejecutar transacción de Firestore
      await _fDataSource.firestore.runTransaction((transactionFirestore) async {
        // Obtener el documento del libro
        var bookSnapshot = await transactionFirestore.get(bookRef);

        if (!bookSnapshot.exists) {
          throw Exception('Book does not found');
        }

        // Obtener los datos actuales del libro
        var bookData = bookSnapshot.data()!;
        double currentAmount = bookData['amount'] ?? 0.0;

        // Calcular el nuevo monto después de eliminar la transacción

        double newAmount = currentAmount - transaction.amount;

        // Actualizar el campo 'amount' en el documento del libro
        transactionFirestore
            .update(bookRef, {'amount': newAmount, "date": date});

        // Eliminar la transacción de la subcolección 'transactions'
        transactionFirestore.delete(transactionRef);
      });

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
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
    try {
      return _fDataSource.firestore
          .collection('User')
          .doc(userId)
          .collection('Book')
          .doc(bookId)
          .collection('Transaction')
          .snapshots()
          .map((snapshot) => snapshot.docs.map(
              (doc) => TransactionModel.fromFirestore(doc.data(), doc.id)));
    } catch (e) {
      print('Error reading transactions: $e');
      return Stream.error('Failed to load transactions');
    }
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

  @override
  Stream<Iterable<TransactionModel>> readTransactionByUser(
      String userId) async* {
    yield* _fDataSource.firestore
        .collection('User')
        .doc(userId)
        .collection('Book')
        .snapshots()
        .asyncExpand((bookSnapshot) {
      // Crear streams para cada libro y combinarlos
      List<Stream<List<TransactionModel>>> streams =
          bookSnapshot.docs.map((bookDoc) {
        return bookDoc.reference
            .collection('Transaction')
            .snapshots()
            .map((transactionSnapshot) {
          return transactionSnapshot.docs.map((transactionDoc) {
            return TransactionModel.fromFirestore(
              transactionDoc.data(),
              transactionDoc.id,
            );
          }).toList();
        });
      }).toList();

      // Combinar todos los streams en uno solo
      return Stream.fromFutures(streams.map((s) => s.first));
    });
  }
}
