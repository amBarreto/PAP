import 'dart:convert'; //json para dart
import 'package:http/http.dart' as http;

class IAService {

  static const String baseUrl = 'https://medihora-api.onrender.com';
  
  Future<String> perguntar(String pergunta, {String contexto = ''}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'), //monta url
        headers: {'Content-Type': 'application/json'},
        body: json.encode({ //dart pa json
          'pergunta': pergunta,
          'contexto': contexto,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)); //bytes -> string -> json
        return data['resposta'];
      } else {
        return 'Erro ao contactar o servidor. Tenta novamente.';
      }
    } catch (e) {
      return 'Erro de conexão. Verifica a tua internet.';
    }
  }
//verifica se a API está online
  Future<bool> verificarStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}