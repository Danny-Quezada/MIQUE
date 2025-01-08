import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';

class TransactionWidget extends StatelessWidget {
  TransactionModel transactionModel;
  TransactionWidget({super.key, required this.transactionModel});

  IconData getIconFromString(String iconName) {
    const iconFamily = 'MaterialIcons';

    try {
      return IconData(
        int.parse(iconName),
        fontFamily: iconFamily,
      );
    } catch (e) {
      return Icons.help_outline; // Fallback si el nombre no es válido
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Icon(getIconFromString(transactionModel.iconName),
            color: Colors.blue),
      ),
      title: Text(
        transactionModel.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        transactionModel.date,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Text(
        (transactionModel.amount > 0 ? "+" : "") +
            transactionModel.amount.toString(),
        style: TextStyle(
          color: transactionModel.amount > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
