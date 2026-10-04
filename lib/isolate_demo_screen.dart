import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

/// Función CPU-bound: suma los cuadrados de 1 a [limit].
/// Se ejecuta en un Isolate separado para no congelar la UI mientras corre.
/// Debe ser una función de nivel superior (o estática) porque Isolate.spawn
/// no puede capturar closures con referencias a instancias de widgets.
void _heavySumIsolate(SendPort sendPort) {
  const int limit = 500000000; // 500 millones: lo suficientemente pesado
  int result = 0;
  for (int i = 1; i <= limit; i++) {
    result += i % 97; // operación simple repetida muchas veces
  }
  sendPort.send(result);
}

class IsolateDemoScreen extends StatefulWidget {
  const IsolateDemoScreen({super.key});

  @override
  State<IsolateDemoScreen> createState() => _IsolateDemoScreenState();
}

class _IsolateDemoScreenState extends State<IsolateDemoScreen> {
  bool _isComputing = false;
  int? _result;
  Duration? _elapsed;
  int _uiTickCounter = 0;
  Timer? _uiProofTimer;

  @override
  void dispose() {
    _uiProofTimer?.cancel();
    super.dispose();
  }

  Future<void> _runHeavyTask() async {
    setState(() {
      _isComputing = true;
      _result = null;
      _elapsed = null;
      _uiTickCounter = 0;
    });

    // Este Timer demuestra visualmente que la UI sigue respondiendo
    // (el contador sigue subiendo) mientras el cálculo pesado corre
    // en el Isolate, en paralelo.
    _uiProofTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() => _uiTickCounter++);
    });

    final stopwatch = Stopwatch()..start();
    print('[Isolate] Lanzando tarea pesada en segundo plano...');

    final receivePort = ReceivePort();
    await Isolate.spawn(_heavySumIsolate, receivePort.sendPort);

    // Espera el único mensaje que el Isolate envía con el resultado.
    final int result = await receivePort.first as int;

    stopwatch.stop();
    print('[Isolate] Resultado recibido: $result en ${stopwatch.elapsedMilliseconds} ms');

    _uiProofTimer?.cancel();
    setState(() {
      _isComputing = false;
      _result = result;
      _elapsed = stopwatch.elapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate (tarea pesada)')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Suma CPU-intensiva ejecutada en un Isolate separado.\n'
              'El contador de abajo demuestra que la UI sigue respondiendo '
              'mientras el cálculo corre en paralelo.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_isComputing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text('UI sigue viva: tick #$_uiTickCounter',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
            if (!_isComputing && _result != null) ...[
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              Text('Resultado: $_result',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Tiempo de cómputo: ${_elapsed!.inMilliseconds} ms'),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isComputing ? null : _runHeavyTask,
              icon: const Icon(Icons.memory),
              label: const Text('Ejecutar tarea pesada'),
            ),
          ],
        ),
      ),
    );
  }
}
