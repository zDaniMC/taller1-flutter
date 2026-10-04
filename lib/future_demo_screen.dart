import 'dart:math';
import 'package:flutter/material.dart';

/// Estados posibles de la consulta simulada.
enum FetchState { idle, loading, success, error }

/// Simula un servicio que "consulta" datos remotos.
/// Usa Future.delayed para simular latencia de red (2-3 segundos).
/// Aproximadamente 1 de cada 4 llamadas simula un error, para poder
/// evidenciar también el estado de error en la UI.
class FakeDataService {
  Future<String> fetchData() async {
    print('[FakeDataService] Iniciando consulta...'); // ANTES
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    print('[FakeDataService] Consulta en progreso (ya pasaron ~2.5s)'); // DURANTE (conceptual)

    final bool simulateError = Random().nextInt(4) == 0; // 25% de probabilidad
    if (simulateError) {
      print('[FakeDataService] Ocurrió un error simulado'); // DESPUÉS (error)
      throw Exception('No se pudo obtener la información del servidor.');
    }

    print('[FakeDataService] Consulta completada con éxito'); // DESPUÉS (éxito)
    return 'Datos recibidos correctamente a las ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
  }
}

class FutureDemoScreen extends StatefulWidget {
  const FutureDemoScreen({super.key});

  @override
  State<FutureDemoScreen> createState() => _FutureDemoScreenState();
}

class _FutureDemoScreenState extends State<FutureDemoScreen> {
  final FakeDataService _service = FakeDataService();

  FetchState _state = FetchState.idle;
  String _resultMessage = '';

  Future<void> _loadData() async {
    print('--- INICIO DE FLUJO ASÍNCRONO ---');
    setState(() {
      _state = FetchState.loading;
    });

    try {
      // await espera el resultado del Future SIN bloquear la UI:
      // el usuario puede seguir interactuando con el resto de la app
      // mientras este Future se resuelve.
      final String data = await _service.fetchData();
      setState(() {
        _state = FetchState.success;
        _resultMessage = data;
      });
    } catch (e) {
      setState(() {
        _state = FetchState.error;
        _resultMessage = e.toString();
      });
    }
    print('--- FIN DE FLUJO ASÍNCRONO ---');
  }

  Widget _buildStateWidget() {
    switch (_state) {
      case FetchState.idle:
        return const Text(
          'Presiona el botón para consultar datos',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        );
      case FetchState.loading:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Cargando...', style: TextStyle(fontSize: 18)),
          ],
        );
      case FetchState.success:
        return Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 8),
            const Text('Éxito',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            Text(_resultMessage, textAlign: TextAlign.center),
          ],
        );
      case FetchState.error:
        return Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            const Text('Error',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            Text(_resultMessage, textAlign: TextAlign.center),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future / async-await')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120, child: Center(child: _buildStateWidget())),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _state == FetchState.loading ? null : _loadData,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Consultar datos'),
            ),
          ],
        ),
      ),
    );
  }
}
