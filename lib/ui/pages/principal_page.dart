import 'package:flutter/material.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/ui/widgets/book_widget.dart';


class PrincipalPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  PrincipalPage({super.key});
UserModel user = UserModel(
  id: 'user_123',
  name: 'User 223',
  email: "test",
  books: [
    BookModel(
      id: 'book_001',
      title: 'January Expenses',
      amount: 10000,
      date: 'Jan 21 2024',
      transactions: [
        TransactionModel(
          date: 'May 1 2024',
          id: 'trans_101',
          name: 'Rent',
          amount: 1500,
          iconName: '0xe88a', // home
        ),
        TransactionModel(
          date: 'May 1 2024',
          id: 'trans_102',
          name: 'Groceries',
          amount: 500,
          iconName: '0xe8cc', // shopping_cart
        ),
      ],
    ),
    BookModel(
      id: 'book_002',
      title: 'Salary',
      amount: 50000,
      date: 'Apr 30 2024',
      transactions: [
        TransactionModel(
          date: 'May 1 2024',
          id: 'trans_103',
          name: 'Work Salary',
          amount: 50000,
          iconName: '0xe227', // attach_money
        ),
      ],
    ),
    BookModel(
      id: 'book_003',
      title: 'Savings',
      amount: 24022,
      date: 'May 1 2024',
      transactions: [
        TransactionModel(
          date: 'May 1 2024',
          id: 'trans_104',
          name: 'Emergency Fund',
          amount: 300,
          iconName: '0xe84f', // account_balance
        ),
        TransactionModel(
          date: 'May 1 2024',
          id: 'trans_105',
          name: 'Interest Earned',
          amount: 150,
          iconName: '0xe2eb', // savings
        ),
      ],
    ),
  ],
);

  @override
  Widget build(BuildContext context) {
    return
       Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Buscar libros",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tus libros",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {},
              child:
                 const Row(children: [Icon(Icons.add), Text("Agregar libro")]),
            )
          ],
        ),
        Expanded(
            child: ListView.builder(
          itemCount: user.books.length,
          itemBuilder: (context, index) {
            return BookWidget(bookModel: user.books[index]);
          },
        ))
      ],
    );
  }
}
