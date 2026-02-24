import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/notification_service.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  // Ver alarmes de MEDICAMENTOS (agrupados)
  Future<void> _verAlarmesMedicamentos(BuildContext context) async {
    final todosAlarmes = await NotificationService().getPendingNotifications();

    // Filtrar: IDs de medicamentos < 10000
    final alarmes = todosAlarmes.where((a) => a.id < 10000).toList();

    // Agrupar por título + body (title+body iguais = mesmo medicamento)
    final Map<String, List<dynamic>> grupos = {};
    for (var a in alarmes) {
      final chave = '${a.title}_${a.body}';
      grupos.putIfAbsent(chave, () => []).add(a);
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('💊 Alarmes de Medicamentos (${grupos.length})'),
        content: SingleChildScrollView(
          child: grupos.isEmpty
              ? const Text(
                  'Nenhum alarme de medicamento agendado.\n\n'
                  'Adicione medicamentos para criar alarmes.',
                  textAlign: TextAlign.center,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: ${grupos.length} alarme(s)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ...grupos.values.map((grupo) {
                      final primeiro = grupo.first;
                      final quantidade = grupo.length;

                      // Calcular label dos dias
                      String diasLabel;
                      if (quantidade == 7) {
                        diasLabel = 'Todos os dias';
                      } else if (quantidade == 1) {
                        diasLabel = '1 dia por semana';
                      } else {
                        diasLabel = '$quantidade dias por semana';
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.medication, color: Colors.teal),
                          title: Text(
                            primeiro.title ?? 'Sem título',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${primeiro.body ?? ''}\n📅 $diasLabel',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    }),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  // Ver alarmes de CONSULTAS
  Future<void> _verAlarmesConsultas(BuildContext context) async {
    final todosAlarmes = await NotificationService().getPendingNotifications();
    
    // Filtrar: IDs de consultas >= 10000
    final alarmes = todosAlarmes.where((a) => a.id >= 10000).toList();

    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('📅 Alarmes de Consultas (${alarmes.length})'),
        content: SingleChildScrollView(
          child: alarmes.isEmpty
              ? const Text(
                  'Nenhum alarme de consulta agendado.\n\n'
                  'Adicione consultas para criar lembretes.',
                  textAlign: TextAlign.center,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: ${alarmes.length} alarme(s)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ...alarmes.map((a) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                            title: Text(
                              a.title ?? 'Sem título',
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              a.body ?? 'Sem descrição',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              '#${a.id}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        )),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _ligarNumero(BuildContext context, String numero, String nome) async {
    final Uri telUri = Uri.parse('tel:$numero');
    
    try {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir telefone: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.teal,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.medication, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  'MediHora',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Gestão de medicação',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /* ================= TEMA ================= */
          SwitchListTile(
            title: const Text('Modo escuro'),
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? Colors.amber : Colors.orange,
            ),
            value: isDarkMode,
            onChanged: (_) => toggleTheme(),
          ),

          const Divider(),

          /* ================= ALARMES ================= */
          ListTile(
            leading: const Icon(Icons.medication, color: Colors.teal),
            title: const Text('Ver alarmes de medicamentos'),
            subtitle: const Text('Notificações de medicação'),
            onTap: () {
              Navigator.pop(context);
              _verAlarmesMedicamentos(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            title: const Text('Ver alarmes de consultas'),
            subtitle: const Text('Lembretes de consultas médicas'),
            onTap: () {
              Navigator.pop(context);
              _verAlarmesConsultas(context);
            },
          ),

          const Divider(),

          /* ================= LINHAS DE APOIO ================= */
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Linhas de Apoio',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone, color: Colors.blue),
            ),
            title: const Text('Linha de Saúde Açores', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('808 24 60 24'),
            trailing: const Icon(Icons.call, color: Colors.blue),
            onTap: () {
              Navigator.pop(context);
              _ligarNumero(context, '808246024', 'Linha de Saúde Açores');
            },
          ),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.emergency, color: Colors.red),
            ),
            title: const Text('Emergência 112', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Chamada de emergência'),
            trailing: const Icon(Icons.call, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('🆘 Ligar 112?'),
                  content: const Text('Tens a certeza que queres ligar para o número de emergência?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                        _ligarNumero(context, '112', '112');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ligar'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          /* ================= SOBRE/INFORMAÇÃO ================= */
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline,
                color: Colors.grey.shade700,
              ),
            ),
            title: const Text('INFORMAÇÃO/SOBRE'),
            subtitle: const Text(
              'Esta aplicação foi desenvolvida para fins académicos e de demonstração. '
              'Não deve ser utilizada como substituto de aconselhamento médico profissional. '
              'Consulte sempre um profissional de saúde qualificado para questões relacionadas com a sua saúde e medicação.',
            ),
          )
        ],
      ),
    );
  }
}