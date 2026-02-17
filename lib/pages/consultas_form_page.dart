import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/consultas.dart';
import '../services/notification_service.dart';
import '../widgets/numpad.dart'; 

class ConsultationFormPage extends StatefulWidget {
  final bool isDarkMode;
  final Consulta? consulta;

  const ConsultationFormPage({
    super.key,
    required this.isDarkMode,
    this.consulta,
  });

  @override
  State<ConsultationFormPage> createState() => _ConsultationFormPageState();
}

class _ConsultationFormPageState extends State<ConsultationFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _utenteController = TextEditingController();
  final _medicoController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _localController = TextEditingController();
  final _observacoesController = TextEditingController();

  // State
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _notificar1DiaAntes = true;
  bool _notificar1HoraAntes = true;
  bool _isLoading = false;

  bool get _isEditing => widget.consulta != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadConsultaData();
    }
  }

  void _loadConsultaData() {
    final consulta = widget.consulta!;
    _utenteController.text = consulta.utente;
    _medicoController.text = consulta.medico;
    _especialidadeController.text = consulta.especialidade;
    _localController.text = consulta.local;
    _observacoesController.text = consulta.observacoes ?? '';
    _notificar1DiaAntes = consulta.notificar1DiaAntes;
    _notificar1HoraAntes = consulta.notificar1HoraAntes;
    
    _selectedDate = DateTime(
      consulta.dataHora.year,
      consulta.dataHora.month,
      consulta.dataHora.day,
    );
    _selectedTime = TimeOfDay(
      hour: consulta.dataHora.hour,
      minute: consulta.dataHora.minute,
    );
  }

  @override
  void dispose() {
    _utenteController.dispose();
    _medicoController.dispose();
    _especialidadeController.dispose();
    _localController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDate == null) {
      _showErrorSnackBar('Seleciona a data da consulta');
      return;
    }
    
    if (_selectedTime == null) {
      _showErrorSnackBar('Seleciona a hora da consulta');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataCompleta = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final consulta = Consulta(
        utente: _utenteController.text.trim(),
        medico: _medicoController.text.trim(),
        especialidade: _especialidadeController.text.trim(),
        local: _localController.text.trim(),
        observacoes: _observacoesController.text.trim().isEmpty 
            ? null 
            : _observacoesController.text.trim(),
        dataHora: dataCompleta,
        notificar1DiaAntes: _notificar1DiaAntes,
        notificar1HoraAntes: _notificar1HoraAntes,
      );

      if (_isEditing) {
        consulta.id = widget.consulta!.id;
        
        // Cancelar alarmes antigos
        await NotificationService().cancelNotification(10000 + widget.consulta!.id);
        await NotificationService().cancelNotification(20000 + widget.consulta!.id);
      }

      // Guardar
      await isar.writeTxn(() async {
        await isar.consultas.put(consulta);
      });

      // Agendar alarmes
      await _agendarAlarmes(consulta);
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao guardar consulta');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _agendarAlarmes(Consulta consulta) async {
    try {
      // Alarme 1 dia antes
      if (consulta.notificar1DiaAntes) {
        final alarm1Day = consulta.dataHora.subtract(const Duration(days: 1));
        
        if (alarm1Day.isAfter(DateTime.now())) {
          await NotificationService().scheduleNotification(
            id: 10000 + consulta.id,
            title: '📅 Lembrete de Consulta',
            body: '${consulta.medico} - ${consulta.especialidade} amanhã às ${_formatHora(consulta.dataHora)}',
            scheduledTime: alarm1Day,
            payload: consulta.id.toString(),
          );
        }
      }

      // Alarme 1 hora antes
      if (consulta.notificar1HoraAntes) {
        final alarm1Hour = consulta.dataHora.subtract(const Duration(hours: 1));
        
        if (alarm1Hour.isAfter(DateTime.now())) {
          await NotificationService().scheduleNotification(
            id: 20000 + consulta.id,
            title: '⏰ Consulta em 1 hora!',
            body: '${consulta.medico} - ${consulta.especialidade} às ${_formatHora(consulta.dataHora)}',
            scheduledTime: alarm1Hour,
            payload: consulta.id.toString(),
          );
        }
      }
    } catch (e) {
      // Silencioso
    }
  }

  String _formatData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
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
        title: Text(_isEditing ? 'Editar Consulta' : 'Agendar Consulta'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seção: Informações da Consulta
            _buildSectionHeader('Informações da Consulta', Icons.medical_services),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _utenteController,
              decoration: const InputDecoration(
                labelText: 'Utente *',
                hintText: 'Nome do utente',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _medicoController,
              decoration: const InputDecoration(
                labelText: 'Médico *',
                hintText: 'Nome do médico',
                prefixIcon: Icon(Icons.medical_information),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _especialidadeController,
              decoration: const InputDecoration(
                labelText: 'Especialidade *',
                hintText: 'Ex: Cardiologia, Oftalmologia',
                prefixIcon: Icon(Icons.local_hospital),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _localController,
              decoration: const InputDecoration(
                labelText: 'Local *',
                hintText: 'Hospital, clínica, centro de saúde',
                prefixIcon: Icon(Icons.location_on),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            // Seção: Data e Hora
            _buildSectionHeader('Data e Hora', Icons.calendar_today),
            const SizedBox(height: 12),
            
            // 🔹 CAMPO DATA (permanece igual)
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data *',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  _selectedDate == null 
                      ? 'Toca para selecionar' 
                      : _formatData(_selectedDate!),
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 🔹 CAMPO HORA (NUMPAD)
            InkWell(
              onTap: () async {
                // Converter TimeOfDay para String formato HH:MM
                String initialTime = '';
                if (_selectedTime != null) {
                  initialTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
                }
                
                // Abrir numpad
                showDialog(
                  context: context,
                  builder: (context) => TimeNumpad(
                    initialTime: initialTime,
                    onTimeSelected: (time) {
                      // Converter String HH:MM para TimeOfDay
                      final parts = time.split(':');
                      if (parts.length == 2) {
                        final hour = int.tryParse(parts[0]);
                        final minute = int.tryParse(parts[1]);
                        if (hour != null && minute != null) {
                          setState(() {
                            _selectedTime = TimeOfDay(hour: hour, minute: minute);
                          });
                        }
                      }
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Hora *',
                  prefixIcon: Icon(Icons.access_time),
                  suffixIcon: Icon(Icons.keyboard),  // 🔹 Ícone teclado
                ),
                child: Text(
                  _selectedTime == null 
                      ? 'Toca para selecionar' 
                      : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedTime == null ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Seção: Lembretes
            _buildSectionHeader('Lembretes', Icons.notifications_active),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Lembrete 1 dia antes'),
              subtitle: const Text('Receberás uma notificação na véspera'),
              value: _notificar1DiaAntes,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onChanged: (value) {
                setState(() => _notificar1DiaAntes = value);
              },
            ),
            
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Lembrete 1 hora antes'),
              subtitle: const Text('Receberás uma notificação 1h antes'),
              value: _notificar1HoraAntes,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onChanged: (value) {
                setState(() => _notificar1HoraAntes = value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Seção: Observações
            _buildSectionHeader('Observações', Icons.note),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                hintText: 'Notas, preparações necessárias, etc.',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 24),
            
            // Botão Guardar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _guardar,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(_isEditing ? 'Guardar Alterações' : 'Agendar Consulta'),
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
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
        ),
      ],
    );
  }
}