//controla a navegaçao entre paginas

import 'package:flutter/material.dart';
import 'main.dart';
import 'pages/consultas_page.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lista de páginas
    final pages = [
      MedicationPage(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
        showAppBar: false,  // Não mostra AppBar própria
      ),
      const ConsultasPage(showAppBar: false),  // Não mostra AppBar própria
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 MediHora'),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      body: pages[_currentIndex],  // Mostra a página atual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Consultas',
          ),
        ],
      ),
    );
  }
}