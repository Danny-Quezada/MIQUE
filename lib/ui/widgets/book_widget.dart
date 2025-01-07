import 'package:flutter/material.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/ui/pages/transaction_page.dart';

class BookWidget extends StatelessWidget {
  BookModel bookModel;
  BookWidget({super.key, required this.bookModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return TransactionPage();
          },
        ));
      },
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        child: Icon(Icons.menu_book_rounded, color: Colors.blue),
      ),
      title: Text(
        bookModel.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Actualizado: ${bookModel.date}",
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Text(
        bookModel.amount.toString(),
        style: TextStyle(
          color: bookModel.amount > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
