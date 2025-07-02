import 'package:flutter/material.dart';
import 'theme_drawer.dart';

void main() {
  runApp(MediHoraApp());
}

class MediHoraApp extends StatefulWidget{
  @override

  State<MediHoraApp> createState() => _MediHoraAppState();
}

class _MediHoraAppState extends State<MediHoraApp> {

  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(){
    setState(() {
      _themeMode =  
            _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'MediHora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: MedicationPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        toggleTheme: toggleTheme,
      ),
    );
  }
}

class MedicationPage extends StatefulWidget {

  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const MedicationPage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> { List<Map<String, String>> meds = [];

  final nameController = TextEditingController();
  final hourController = TextEditingController();
  final utenteController = TextEditingController();

  void addMed() {
    final nome = nameController.text.trim();
    final hora = hourController.text.trim();
    final utente = utenteController.text.trim();

    if (nome.isEmpty || hora.isEmpty || utente.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Aviso!'),
          content: Text('Preencha todos os campos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      meds.add({'nome': nome, 'hora': hora, 'utente': utente});
    });

    nameController.clear();
    hourController.clear();
    utenteController.clear();
  }

  void removeMed(int index) {
    setState(() {
      meds.removeAt(index);
    });
  }

  void editMed(int index) {

    final editUtenteController =TextEditingController(text: meds[index]['utente']);
    final editNameController =TextEditingController(text: meds[index]['nome']);
    final editHourController =TextEditingController(text: meds[index]['hora']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Medicação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              TextField(
                controller: editUtenteController,
                decoration: InputDecoration(
                  labelText: 'Nome do Utente',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do medicamento',
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editHourController,
                decoration: InputDecoration(
                  labelText: 'Hora (ex: 08:00)',
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancelar
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editNameController.text.trim();
                final newHour = editHourController.text.trim();
                final newUtente = editUtenteController.text.trim();

                if (newName.isEmpty || newHour.isEmpty || newUtente.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Aviso!'),
                      content: Text('Preencha todos os campos'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                setState(() {
                  meds[index] = {
                    'nome': newName,
                    'hora': newHour,
                    'utente': newUtente,
                  };
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💊 MediHora'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      drawer: ThemeDrawer(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: utenteController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Utente',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome do medicamento',
                          prefixIcon: Icon(Icons.medication_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: hourController,
                        decoration: InputDecoration(
                          labelText: 'Hora (ex: 08:00)',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: addMed,
                        icon: Icon(Icons.add),
                        label: Text('Adicionar Medicação'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              meds.isEmpty
                  ? Text(
                      "Nenhuma medicação foi registada!",
                      style: TextStyle(color: Colors.grey),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: meds.length,
                      itemBuilder: (context, index) {
                        final med = meds[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Icon(Icons.medication_liquid,
                                color: Colors.teal),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med['utente']!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  med['nome']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Text('Hora: ${med['hora']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editMed(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeMed(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
