import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medihora/models/medicamento.dart';
import 'theme_drawer.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [MedicamentoSchema],
    directory: dir.path,
  );

  runApp(const MediHoraApp());
}

class MediHoraApp extends StatefulWidget {
  const MediHoraApp({super.key});

  @override
  State<MediHoraApp> createState() => _MediHoraAppState();
}

class _MediHoraAppState extends State<MediHoraApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
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
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  List<Medicamento> meds = [];

  final mediController = TextEditingController();
  final hourController = TextEditingController();
  final utenteController = TextEditingController();

  DateTimeRange? selectedDateRange;
  Set<int> selectedDays = {};
  bool permanente = true;

  final List<String> daysLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    loadMeds();
  }

  Future<void> loadMeds() async {
    final all = await isar.medicamentos.where().findAll();
    setState(() {
      meds = all;
    });
  }

  void pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (range != null) {
      setState(() {
        selectedDateRange = range;
      });
    }
  }

  Future<void> addMed() async {
    final medicamento = mediController.text.trim();
    final hora = hourController.text.trim();
    final utente = utenteController.text.trim();

    if (medicamento.isEmpty ||
        hora.isEmpty ||
        utente.isEmpty ||
        selectedDays.isEmpty ||
        (!permanente && selectedDateRange == null)) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Aviso'),
          content: Text(
            'Preencha todos os campos obrigatórios.\n'
            'Medicamentos não permanentes precisam de período.',
          ),
        ),
      );
      return;
    }

    final novoMed = Medicamento(
      medicamento: medicamento,
      hora: hora,
      utente: utente,
      permanente: permanente,
      dataInicio: permanente ? null : selectedDateRange!.start,
      dataFim: permanente ? null : selectedDateRange!.end,
      diasSemana: selectedDays.toList(),
    );

    await isar.writeTxn(() async {
      await isar.medicamentos.put(novoMed);
    });

    mediController.clear();
    hourController.clear();
    utenteController.clear();
    selectedDateRange = null;
    selectedDays.clear();
    permanente = true;

    await loadMeds();
  }

  Future<void> removeMed(Medicamento med) async {
    await isar.writeTxn(() async {
      await isar.medicamentos.delete(med.id);
    });
    await loadMeds();
  }

  String formatDays(List<int> days) {
    final sorted = List<int>.from(days)..sort();
    return sorted.map((d) => daysLabels[d - 1]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 MediHora'),
        centerTitle: true,
      ),
      drawer: ThemeDrawer(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: utenteController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Utente',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: mediController,
                      decoration: const InputDecoration(
                        labelText: 'Medicamento',
                        prefixIcon: Icon(Icons.medication),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: hourController,
                      decoration: const InputDecoration(
                        labelText: 'Hora (ex: 08:00)',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    const SizedBox(height: 10),

                    SwitchListTile(
                      title: const Text('Medicamento permanente'),
                      subtitle:
                          const Text('Não necessita de período de datas'),
                      value: permanente,
                      onChanged: (value) {
                        setState(() {
                          permanente = value;
                          if (permanente) {
                            selectedDateRange = null;
                          }
                        });
                      },
                    ),

                    if (!permanente)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDateRange == null
                                  ? 'Nenhum período selecionado'
                                  : 'De ${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} '
                                    'até ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}',
                            ),
                          ),
                          TextButton(
                            onPressed: pickDateRange,
                            child: const Text('Selecionar período'),
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: List.generate(7, (index) {
                        final day = index + 1;
                        return FilterChip(
                          label: Text(daysLabels[index]),
                          selected: selectedDays.contains(day),
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? selectedDays.add(day)
                                  : selectedDays.remove(day);
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: addMed,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Medicação'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            meds.isEmpty
                ? const Text('Nenhuma medicação registada')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meds.length,
                    itemBuilder: (_, i) {
                      final med = meds[i];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.medication),
                          title: Text('${med.medicamento} • ${med.hora}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Utente: ${med.utente}'),
                              Text(
                                med.permanente
                                    ? 'Medicamento permanente'
                                    : 'De ${med.dataInicio!.day}/${med.dataInicio!.month}/${med.dataInicio!.year} '
                                      'até ${med.dataFim!.day}/${med.dataFim!.month}/${med.dataFim!.year}',
                              ),
                              Text('Dias: ${formatDays(med.diasSemana)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeMed(med),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
