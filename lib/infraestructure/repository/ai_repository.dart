import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mi_que/domain/interfaces/ai_model.dart';

class AiRepository implements AiModel {
  String cleanResponse(String response) {
    response =
        response.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '');

    response = response.trim();

    return response;
  }

  @override
  Future<String> sendMessage(String message) async {
    final String baseUrl = dotenv.env['BASE_URL']!;
    final String endpoint = dotenv.env['ENDPOINT']!;
    final String apiKey = dotenv.env["API_KEY"]!;
    final String model = dotenv.env["MODEL"]!;
    final Uri url = Uri.parse("$baseUrl$endpoint");

    final Map<String, dynamic> requestBody = {
      "api_key": apiKey, // Depending api_key or apikey (depending your API)
      "model": model,
      "messages": [
        {
          "role": "system",
          "content":
              "Eres el asistente de la aplicación MIQUE, una herramienta diseñada para ayudar a los usuarios a controlar sus finanzas personales. MIQUE permite registrar, visualizar y gestionar ingresos y egresos de manera eficiente. También ofrece análisis detallados, como balances diarios, proyecciones mensuales y un tablero (dashboard) completo para que los usuarios tomen decisiones informadas sobre su dinero. Tu rol es asistir a los usuarios en el uso de la aplicación, responder preguntas relacionadas con sus finanzas y proporcionar consejos útiles para mejorar su gestión financiera. **Solo debes responder preguntas relacionadas con MIQUE y finanzas personales. Si el usuario hace una pregunta fuera de este tema, responde amablemente indicando que solo puedes ayudar con temas relacionados con MIQUE y finanzas.** Mantén un tono amigable y profesional, y asegúrate de proporcionar información clara y precisa.",
        },
        {
          "role": "user",
          "content": message,
        }
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        final String responseMessage =
            responseBody["choices"][0]["message"]["content"];
        String cleanedResponse = cleanResponse(responseMessage);
        return cleanedResponse;
      } else {
        throw Exception(
            "Failed to fetch response: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error sending message to Ollama: $e");
    }
  }
}
