import 'package:flutter/material.dart';
import '../main.dart';
import '../models/medicamento.dart';
import '../services/notification_service.dart';
import '../widgets/numpad.dart';

class MedicationFormPage extends StatefulWidget {
  final bool isDarkMode;
  final Medicamento? medicamento;

  const MedicationFormPage({
    super.key,
    required this.isDarkMode,
    this.medicamento,
  });

  @override
  State<MedicationFormPage> createState() => _MedicationFormPageState();
}

class _MedicationFormPageState extends State<MedicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _utenteController = TextEditingController();
  final _medicamentoController = TextEditingController();
  final _dosagemController = TextEditingController();
  final _horaController = TextEditingController();

  Set<int> _selectedDays = {};
  bool _isPermanente = true;
  bool _isRecorrente = false;
  int _intervaloHoras = 8;
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;

  static const _daysLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  bool get _isEditing => widget.medicamento != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadMedicamentoData();
  }

  void _loadMedicamentoData() {
    final med = widget.medicamento!;
    _utenteController.text = med.utente;
    _medicamentoController.text = med.medicamento;
    _dosagemController.text = med.dosagem;
    _horaController.text = med.hora;
    _selectedDays = med.diasSemana.toSet();
    _isPermanente = med.permanente;
    _isRecorrente = med.recorrente;
    _intervaloHoras = med.intervaloHoras ?? 8;
    
    if (!med.permanente && med.dataInicio != null && med.dataFim != null) {
      _selectedDateRange = DateTimeRange(start: med.dataInicio!, end: med.dataFim!);
    }
  }

  @override
  void dispose() {
    _utenteController.dispose();
    _medicamentoController.dispose();
    _dosagemController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (range != null && mounted) setState(() => _selectedDateRange = range);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      _showErrorSnackBar('Seleciona pelo menos um dia da semana');
      return;
    }
    if (!_isPermanente && _selectedDateRange == null) {
      _showErrorSnackBar('Seleciona o período do medicamento');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final medicamento = Medicamento(
        utente: _utenteController.text.trim(),
        medicamento: _medicamentoController.text.trim(),
        dosagem: _dosagemController.text.trim(),
        hora: _horaController.text.trim(),
        permanente: _isPermanente,
        dataInicio: _isPermanente ? null : _selectedDateRange!.start,
        dataFim: _isPermanente ? null : _selectedDateRange!.end,
        diasSemana: _selectedDays.toList()..sort(),
        recorrente: _isRecorrente,
        intervaloHoras: _isRecorrente ? _intervaloHoras : null,
      );

      if (_isEditing) {
        medicamento.id = widget.medicamento!.id;
        final medAntigo = widget.medicamento!;

        if (medAntigo.recorrente && medAntigo.intervaloHoras != null) {
          final numAlarmes = 24 ~/ medAntigo.intervaloHoras!;
          for (int i = 0; i < numAlarmes; i++) {
            await NotificationService().cancelNotification(medAntigo.id * 100 + i);
          }
        } else {
          // Cancelar alarme diário (id base) e alarmes semanais por dia
          await NotificationService().cancelNotification(medAntigo.id);
          for (final day in medAntigo.diasSemana) {
            await NotificationService().cancelNotification(medAntigo.id * 10 + day);
          }
        }
      }

      await isar.writeTxn(() async {
        await isar.medicamentos.put(medicamento);
      });

      await _agendarAlarmes(medicamento);

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao guardar medicamento');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _agendarAlarmes(Medicamento med) async {
    final timeParts = med.hora.split(':');
    if (timeParts.length != 2) return;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return;

    try {
      if (med.recorrente && med.intervaloHoras != null) {
        // Várias tomas por dia — cria um alarme por toma, repete todos os dias
        final numAlarmes = 24 ~/ med.intervaloHoras!;
        for (int i = 0; i < numAlarmes; i++) {
          final tomaHour = (hour + med.intervaloHoras! * i) % 24;
          await NotificationService().scheduleRepeatingNotification(
            id: med.id * 100 + i,
            title: '💊 Hora de tomar ${med.medicamento}!',
            body: '${med.utente} • ${med.dosagem} • De ${med.intervaloHoras}h em ${med.intervaloHoras}h',
            time: TimeOfDay(hour: tomaHour, minute: minute),
            payload: med.id.toString(),
          );
        }
      } else {
        // Toma única diária
        if (med.diasSemana.length == 7) {
          // Todos os dias -> 1 único alarme diário
          await NotificationService().scheduleDailyNotification(
            id: med.id, // ID simples, sem multiplicar por dia
            title: '💊 Hora de tomar ${med.medicamento}!',
            body: '${med.utente} • ${med.dosagem} • 1x por dia',
            time: TimeOfDay(hour: hour, minute: minute),
            payload: med.id.toString(),
          );
        } else {
          // Dias específicos -> 1 alarme por dia selecionado
          for (final day in med.diasSemana) {
            await NotificationService().scheduleWeeklyNotification(
              id: med.id * 10 + day,
              title: '💊 Hora de tomar ${med.medicamento}!',
              body: '${med.utente} • ${med.dosagem} • 1x por dia',
              time: TimeOfDay(hour: hour, minute: minute),
              dayOfWeek: day,
              payload: med.id.toString(),
            );
          }
        }
      }
    } catch (e) {
      // Silencioso
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Medicamento' : 'Adicionar Medicamento'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Informações', Icons.info_outline),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _utenteController,
              decoration: const InputDecoration(
                labelText: 'Utente *',
                hintText: 'Nome da(o) utente',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _medicamentoController,
              decoration: const InputDecoration(
                labelText: 'Medicamento *',
                hintText: 'Nome do medicamento',
                prefixIcon: Icon(Icons.medication),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _dosagemController,
              decoration: const InputDecoration(
                labelText: 'Dosagem *',
                hintText: 'Ex: 500mg, 10ml, 1 comprimido',
                prefixIcon: Icon(Icons.science),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('Horário', Icons.access_time),
            const SizedBox(height: 12),
            
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => TimeNumpad(
                    initialTime: _horaController.text,
                    onTimeSelected: (time) => setState(() => _horaController.text = time),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Hora *',
                  prefixIcon: Icon(Icons.schedule),
                  suffixIcon: Icon(Icons.keyboard),
                ),
                child: Text(
                  _horaController.text.isEmpty ? 'Toca para selecionar' : _horaController.text,
                  style: TextStyle(fontSize: 16, color: _horaController.text.isEmpty ? Colors.grey : null),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Toma diaria unica'), icon: Icon(Icons.schedule)),
                ButtonSegment(value: true, label: Text('Varias tomas por dia'), icon: Icon(Icons.repeat)),
              ],
              selected: {_isRecorrente},
              onSelectionChanged: (Set<bool> selection) {
                setState(() => _isRecorrente = selection.first);
              },
            ),
            
            if (_isRecorrente) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _intervaloHoras,
                decoration: const InputDecoration(labelText: 'Intervalo', prefixIcon: Icon(Icons.timer)),
                items: const [
                  DropdownMenuItem(value: 4, child: Text('De 4 em 4 horas')),
                  DropdownMenuItem(value: 6, child: Text('De 6 em 6 horas')),
                  DropdownMenuItem(value: 8, child: Text('De 8 em 8 horas')),
                  DropdownMenuItem(value: 12, child: Text('De 12 em 12 horas')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _intervaloHoras = value);
                },
              ),
            ],
            
            const SizedBox(height: 32),
            _buildSectionHeader('Período', Icons.calendar_month),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Medicamento permanente'),
              subtitle: Text(_isPermanente ? 'Sem data de fim' : 'Período definido'),
              value: _isPermanente,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onChanged: (value) {
                setState(() {
                  _isPermanente = value;
                  if (value) _selectedDateRange = null;
                });
              },
            ),
            
            if (!_isPermanente) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDateRange,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDateRange == null
                      ? 'Selecionar período'
                      : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - '
                        '${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
                ),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16), alignment: Alignment.centerLeft),
              ),
            ],
            
            const SizedBox(height: 32),
            _buildSectionHeader('Dias da Semana', Icons.today),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _selectedDays = {1, 2, 3, 4, 5, 6, 7}),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Todos'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _selectedDays.clear()),
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(7, (i) {
                final day = i + 1;
                final isSelected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(_daysLabels[i]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                  showCheckmark: true,
                );
              }),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _guardar,
                icon: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(_isEditing ? 'Guardar Alterações' : 'Adicionar Medicamento'),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.teal),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ],
    );
  }
}