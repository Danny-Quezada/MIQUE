import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';

abstract class IBookModel {
Future<int> createTransaction(TransactionModel transaction,String bookId, String userId);
Stream<Iterable<TransactionModel>> readTransactions(String userId,String bookId);
Stream<Iterable<BookModel>> readBooks(String userId);
Future<bool> deleteTransaction(TransactionModel transaction,String bookId, String userId, String date);
Future<bool> updateTransaction(TransactionModel transaction,String bookId, String userId);
Future<bool> deteleBook(String bookId, String userId);
Future<int> create(BookModel book, String userId);
Future<bool> updateName(String name, String userId, String bookId);
}