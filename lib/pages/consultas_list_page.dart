import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/consultas.dart';
import '../services/notification_service.dart';
import '../widgets/drawer.dart';
import 'consultas_form_page.dart';

class ConsultationListPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final bool showAppBar;

  const ConsultationListPage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    this.showAppBar = true,
  });

  @override
  State<ConsultationListPage> createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends State<ConsultationListPage> {
  List<Consulta> _consultas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConsultas();
  }

  Future<void> _loadConsultas() async {
    setState(() => _isLoading = true);
    try {
      final consultas = await isar.consultas.where().findAll();
      consultas.sort((a, b) => a.dataHora.compareTo(b.dataHora));
      if (mounted) {
        setState(() {
          _consultas = consultas;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Erro ao carregar consultas');
      }
    }
  }

  Future<void> _removerConsulta(Consulta consulta) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminação'),
        content: Text('Tens a certeza que queres remover a consulta com ${consulta.medico}?'),
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
      await NotificationService().cancelNotification(10000 + consulta.id);
      await NotificationService().cancelNotification(20000 + consulta.id);

      await isar.writeTxn(() async {
        await isar.consultas.delete(consulta.id);
      });

      await _loadConsultas();

      if (mounted) {
        _showSuccessSnackBar('Consulta removida com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao remover consulta');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _limparConsultasAntigas() async {
    final limite = DateTime.now().subtract(const Duration(days: 0));
    final antigas = _consultas.where((c) => c.dataHora.isBefore(limite)).toList();

    if (antigas.isEmpty) {
      _showErrorSnackBar('Não há consultas com mais de 15 dias para apagar.');
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🗑️ Limpar consultas antigas'),
        content: Text(
          'Isto vai apagar ${antigas.length} consulta(s) com mais de 15 dias.\n\nTens a certeza?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    setState(() => _isLoading = true);

    try {
      for (final consulta in antigas) {
        await NotificationService().cancelNotification(10000 + consulta.id);
        await NotificationService().cancelNotification(20000 + consulta.id);
        await isar.writeTxn(() async {
          await isar.consultas.delete(consulta.id);
        });
      }

      await _loadConsultas();

      if (mounted) {
        _showSuccessSnackBar('${antigas.length} consulta(s) apagada(s) com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao apagar consultas antigas');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatData(DateTime data) { // DD/MM/YYYY
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatHora(DateTime data) { // HH:MM
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  bool _isProxima(DateTime data) {
    final agora = DateTime.now();
    final diferenca = data.difference(agora);
    return diferenca.inDays >= 0 && diferenca.inDays <= 7;
  }

  bool _isPassada(DateTime data) {
    return data.isBefore(DateTime.now());
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
              title: const Text('📅 Consultas'),
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
              builder: (context) => ConsultationFormPage(
                isDarkMode: widget.isDarkMode,
              ),
            ),
          );
          if (resultado == true) _loadConsultas();
        },
        icon: const Icon(Icons.add),
        label: const Text('Agendar'),
        tooltip: 'Agendar consulta',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadConsultas,
              child: _buildBody(),
            ),
    );
  }

  Widget _buildBody() {
    if (_consultas.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 60),
          Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 24),
          Text(
            'Nenhuma consulta',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Agenda a tua primeira consulta\nclicando no botão abaixo',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      );
    }

    final proximasConsultas = _consultas.where((c) => !_isPassada(c.dataHora)).toList();
    final consultasPassadas = _consultas.where((c) => _isPassada(c.dataHora)).toList();
    final limite = DateTime.now().subtract(const Duration(days: 0));
    final temAntigas = consultasPassadas.any((c) => c.dataHora.isBefore(limite));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (proximasConsultas.isNotEmpty) ...[
          _buildSectionHeader('Próximas Consultas', Icons.upcoming),
          const SizedBox(height: 12),
          ...proximasConsultas.map((consulta) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildConsultaCard(consulta),
              )),
          const SizedBox(height: 24),
        ],

        if (consultasPassadas.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Consultas Passadas', Icons.history),
              if (temAntigas)
                TextButton.icon(
                  onPressed: _limparConsultasAntigas,
                  icon: const Icon(Icons.delete_sweep, size: 18, color: Colors.red),
                  label: const Text(
                    'Limpar +15 dias',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...consultasPassadas.map((consulta) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildConsultaCard(consulta, isPassada: true),
              )),
        ],
      ],
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

  Widget _buildConsultaCard(Consulta consulta, {bool isPassada = false}) {
    final isProxima = _isProxima(consulta.dataHora);

    return Card(
      elevation: isProxima ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isProxima
            ? BorderSide(color: Colors.orange.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isPassada
            ? null
            : () async {
                final resultado = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultationFormPage(
                      isDarkMode: widget.isDarkMode,
                      consulta: consulta,
                    ),
                  ),
                );
                if (resultado == true) _loadConsultas();
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
                      color: isPassada
                          ? Colors.grey.shade200
                          : isProxima
                              ? Colors.orange.shade100
                              : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: isPassada
                          ? Colors.grey.shade600
                          : isProxima
                              ? Colors.orange.shade700
                              : Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Utente como título principal
                        Text(
                          consulta.utente,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPassada ? Colors.grey.shade600 : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        // Médico como subtítulo
                        Text(
                          consulta.medico,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        // Especialidade na linha extra
                        Text(
                          consulta.especialidade,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (!isPassada)
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
                          _removerConsulta(consulta);
                        } else if (value == 'edit') {
                          final resultado = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsultationFormPage(
                                isDarkMode: widget.isDarkMode,
                                consulta: consulta,
                              ),
                            ),
                          );
                          if (resultado == true) _loadConsultas();
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
                  _buildInfoChip(Icons.calendar_today, _formatData(consulta.dataHora), isPassada: isPassada),
                  _buildInfoChip(Icons.access_time, _formatHora(consulta.dataHora), isPassada: isPassada),
                  _buildInfoChip(Icons.location_on, consulta.local, isPassada: isPassada),
                  if (consulta.notificar1DiaAntes)
                    _buildInfoChip(Icons.notifications_active, '1 dia antes', isPassada: isPassada),
                  if (consulta.notificar1HoraAntes)
                    _buildInfoChip(Icons.notifications, '1 hora antes', isPassada: isPassada),
                  if (consulta.observacoes != null && consulta.observacoes!.isNotEmpty)
                    _buildInfoChip(Icons.note, 'Com observações', isPassada: isPassada),
                ],
              ),

              if (isProxima && !isPassada) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notification_important, size: 16, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Consulta esta semana!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {bool isPassada = false}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: isPassada ? Colors.grey.shade600 : null),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
      backgroundColor: isPassada ? Colors.grey.shade100 : null,
    );
  }
}
