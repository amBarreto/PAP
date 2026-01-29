import 'package:flutter/material.dart';
import 'services/notification_service.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  Future<void> _verAlarmes(BuildContext context) async {
    final alarmes = await NotificationService().getPendingNotifications();
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('📋 Alarmes Agendados'),
        content: SingleChildScrollView(
          child: alarmes.isEmpty
              ? const Text(
                  'Nenhum alarme agendado no momento.\n\n'
                  'Adicione medicamentos na página principal para criar alarmes.',
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
                    const SizedBox(height: 16),
                    ...alarmes.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.alarm),
                              title: Text(a.title ?? 'Sem título'),
                              subtitle: Text(a.body ?? 'Sem descrição'),
                              trailing: Text(
                                'ID: ${a.id}',
                                style: const TextStyle(fontSize: 10),
                              ),
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
            secondary: const Icon(Icons.dark_mode),
            value: isDarkMode,
            onChanged: (_) => toggleTheme(),
          ),

          const Divider(),

          /* ================= VER ALARMES ================= */
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Ver alarmes agendados'),
            subtitle: const Text('Consultar notificações programadas'),
            onTap: () {
              Navigator.pop(context); // Fecha a drawer
              _verAlarmes(context);
            },
          ),

          const Divider(),

          /* ================= LINHA DE APOIO ================= */
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Linha de apoio'),
            subtitle: const Text('808 24 24 24'),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Linha de apoio'),
                  content: const Text(
                    'Linha de Apoio SNS 24.\n\n'
                    '📞 808 24 24 24',
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          /* ================= SOBRE/INFORMAÇÃO ================= */
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('INFORMAÇÃO/SOBRE'),
            subtitle: Text('Esta aplicação foi desenvolvida para fins académicos e de demonstração. '
                'Não deve ser utilizada como substituto de aconselhamento médico profissional. '
                'Consulte sempre um profissional de saúde qualificado para questões relacionadas com a sua saúde e medicação.'),
          ),
        ],
      ),
    );
  }
}