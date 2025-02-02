import 'package:flutter/material.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/ui/widgets/ai_button.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transactionModel;

  const TransactionWidget({super.key, required this.transactionModel});

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
      onTap: () async {
        final String transactionType =
            transactionModel.amount > 0 ? "Ingreso" : "Egreso";

        await aiButton("""
📌 **Análisis de Transacción**  
- **Tipo:** $transactionType  
- **Monto:** \$${transactionModel.amount.toStringAsFixed(2)}  
- **Fecha:** ${transactionModel.date}  

🧐 **Instrucciones:**  
1️⃣ Analiza esta transacción en específico y proporciona consejos basados en su tipo y monto.  
2️⃣ Si es un **egreso**, dame estrategias para reducir este gasto en el futuro.  
3️⃣ No incluyas recomendaciones generales ni analices otras transacciones, solo esta en particular.  
""", context);
      },
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
