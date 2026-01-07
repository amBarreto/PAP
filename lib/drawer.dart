import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

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
              children:[
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

          /* ================= LINHA DE APOIO ================= */
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Linha de apoio'),
            subtitle: const Text('808 24 24 24'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Linha de apoio'),
                  content: const Text(
                    'Linha de Apoio SNS 24.\n\n'
                    '📞 808 24 24 24',
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          /* ================= SOBRE ================= */
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Sobre'),
            subtitle: Text('Versão académica / demonstrativa'),
          ),
        ],
      ),
    );
  }
}