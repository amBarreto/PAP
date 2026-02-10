import 'package:flutter/material.dart';
import '../services/ia_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IAPage extends StatefulWidget {
  final bool showAppBar;

  const IAPage({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<IAPage> createState() => _IAPageState();
}

class _IAPageState extends State<IAPage> {
  final TextEditingController medicamentoController = TextEditingController(); // Controlador do campo de texto
  final IAService iaService = IAService(); //API
  
  bool isLoading = false;
  bool isOnline = false;
  String? resposta;
  String? medicamentoAtual;
  String? tipoConsultaAtual;

  // Categorias disponíveis
  final List<Map<String, dynamic>> categorias = [
    {
      'id': 'para_que_serve',
      'titulo': 'Para que serve?',
      'icon': Icons.help_outline,
      'cor': Colors.blue,
    },
    {
      'id': 'como_tomar',
      'titulo': 'Como tomar?',
      'icon': Icons.access_time,
      'cor': Colors.green,
    },
    {
      'id': 'efeitos_secundarios',
      'titulo': 'Efeitos secundários',
      'icon': Icons.warning_amber,
      'cor': Colors.orange,
    },
    {
      'id': 'contraindicacoes',
      'titulo': 'Contraindicações',
      'icon': Icons.block,
      'cor': Colors.red,
    },
    {
      'id': 'interacoes',
      'titulo': 'Interações',

      'icon': Icons.sync_problem,
      'cor': Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    verificarStatus();
  }

  Future<void> verificarStatus() async {
    final status = await iaService.verificarStatus();
    setState(() => isOnline = status);
  }

  Future<void> consultarMedicamento(String tipoConsulta) async {
    if (medicamentoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreve o nome do medicamento')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      resposta = null;
      medicamentoAtual = medicamentoController.text.trim();
      tipoConsultaAtual = tipoConsulta;
    });

    final resultado = await iaService.consultarMedicamento( // Chamada à API
      medicamentoController.text.trim(),
      tipoConsulta,
    );

    setState(() {
      resposta = resultado;
      isLoading = false;
    });
  }

  String getTituloCategoria(String id) {
    return categorias.firstWhere((c) => c['id'] == id)['titulo'];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('💊 Pesquisar Medicamento'),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOnline ? Icons.cloud_done : Icons.cloud_off,
                            color: isOnline ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: isOnline ? Colors.green.shade900 : Colors.red.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de pesquisa
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nome do medicamento:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: medicamentoController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Paracetamol, Ibuprofeno...',
                        prefixIcon: const Icon(Icons.medication),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      ),
                      textCapitalization: TextCapitalization.words,
                      enabled: !isLoading,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Título das categorias
            const Text(
              'O que queres saber?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Botões de categorias
            ...categorias.map((categoria) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton.icon(
                onPressed: isLoading 
                    ? null 
                    : () => consultarMedicamento(categoria['id']),
                icon: Icon(categoria['icon'], size: 24),
                label: Text(
                  categoria['titulo'],
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoria['cor'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )),

            // Indicador de carregamento
            if (isLoading) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'A consultar informações sobre $medicamentoAtual...',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            // Resposta
            if (resposta != null && !isLoading) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                color: isDark ? Colors.grey.shade900 : Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$medicamentoAtual - ${getTituloCategoria(tipoConsultaAtual!)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      MarkdownBody(
                        data: resposta!, //resposta da API
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          strong: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          listBullet: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.amber.shade900),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Esta informação não substitui consulta médica',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}