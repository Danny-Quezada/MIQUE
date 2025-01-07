import 'package:flutter/foundation.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/interfaces/ibook_model.dart';

class BookProvider extends ChangeNotifier {
  IBookModel iBookModel;
  BookProvider({required this.iBookModel});

  Stream<Iterable<BookModel>> readBooks(String userId)async* {
    yield* iBookModel.readBooks(userId);
  }

  Future<int> createBook(BookModel data, String userId) async{
    return await iBookModel.create(data, userId);
  }
  Future<bool> deleteBook(String bookId, String userId) async{
    return await iBookModel.deteleBook(bookId, userId);
  }
   Future<bool> updateName(String name, String userId, String bookId)async{
    return await iBookModel.updateName(name, userId, bookId);
   }
}
