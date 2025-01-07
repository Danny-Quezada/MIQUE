class TransactionModel {
  final String id;
  final String name;
  final double amount;
 
  final String iconName;
  
  final String date;
  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
  
    required this.iconName,
    required this.date,
  });

  // Convertir de Firestore a objeto Dart
  factory TransactionModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return TransactionModel(
      id: documentId,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
    
      iconName: data['iconName'] ?? 'default_icon',
    );
  }

  // Convertir de objeto Dart a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'amount': amount,
     
      'iconName': iconName,
      'date': date,
    };
  }
}
