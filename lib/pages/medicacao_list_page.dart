import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/medicamento.dart';
import '../services/notification_service.dart';
import '../widgets/drawer.dart';
import 'medicacao_form_page.dart';

class MedicationListPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final bool showAppBar;

  const MedicationListPage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    this.showAppBar = true,
  });

  @override
  State<MedicationListPage> createState() => _MedicationListPageState();
}

class _MedicationListPageState extends State<MedicationListPage> {
  List<Medicamento> _medicamentos = [];
  bool _isLoading = false;

  static const _daysLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    _loadMedicamentos();
  }

  Future<void> _loadMedicamentos() async {
    setState(() => _isLoading = true);
    try {
      final medicamentos = await isar.medicamentos.where().findAll();
      if (mounted) {
        setState(() {
          _medicamentos = medicamentos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Erro ao carregar medicamentos');
      }
    }
  }

  Future<void> _removerMedicamento(Medicamento med) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminação'),
        content: Text('Tens a certeza que queres remover ${med.medicamento}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    setState(() => _isLoading = true);

    try {
      // Cancelar alarmes
      if (med.recorrente && med.intervaloHoras != null) {
        final numAlarmes = 24 ~/ med.intervaloHoras!;
        for (int i = 0; i < numAlarmes; i++) {
          await NotificationService().cancelNotification(med.id * 100 + i);
        }
      } else {
        for (final day in med.diasSemana) {
          await NotificationService().cancelNotification(med.id * 10 + day);
        }
      }

      await isar.writeTxn(() async {
        await isar.medicamentos.delete(med.id);
      });
      
      await _loadMedicamentos();
      
      if (mounted) {
        _showSuccessSnackBar('Medicamento removido com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao remover medicamento');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDays(List<int> days) {
    if (days.length == 7) return 'Todos os dias';
    final sorted = [...days]..sort();
    return sorted.map((d) => _daysLabels[d - 1]).join(', ');
  }

  String _formatPeriodo(Medicamento med) {
    if (med.permanente) return 'Permanente';
    
    final inicio = med.dataInicio!;
    final fim = med.dataFim!;
    
    return 'De ${inicio.day.toString().padLeft(2, '0')}/${inicio.month.toString().padLeft(2, '0')} '
           'a ${fim.day.toString().padLeft(2, '0')}/${fim.month.toString().padLeft(2, '0')}';
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('💊 Medicamentos'),
              centerTitle: true,
              elevation: 0,
            )
          : null,
      drawer: widget.showAppBar
          ? AppDrawer(
              isDarkMode: widget.isDarkMode,
              toggleTheme: widget.toggleTheme,
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationFormPage(
                isDarkMode: widget.isDarkMode,
              ),
            ),
          );
          
          if (resultado == true) {
            _loadMedicamentos();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        tooltip: 'Adicionar medicamento',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMedicamentos,
              child: _buildBody(),
            ),
    );
  }

  Widget _buildBody() {
    if (_medicamentos.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.medication_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhum medicamento',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Adiciona o teu primeiro medicamento\nclicando no botão abaixo',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _medicamentos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final med = _medicamentos[index];
        return _buildMedicamentoCard(med);
      },
    );
  }

  Widget _buildMedicamentoCard(Medicamento med) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => MedicationFormPage(
                isDarkMode: widget.isDarkMode,
                medicamento: med,
              ),
            ),
          );
          
          if (resultado == true) {
            _loadMedicamentos();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medication,
                      color: Colors.teal.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.medicamento,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${med.utente} • ${med.dosagem}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Text('Remover', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'delete') {
                        _removerMedicamento(med);
                      } else if (value == 'edit') {
                        final resultado = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicationFormPage(
                              isDarkMode: widget.isDarkMode,
                              medicamento: med,
                            ),
                          ),
                        );
                        
                        if (resultado == true) {
                          _loadMedicamentos();
                        }
                      }
                    },
                  ),
                ],
              ),
              
              const Divider(height: 24),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.access_time, med.hora),
                  _buildInfoChip(Icons.calendar_today, _formatDays(med.diasSemana)),
                  _buildInfoChip(
                    med.permanente ? Icons.all_inclusive : Icons.date_range,
                    _formatPeriodo(med),
                  ),
                  if (med.recorrente && med.intervaloHoras != null)
                    _buildInfoChip(
                      Icons.repeat,
                      'De ${med.intervaloHoras}h em ${med.intervaloHoras}h',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}