import 'package:mi_que/domain/entities/transaction_model.dart';

class BookModel {
  final String id;
  final String title;
  final double amount;

  final String date;
  final List<TransactionModel> transactions;

  BookModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.transactions,
  });

  // Convertir de Firestore a objeto Dart
  factory BookModel.fromFirestore(
      Map<String, dynamic> data, String documentId, List<TransactionModel> transactions) {
    return BookModel(
      id: documentId,
      title: data['title'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      date: data['date'] ?? '',
      transactions: transactions,
    );
  }

  // Convertir de objeto Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
    
      'amount': amount,
      'date': date,
    };
  }
}
