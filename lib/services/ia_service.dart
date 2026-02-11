import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';  // 🔹 ADICIONA

class IAService {
  // 🔹 LER URL DO .ENV (em vez de hardcoded)
  String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  
  Future<String> consultarMedicamento(
    String medicamento, 
    String tipoConsulta,
  ) async {
    // 🔹 Verificar se URL está configurada
    if (baseUrl.isEmpty) {
      return '❌ Erro: API_BASE_URL não configurada no ficheiro .env';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medicamento'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'medicamento': medicamento,
          'tipo_consulta': tipoConsulta,
        }),
      ).timeout(const Duration(seconds: 90));  //Timeout para evitar espera infinita

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['resposta'];
      } else {
        return 'Erro ao consultar medicamento (${response.statusCode}). Tenta novamente.';
      }
    } catch (e) {
      print('❌ Erro ao consultar medicamento: $e');  // 🔹 Debug
      return 'Erro de conexão. Verifica a tua internet.';
    }
  }

  Future<bool> verificarStatus() async {
    // 🔹 Verificar se URL está configurada
    if (baseUrl.isEmpty) {
      print('❌ API_BASE_URL não configurada no .env');
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));  // 🔹 Timeout
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao verificar status: $e');  // 🔹 Debug
      return false;
    }
  }
}