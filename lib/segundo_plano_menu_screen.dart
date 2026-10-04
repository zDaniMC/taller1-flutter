import 'package:flutter/material.dart';
import 'future_demo_screen.dart';
import 'timer_demo_screen.dart';
import 'isolate_demo_screen.dart';

/// Pantalla de menú del Taller: Procesos en segundo plano.
/// Da acceso a las tres demos: Future/async-await, Timer e Isolate.
class SegundoPlanoMenuScreen extends StatelessWidget {
  const SegundoPlanoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taller: Segundo Plano')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_download, color: Colors.indigo),
              title: const Text('Future / async / await'),
              subtitle: const Text('Consulta simulada con estados Cargando/Éxito/Error'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FutureDemoScreen()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer, color: Colors.indigo),
              title: const Text('Timer: Cronómetro'),
              subtitle: const Text('Iniciar / Pausar / Reanudar / Reiniciar'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimerDemoScreen()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.memory, color: Colors.indigo),
              title: const Text('Isolate: Tarea pesada'),
              subtitle: const Text('Cálculo CPU-intensivo sin bloquear la UI'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IsolateDemoScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
