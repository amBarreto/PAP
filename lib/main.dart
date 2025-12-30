import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/medicamento.dart';
import 'theme_drawer.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      themeMode: _themeMode,
      theme: ThemeData(primarySwatch: Colors.teal),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
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
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

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

  // 🔹 ADICIONADO (recorrente)
  bool recorrente = false;
  int intervaloHoras = 8;

  Medicamento? medEmEdicao;

  final daysLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    loadMeds();
  }

  Future<void> loadMeds() async {
    final all = await isar.medicamentos.where().findAll();
    setState(() => meds = all);
  }

  void limparFormulario() {
    mediController.clear();
    hourController.clear();
    utenteController.clear();
    selectedDays.clear();
    selectedDateRange = null;
    permanente = true;
    recorrente = false;
    intervaloHoras = 8;
    medEmEdicao = null;
  }

  void pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (range != null) {
      setState(() => selectedDateRange = range);
    }
  }

  Future<void> guardarMedicamento() async {
    if (mediController.text.isEmpty ||
        hourController.text.isEmpty ||
        utenteController.text.isEmpty ||
        selectedDays.isEmpty ||
        (!permanente && selectedDateRange == null)) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Aviso'),
          content: Text('Preenche todos os campos obrigatórios.'),
        ),
      );
      return;
    }

    final novoMed = Medicamento(
      medicamento: mediController.text.trim(),
      hora: hourController.text.trim(),
      utente: utenteController.text.trim(),
      permanente: permanente,
      dataInicio: permanente ? null : selectedDateRange!.start,
      dataFim: permanente ? null : selectedDateRange!.end,
      diasSemana: selectedDays.toList(),
      recorrente: recorrente,
      intervaloHoras: recorrente ? intervaloHoras : null,
    );

    if (medEmEdicao != null) {
      novoMed.id = medEmEdicao!.id;
    }

    await isar.writeTxn(() async {
      await isar.medicamentos.put(novoMed);
    });

    limparFormulario();
    await loadMeds();
  }

  // ---- edição (INALTERADA) ----
  void editarMedicamento(Medicamento med) {
    final editUtenteController = TextEditingController(text: med.utente);
    final editMedicamentoController =
        TextEditingController(text: med.medicamento);
    final editHoraController = TextEditingController(text: med.hora);
    Set<int> editSelectedDays = med.diasSemana.toSet();
    bool editPermanente = med.permanente;
    DateTimeRange? editDateRange = !med.permanente
        ? DateTimeRange(start: med.dataInicio!, end: med.dataFim!)
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Medicamento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: editUtenteController,
                      decoration:
                          const InputDecoration(labelText: 'Utente'),
                    ),
                    TextField(
                      controller: editMedicamentoController,
                      decoration:
                          const InputDecoration(labelText: 'Medicamento'),
                    ),
                    TextField(
                      controller: editHoraController,
                      decoration:
                          const InputDecoration(labelText: 'Hora (08:00)'),
                    ),
                    SwitchListTile(
                      title: const Text('Medicamento permanente'),
                      value: editPermanente,
                      onChanged: (v) {
                        setStateDialog(() {
                          editPermanente = v;
                          if (v) editDateRange = null;
                        });
                      },
                    ),
                    if (!editPermanente)
                      TextButton(
                        onPressed: () async {
                          final range = await showDateRangePicker(
                            context: context,
                            firstDate:
                                DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 5)),
                            initialDateRange: editDateRange,
                          );
                          if (range != null) {
                            setStateDialog(() => editDateRange = range);
                          }
                        },
                        child: Text(
                          editDateRange == null
                              ? 'Selecionar período'
                              : 'Período selecionado',
                        ),
                      ),
                    Wrap(
                      spacing: 6,
                      children: List.generate(7, (i) {
                        final d = i + 1;
                        return FilterChip(
                          label: Text(daysLabels[i]),
                          selected: editSelectedDays.contains(d),
                          onSelected: (v) {
                            setStateDialog(() {
                              v
                                  ? editSelectedDays.add(d)
                                  : editSelectedDays.remove(d);
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final atualizadoMed = Medicamento(
                      utente: editUtenteController.text.trim(),
                      medicamento:
                          editMedicamentoController.text.trim(),
                      hora: editHoraController.text.trim(),
                      permanente: editPermanente,
                      dataInicio:
                          editPermanente ? null : editDateRange!.start,
                      dataFim:
                          editPermanente ? null : editDateRange!.end,
                      diasSemana: editSelectedDays.toList(),
                      recorrente: recorrente,
                    );

                    atualizadoMed.id = med.id;

                    await isar.writeTxn(() async {
                      await isar.medicamentos.put(atualizadoMed);
                    });

                    await loadMeds();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> removerMedicamento(Medicamento med) async {
    await isar.writeTxn(() async {
      await isar.medicamentos.delete(med.id);
    });
    await loadMeds();
  }

  String formatDays(List<int> days) {
    final sorted = [...days]..sort();
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: utenteController,
                      decoration:
                          const InputDecoration(labelText: 'Utente'),
                    ),
                    TextField(
                      controller: mediController,
                      decoration:
                          const InputDecoration(labelText: 'Medicamento'),
                    ),
                    TextField(
                      controller: hourController,
                      decoration:
                          const InputDecoration(labelText: 'Hora (08:00)'),
                    ),

                    // 🔹 ADICIONADO — fixo vs recorrente
                    const SizedBox(height: 8),
                    ToggleButtons(
                      isSelected: [!recorrente, recorrente],
                      onPressed: (index) {
                        setState(() {
                          recorrente = index == 1;
                        });
                      },
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Horário fixo'),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Recorrente'),
                        ),
                      ],
                    ),

                    if (recorrente) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: intervaloHoras,
                        decoration:
                            const InputDecoration(labelText: 'Intervalo'),
                        items: const [
                          DropdownMenuItem(
                              value: 4,
                              child: Text('De 4 em 4 horas')),
                          DropdownMenuItem(
                              value: 6,
                              child: Text('De 6 em 6 horas')),
                          DropdownMenuItem(
                              value: 8,
                              child: Text('De 8 em 8 horas')),
                          DropdownMenuItem(
                              value: 12,
                              child: Text('De 12 em 12 horas')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => intervaloHoras = v);
                          }
                        },
                      ),
                    ],

                    SwitchListTile(
                      title:
                          const Text('Medicamento permanente'),
                      value: permanente,
                      onChanged: (v) {
                        setState(() {
                          permanente = v;
                          if (v) selectedDateRange = null;
                        });
                      },
                    ),
                    if (!permanente)
                      TextButton(
                        onPressed: pickDateRange,
                        child: Text(
                          selectedDateRange == null
                              ? 'Selecionar período'
                              : 'Período selecionado',
                        ),
                      ),

                    Wrap(
                      spacing: 6,
                      children: List.generate(7, (i) {
                        final d = i + 1;

                        return FilterChip(
                          label: Text(daysLabels[i]),
                          selected:
                              selectedDays.contains(d),
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? selectedDays.add(d)
                                  : selectedDays.remove(d);
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: guardarMedicamento,
                      child: const Text('Adicionar'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 ADICIONADO — ListView de saída com recorrente
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meds.length,

              itemBuilder: (_, i) {
                final med = meds[i];
                return Card(
                  child: ListTile(
                    title: Text('${med.utente} • ${med.medicamento} • ${med.hora}'),
                    subtitle: Text(
                      med.permanente
                          ? 'Permanente • ${formatDays(med.diasSemana)}${med.recorrente && med.intervaloHoras != null ? ' • De ${med.intervaloHoras} em ${med.intervaloHoras} horas' : ''}'
                           : 'De ${med.dataInicio!.day.toString().padLeft(2,'0')}/${med.dataInicio!.month.toString().padLeft(2,'0')} a ${med.dataFim!.day.toString().padLeft(2,'0')}/${med.dataFim!.month.toString().padLeft(2,'0')} • ${formatDays(med.diasSemana)}${med.recorrente && med.intervaloHoras != null ? ' • De ${med.intervaloHoras} em ${med.intervaloHoras} horas' : ''}',
                    ),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editarMedicamento(med),
                        ),

                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removerMedicamento(med),
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
    );
  }
}
