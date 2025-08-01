import 'package:flutter/material.dart';

class ThemeDrawer extends StatelessWidget {
  
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ThemeDrawer({
    
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,

  });


  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountEmail: null,
            accountName: Text('Defeniçoes', style: TextStyle(fontSize: 16)), 
            currentAccountPicture: Icon(Icons.settings, color:Colors.white, size: 40),
          ),
          ListTile(
            leading: Icon(isDarkMode ? Icons.light_mode: Icons.dark_mode),
            title: Text(isDarkMode ? 'Modo Claro' : 'Modo Escuro'),
            onTap: toggleTheme,
          )
        ],
      ),
    );
  }
}