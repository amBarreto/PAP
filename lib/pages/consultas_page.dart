import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/consultas.dart';
import '../services/notification_service.dart';
import '../widgets/numpad.dart';  // 🔹 ADICIONADO

class ConsultasPage extends StatefulWidget {
  final bool showAppBar;

  const ConsultasPage({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<ConsultasPage> createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  List<Consulta> consultas = [];

  @override
  void initState() {
    super.initState();
    loadConsultas();
  }

  Future<void> loadConsultas() async {
    final all = await isar.consultas.where().findAll();
    
    // Ordena por data (mais próximas primeiro)
    all.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    
    setState(() => consultas = all);
  }

  Future<void> adicionarConsulta() async {
    await showDialog(
      context: context,
      builder: (context) => const ConsultaDialog(),
    );
    await loadConsultas();
  }

  Future<void> editarConsulta(Consulta consulta) async {
    await showDialog(
      context: context,
      builder: (context) => ConsultaDialog(consulta: consulta),
    );
    await loadConsultas();
  }

  Future<void> removerConsulta(Consulta consulta) async {
    // Cancelar notificações
    await NotificationService().cancelNotification(consulta.id * 1000);
    await NotificationService().cancelNotification(consulta.id * 1000 + 1);

    await isar.writeTxn(() async {
      await isar.consultas.delete(consulta.id);
    });

    await loadConsultas();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Consulta removida'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('📅 Consultas Agendadas'),
              centerTitle: true,
            )
          : null,
      body: consultas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Nenhuma consulta agendada',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: consultas.length,
              itemBuilder: (_, i) {
                final consulta = consultas[i];
                final isPast = consulta.dataHora.isBefore(DateTime.now());

                return Card(
                  color: isPast ? Colors.grey.shade200 : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPast ? Colors.grey : Colors.teal,
                      child: Icon(
                        isPast ? Icons.check : Icons.event,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '${consulta.utente} • ${consulta.especialidade}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isPast ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('👨‍⚕️ Dr(a). ${consulta.medico}'),
                        Text('📍 ${consulta.local}'),
                        Text(
                          '📅 ${consulta.dataHora.day.toString().padLeft(2, '0')}/${consulta.dataHora.month.toString().padLeft(2, '0')}/${consulta.dataHora.year} às ${consulta.dataHora.hour.toString().padLeft(2, '0')}:${consulta.dataHora.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (consulta.observacoes != null &&
                            consulta.observacoes!.isNotEmpty)
                          Text('📝 ${consulta.observacoes}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editarConsulta(consulta),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removerConsulta(consulta),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarConsulta,
        icon: const Icon(Icons.add),
        label: const Text('Nova Consulta'),
      ),
    );
  }
}

// Dialog para adicionar/editar consulta
class ConsultaDialog extends StatefulWidget {
  final Consulta? consulta;

  const ConsultaDialog({super.key, this.consulta});

  @override
  State<ConsultaDialog> createState() => _ConsultaDialogState();
}

class _ConsultaDialogState extends State<ConsultaDialog> {
  final utenteController = TextEditingController();
  final medicoController = TextEditingController();
  final especialidadeController = TextEditingController();
  final localController = TextEditingController();
  final observacoesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool notificar1Dia = true;
  bool notificar1Hora = true;

  @override
  void initState() {
    super.initState();
    if (widget.consulta != null) {
      utenteController.text = widget.consulta!.utente;
      medicoController.text = widget.consulta!.medico;
      especialidadeController.text = widget.consulta!.especialidade;
      localController.text = widget.consulta!.local;
      observacoesController.text = widget.consulta!.observacoes ?? '';
      selectedDate = widget.consulta!.dataHora;
      selectedTime = TimeOfDay.fromDateTime(widget.consulta!.dataHora);
      notificar1Dia = widget.consulta!.notificar1DiaAntes;
      notificar1Hora = widget.consulta!.notificar1HoraAntes;
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // 🔹 MODIFICADO - Agora usa o numpad
  Future<void> pickTime() async {
    // Converte TimeOfDay para string HH:MM se já existir
    String? initialTime;
    if (selectedTime != null) {
      initialTime = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
    }

    await showDialog(
      context: context,
      builder: (context) => TimeNumpad(
        initialTime: initialTime,
        onTimeSelected: (time) {
          // Converte string "HH:MM" para TimeOfDay
          final parts = time.split(':');
          setState(() {
            selectedTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          });
        },
      ),
    );
  }

  Future<void> guardar() async {
    if (utenteController.text.isEmpty ||
        medicoController.text.isEmpty ||
        especialidadeController.text.isEmpty ||
        localController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dataHora = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final consulta = Consulta(
      utente: utenteController.text.trim(),
      medico: medicoController.text.trim(),
      especialidade: especialidadeController.text.trim(),
      local: localController.text.trim(),
      observacoes: observacoesController.text.trim().isEmpty
          ? null
          : observacoesController.text.trim(),
      dataHora: dataHora,
      notificar1DiaAntes: notificar1Dia,
      notificar1HoraAntes: notificar1Hora,
    );

    if (widget.consulta != null) {
      consulta.id = widget.consulta!.id;
    }

    await isar.writeTxn(() async {
      await isar.consultas.put(consulta);
    });

    // Agendar notificações
    await _agendarNotificacoes(consulta);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Consulta guardada!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _agendarNotificacoes(Consulta consulta) async {
    // Cancelar notificações antigas
    await NotificationService().cancelNotification(consulta.id * 1000);
    await NotificationService().cancelNotification(consulta.id * 1000 + 1);

    // 1 dia antes
    if (consulta.notificar1DiaAntes) {
      final umDiaAntes = consulta.dataHora.subtract(const Duration(days: 1));
      if (umDiaAntes.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          id: consulta.id * 1000,
          title: '📅 Lembrete: Consulta amanhã!',
          body:
              '${consulta.utente} • ${consulta.especialidade} • Dr(a). ${consulta.medico}',
          scheduledTime: umDiaAntes,
        );
      }
    }

    // 1 hora antes
    if (consulta.notificar1HoraAntes) {
      final umaHoraAntes = consulta.dataHora.subtract(const Duration(hours: 1));
      if (umaHoraAntes.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          id: consulta.id * 1000 + 1,
          title: '📅 Consulta em 1 hora!',
          body:
              '${consulta.utente} • ${consulta.especialidade} • ${consulta.local}',
          scheduledTime: umaHoraAntes,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.consulta == null ? 'Nova Consulta' : 'Editar Consulta'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: utenteController,
              decoration: const InputDecoration(labelText: 'Utente'),
            ),
            TextField(
              controller: especialidadeController,
              decoration: const InputDecoration(labelText: 'Especialidade'),
            ),
            TextField(
              controller: medicoController,
              decoration: const InputDecoration(labelText: 'Médico'),
            ),
            TextField(
              controller: localController,
              decoration: const InputDecoration(labelText: 'Local (hospital/clínica)'),
            ),
            TextField(
              controller: observacoesController,
              decoration: const InputDecoration(labelText: 'Observações (opcional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate == null
                    ? 'Selecionar data'
                    : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
              ),
              onTap: pickDate,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                selectedTime == null
                    ? 'Selecionar hora'
                    : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.keyboard),
              onTap: pickTime,
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Notificar 1 dia antes'),
              value: notificar1Dia,
              onChanged: (v) => setState(() => notificar1Dia = v ?? true),
            ),
            CheckboxListTile(
              title: const Text('Notificar 1 hora antes'),
              value: notificar1Hora,
              onChanged: (v) => setState(() => notificar1Hora = v ?? true),
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
          onPressed: guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}