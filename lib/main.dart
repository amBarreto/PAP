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

class _MedicationPageState extends State<MedicationPage> {
  List<Medicamento> meds = [];

  final mediController = TextEditingController();
  final hourController = TextEditingController();
  final utenteController = TextEditingController();

  DateTimeRange? selectedDateRange;
  Set<int> selectedDays = {};
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
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDateRange: selectedDateRange,
    );
    if (newDateRange != null) {
      setState(() {
        selectedDateRange = newDateRange;
      });
    }
  }

  Future<void> addMed() async {
    final medicamento = mediController.text.trim();
    final hora = hourController.text.trim();
    final utente = utenteController.text.trim();

    if (medicamento.isEmpty || hora.isEmpty || utente.isEmpty || selectedDateRange == null || selectedDays.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Aviso!'),
          content: Text('Preencha todos os campos, selecione o período da toma e os dias da semana'),
        ),
      );
      return;
    }

    final novoMed = Medicamento(
      medicamento: medicamento,
      hora: hora,
      utente: utente,
      dataInicio: selectedDateRange!.start,
      dataFim: selectedDateRange!.end,
      diasSemana: selectedDays.toList(),
    );

    await isar.writeTxn(() async => await isar.medicamentos.put(novoMed));
    await loadMeds();

    mediController.clear();
    hourController.clear();
    utenteController.clear();
    selectedDateRange = null;
    selectedDays.clear();
  }

  Future<void> removeMed(int index) async {
    await isar.writeTxn(() async {
      await isar.medicamentos.delete(meds[index].id);
    });
    await loadMeds();
  }

  void editarMed(Medicamento med) {
    final nomeController = TextEditingController(text: med.medicamento);
    final horaController = TextEditingController(text: med.hora);
    final utenteController = TextEditingController(text: med.utente);
    DateTimeRange range = DateTimeRange(start: med.dataInicio, end: med.dataFim);
    Set<int> diasSelecionados = med.diasSemana.toSet();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Editar Medicação'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: utenteController,
                    decoration: const InputDecoration(labelText: 'Utente'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Medicamento'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: horaController,
                    decoration: const InputDecoration(labelText: 'Hora (ex: 08:00)'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'De: ${range.start.day}/${range.start.month}/${range.start.year} '
                    'Até: ${range.end.day}/${range.end.month}/${range.end.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () async {
                      final novoRange = await showDateRangePicker(
                        context: context,
                        initialDateRange: range,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (novoRange != null) {
                        setStateDialog(() => range = novoRange);
                      }
                    },
                    child: const Text('Alterar Período'),
                  ),
                  Wrap(
                    spacing: 5,
                    children: List.generate(7, (index) {
                      final dia = index + 1;
                      final selecionado = diasSelecionados.contains(dia);
                      return FilterChip(
                        label: Text(daysLabels[index]),
                        selected: selecionado,
                        onSelected: (bool selected) {
                          setStateDialog(() {
                            if (selected) {
                              diasSelecionados.add(dia);
                            } else {
                              diasSelecionados.remove(dia);
                            }
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final novoNome = nomeController.text.trim();
                  final novaHora = horaController.text.trim();
                  final novoUtente = utenteController.text.trim();

                  if (novoNome.isEmpty || novaHora.isEmpty || novoUtente.isEmpty || diasSelecionados.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  await isar.writeTxn(() async {
                    med.medicamento = novoNome;
                    med.hora = novaHora;
                    med.utente = novoUtente;
                    med.dataInicio = range.start;
                    med.dataFim = range.end;
                    med.diasSemana = diasSelecionados.toList();
                    await isar.medicamentos.put(med);
                  });

                  Navigator.pop(context);
                  await loadMeds();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        });
      },
    );
  }

  String formatDays(List<int> days) {
    final sortedDays = List<int>.from(days)..sort();
    return sortedDays.map((d) => daysLabels[d - 1]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 MediHora'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      drawer: ThemeDrawer(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: utenteController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Utente',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: mediController,
                        decoration: InputDecoration(
                          labelText: 'Nome do medicamento',
                          prefixIcon: const Icon(Icons.medication_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: hourController,
                        decoration: InputDecoration(
                          labelText: 'Hora (ex: 08:00)',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDateRange == null
                                  ? 'Nenhum período selecionado'
                                  : 'De: ${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} '
                                    'Até: ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: pickDateRange,
                            child: const Text('Selecionar Período'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        children: List.generate(7, (index) {
                          final dayNum = index + 1;
                          final isSelected = selectedDays.contains(dayNum);
                          return FilterChip(
                            label: Text(daysLabels[index]),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedDays.add(dayNum);
                                } else {
                                  selectedDays.remove(dayNum);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: addMed,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Medicação'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              meds.isEmpty
                  ? const Text("Nenhuma medicação foi registada!", style: TextStyle(color: Colors.grey))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meds.length,
                      itemBuilder: (context, index) {
                        final med = meds[index];
                        final dateRangeText =
                            'De ${med.dataInicio.day}/${med.dataInicio.month}/${med.dataInicio.year} até ${med.dataFim.day}/${med.dataFim.month}/${med.dataFim.year}';
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: const Icon(Icons.medication_liquid, color: Colors.teal),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Utente: ${med.utente}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Medicamento: ${med.medicamento}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('Hora: ${med.hora}'),
                                const SizedBox(height: 2),
                                Text(dateRangeText, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                const SizedBox(height: 2),
                                Text(
                                  'Dias: ${formatDays(med.diasSemana)}',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey[700]),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editarMed(med),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
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
