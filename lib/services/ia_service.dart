import 'dart:convert';
import 'package:http/http.dart' as http;

class IAService {

  static const String baseUrl = 'https://medihora-api.onrender.com';
  
  Future<String> consultarMedicamento(
    String medicamento, 
    String tipoConsulta,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medicamento'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'medicamento': medicamento,
          'tipo_consulta': tipoConsulta,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['resposta'];
      } else {
        return 'Erro ao consultar medicamento. Tenta novamente.';
      }
    } catch (e) {
      return 'Erro de conexão. Verifica a tua internet.';
    }
  }

  Future<bool> verificarStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}