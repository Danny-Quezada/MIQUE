import 'package:flutter/material.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mi_que/domain/entities/book_model.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/providers/book_provider.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/utils/date_converter.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:mi_que/ui/widgets/amount_container_widget.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';
import 'package:mi_que/ui/widgets/transaction_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class TransactionPage extends StatelessWidget {
  BookModel bookModel;
  TransactionPage({super.key, required this.bookModel});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    return SafeScaffold(
        bottomNavigationBar: BottomButtons(bookModel: bookModel),
        appBar: AppBar(
          title: Text(bookModel.title),
        ),
        body: StreamBuilder<Iterable<TransactionModel>>(
            stream: bookProvider.readTransactions(
                userProvider.firebaseUser!.uid, bookModel.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error al cargar las transacciones"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const SkeletonView();
              }
              if (snapshot.hasData) {
                final incomes = snapshot.data!
                    .where((x) => x.amount > 0)
                    .fold<double>(0.0, (sum, element) => sum + element.amount);
                final expenses = snapshot.data!
                    .where((x) => x.amount < 0)
                    .fold<double>(0.0, (sum, element) => sum + element.amount);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountContainerWidget(
                        amount: incomes + expenses,
                        title: "Balance neto",
                        color: (incomes + expenses) < 0
                            ? SettingColor.redColor
                            : SettingColor.principalColor),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: AmountContainerWidget(
                            amount: incomes,
                            color: SettingColor.principalColor,
                            title: "Ingresos",
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: AmountContainerWidget(
                                  amount: expenses,
                                  title: "Egresos",
                                  color: SettingColor.redColor)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Transacciones",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    await bookProvider.deleteTransaction(
                                        snapshot.data!.elementAt(index),
                                        bookModel.id,
                                        userProvider.firebaseUser!.uid,
                                        DateConverter
                                            .formatDateWithMonthName());
                                  },
                                  icon: Icons.delete_rounded,
                                  backgroundColor: SettingColor.redColor,
                                )
                              ]),
                          child: TransactionWidget(
                              transactionModel:
                                  snapshot.data!.elementAt(index)),
                        );
                      },
                    ))
                  ],
                );
              }
              return Container();
            }));
  }
}

class SkeletonView extends StatelessWidget {
  const SkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: Column(
      children: [
        const SkeletonAvatar(
          style: SkeletonAvatarStyle(width: double.infinity, height: 30),
        ),
        const Row(
          children: [
            Expanded(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(width: double.infinity, height: 30),
              ),
            ),
            Expanded(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(width: double.infinity, height: 30),
              ),
            )
          ],
        ),
        SkeletonParagraph(
          style: const SkeletonParagraphStyle(lines: 1),
        ),
        Expanded(child: SkeletonListView())
      ],
    ));
  }
}

class BottomButtons extends StatelessWidget {
  BookModel bookModel;
  BottomButtons({required this.bookModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón Cash In
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Ingreso",
                        style: TextStyle(
                            color: SettingColor.greenColor,
                            fontWeight: FontWeight.bold),
                      ),
                      content: TransactionForm(
                        bookModel: bookModel,
                        isIncome: true,
                      ),
                    );
                  },
                );
                // Acción para Cash In
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SettingColor.greenColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '+ Ingreso',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10), // Espacio entre los botones

          // Botón Cash Out
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Acción para Cash Out
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Egreso",
                        style: TextStyle(
                            color: SettingColor.redColor,
                            fontWeight: FontWeight.bold),
                      ),
                      content: TransactionForm(bookModel: bookModel),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SettingColor.redColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '- Egreso',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  BookModel bookModel;
  bool? isIncome = false;
  TransactionForm({super.key, this.isIncome, required this.bookModel});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  Icon _icon = const Icon(Icons.money_sharp);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _datetime = DateTime.now();
  _pickIcon() async {
    IconData? icon =
        await FlutterIconPicker.showIconPicker(context, iconPackModes: [
      IconPack.custom
    ], customIconPack: {
      "Universidad": Icons.school,
      "Renta": Icons.house,
      "Dinero": Icons.money_sharp,
      "Luz": Icons.lightbulb_sharp,
      "Agua": Icons.water_damage_rounded,
      "Comida": Icons.food_bank,
      "GYM": Icons.sports_gymnastics_outlined,
      "Niños": Icons.diversity_1_sharp,
      "Gasolina": Icons.local_gas_station_sharp,
      "Juegos": Icons.games,
      "Diversión": Icons.park_rounded
    });

    _icon = icon != null ? Icon(icon) : _icon;
    if (_icon.icon == icon) {
      setState(() {});
    }

    debugPrint('Picked Icon:  $icon');
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText:
                    "${widget.isIncome == true ? "Ingreso" : "Egreso"} de la transacción",
                prefixIcon: const Icon(Icons.title),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa el nombre del ${widget.isIncome == true ? "Ingreso" : "Egreso"}';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: widget.isIncome == true ? "Ingreso" : "Egreso",
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa el ${widget.isIncome == true ? "Ingreso" : "Egreso"}';
                } else if (double.tryParse(value) == null) {
                  return "Por favor, que sea mayor";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Seleccione fecha o por defecto hoy",
              style: TextStyle(fontSize: 12),
            ),
            TextButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(
                        widget.isIncome == true
                            ? SettingColor.greenColor
                            : SettingColor.redColor),
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                onPressed: () async {
                  _datetime = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2030)) ??
                      DateTime.now();
                  if (_datetime != DateTime.now()) {
                    setState(() {});
                  }
                },
                child: Text(
                    DateConverter.formatDateWithMonthName(date: _datetime))),
            const SizedBox(
              height: 8,
            ),
            const Text("Escoja icono"),
            IconButton(
                onPressed: _pickIcon,
                icon: Icon(
                  _icon!.icon,
                  color: widget.isIncome == true
                      ? SettingColor.greenColor
                      : SettingColor.redColor,
                )),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        widget.isIncome == true
                            ? SettingColor.greenColor
                            : SettingColor.redColor)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await bookProvider.createTransaction(
                        TransactionModel(
                            id: "",
                            name: _nameController.text,
                            amount: widget.isIncome == true
                                ? double.parse(_amountController.text)
                                : -double.parse(_amountController.text),
                            iconName: _icon.icon!.codePoint.toString(),
                            date: DateConverter.formatDateWithMonthName(
                                date: _datetime)),
                        widget.bookModel.id,
                        userProvider.firebaseUser!.uid);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                    "Crear ${widget.isIncome == true ? "Ingreso" : "Egreso"}"))
          ],
        ),
      ),
    );
  }
}
