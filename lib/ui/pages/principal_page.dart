import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/providers/book_provider.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/utils/date_converter.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:mi_que/ui/widgets/book_widget.dart';
import 'package:provider/provider.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    return Column(
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Agregar libro",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: BookForm(),
                    );
                  },
                );
              },
              child:
                  const Row(children: [Icon(Icons.add), Text("Agregar libro")]),
            )
          ],
        ),
        Expanded(
            child: StreamBuilder<Iterable<BookModel>>(
                stream: bookProvider.readBooks(userProvider.firebaseUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error al cargar los libros"),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Actualizar libro",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: BookForm(
                                            bookModel:
                                                snapshot.data!.elementAt(index),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icons.update_rounded,
                                  backgroundColor: SettingColor.principalColor,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    bookProvider.deleteBook(
                                        snapshot.data!.elementAt(index).id,
                                        userProvider.firebaseUser!.uid);
                                  },
                                  icon: Icons.delete_rounded,
                                  backgroundColor: SettingColor.redColor,
                                ),
                              ]),
                          child: BookWidget(
                              bookModel: snapshot.data!.elementAt(index)),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }))
      ],
    );
  }
}

class BookForm extends StatelessWidget {
  TextEditingController _titleController = TextEditingController();
  BookModel? bookModel;
  final _formKey = GlobalKey<FormState>();
  BookForm({super.key, this.bookModel = null});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText:
                    bookModel != null ? bookModel!.title : "Título del libro",
                prefixIcon: const Icon(Icons.title),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa el título';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (bookModel != null) {
                    await bookProvider.updateName(_titleController.text,
                        userProvider.firebaseUser!.uid, bookModel!.id);
                  } else {
                    await bookProvider.createBook(
                        BookModel(
                            id: '',
                            title: _titleController.text,
                            amount: 0,
                            date: DateConverter.formatDateWithMonthName(),
                            transactions: []),
                        userProvider.userModel!.id);
                  }
                  Navigator.pop(context);
                }
              },
              child:
                  Text("${bookModel != null ? "Actualizar" : "Crear"} libro"),
            ),
          ],
        ),
      ),
    );
  }
}
