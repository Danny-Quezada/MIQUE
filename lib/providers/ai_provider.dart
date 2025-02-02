import 'package:flutter/material.dart';
import 'package:mi_que/domain/interfaces/ai_model.dart';

class AiProvider extends ChangeNotifier {
  List<String> messages = [];
  AiModel aiModel;
  AiProvider({required this.aiModel});

  Future<void> sendMessage(String message) async {
    try {
      messages.add(await aiModel.sendMessage(message));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendOpinion(String message) async {
    try {
      return await aiModel.sendMessage(message);
    } catch (e) {
      rethrow;
    }
  }
}
