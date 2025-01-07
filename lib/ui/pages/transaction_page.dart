import 'package:flutter/material.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';
import 'package:mi_que/ui/widgets/transaction_widget.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});
  BookModel bookModel = BookModel(
    id: 'book_002',
    title: 'Salary',
    amount: 75000,
    date: 'Apr 30 2024',
    transactions: [
      TransactionModel(
        date: 'May 1 2024',
        id: 'trans_103',
        name: 'Work Salary',
        amount: 50000,
        iconName: '0xe227', // attach_money
      ),
      TransactionModel(
        date: 'May 1 2024',
        id: 'trans_103',
        name: 'Work',
        amount: 25000,
        iconName: '0xe84f', // attach_money
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
        body: Column(
      children: [
        Container(
          height: 300,
          color: Colors.red,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: bookModel.transactions.length,
          itemBuilder: (context, index) {
            return TransactionWidget(
                transactionModel: bookModel.transactions[index]);
          },
        ))
      ],
    ));
  }
}
