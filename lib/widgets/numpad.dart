import 'package:flutter/material.dart';

class TimeNumpad extends StatefulWidget {
  final Function(String) onTimeSelected;
  final String? initialTime;

  const TimeNumpad({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
  });

  @override
  State<TimeNumpad> createState() => _TimeNumpadState();
}

class _TimeNumpadState extends State<TimeNumpad> {
  String displayTime = '';
  
  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
      displayTime = widget.initialTime!.replaceAll(':', '');
    }
  }

  void _onNumberPressed(String number) {
    if (displayTime.length < 4) {
      setState(() {
        displayTime += number;
      });
    }
  }

  void _onBackspace() {
    if (displayTime.isNotEmpty) {
      setState(() {
        displayTime = displayTime.substring(0, displayTime.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      displayTime = '';
    });
  }

  void _onConfirm() {
    if (displayTime.length == 4) {
      final hours = displayTime.substring(0, 2);
      final minutes = displayTime.substring(2, 4);
      
      final hoursInt = int.tryParse(hours);
      final minutesInt = int.tryParse(minutes);
      
      if (hoursInt != null && minutesInt != null &&
          hoursInt >= 0 && hoursInt <= 23 &&
          minutesInt >= 0 && minutesInt <= 59) {
        widget.onTimeSelected('$hours:$minutes');
        Navigator.of(context).pop();
      } else {
        _showError('Hora inválida! Use formato 00:00 - 23:59');
      }
    } else {
      _showError('Digite 4 dígitos (ex: 0830 para 08:30)');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get formattedTime {
    if (displayTime.isEmpty) return '__:__';
    
    String result = displayTime.padRight(4, '_');
    return '${result.substring(0, 2)}:${result.substring(2, 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            const Text(
              '⏰ Selecionar Hora',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Display da hora
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: isDark ? Colors.teal.shade900 : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 8,
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            const Text(
              'Digite 4 dígitos (HHMM)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Numpad
            Column(
              children: [
                _buildNumpadRow(['1', '2', '3']),
                const SizedBox(height: 10),
                _buildNumpadRow(['4', '5', '6']),
                const SizedBox(height: 10),
                _buildNumpadRow(['7', '8', '9']),
                const SizedBox(height: 10),
                _buildNumpadRow(['⌫', '0', '✓']),
              ],
            ),
            
            const SizedBox(height: 15),
            
            // Botão limpar
            TextButton(
              onPressed: _onClear,
              child: const Text('Limpar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumpadButton(number)).toList(),
    );
  }

  Widget _buildNumpadButton(String value) {
    final isBackspace = value == '⌫';
    final isConfirm = value == '✓';
    
    Color buttonColor = Colors.teal.shade100;
    if (isBackspace) buttonColor = Colors.orange.shade100;
    if (isConfirm) buttonColor = Colors.green.shade100;
    
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        onPressed: () {
          if (isBackspace) {
            _onBackspace();
          } else if (isConfirm) {
            _onConfirm();
          } else {
            _onNumberPressed(value);
          }
        },
        child: Text(
          value,
          style: TextStyle(
            fontSize: isBackspace || isConfirm ? 28 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}