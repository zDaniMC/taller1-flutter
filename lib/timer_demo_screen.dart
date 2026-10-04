import 'dart:async';
import 'package:flutter/material.dart';

/// Cronómetro (cuenta ascendente) implementado con Timer.periodic.
/// Permite Iniciar, Pausar, Reanudar y Reiniciar, y cancela el Timer
/// correctamente al pausar o al salir de la vista (dispose).
class TimerDemoScreen extends StatefulWidget {
  const TimerDemoScreen({super.key});

  @override
  State<TimerDemoScreen> createState() => _TimerDemoScreenState();
}

class _TimerDemoScreenState extends State<TimerDemoScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  void _start() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _pause() {
    _timer?.cancel(); // Libera el recurso del Timer al pausar
    setState(() => _isRunning = false);
  }

  void _reanudar() {
    _start();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // Limpieza de recursos: cancela el Timer si la vista se destruye
    // mientras el cronómetro sigue corriendo.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cronómetro (Timer)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_elapsedSeconds),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pause : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pausar'),
                ),
                ElevatedButton.icon(
                  onPressed: (!_isRunning && _elapsedSeconds > 0) ? _reanudar : null,
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Reanudar'),
                ),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
