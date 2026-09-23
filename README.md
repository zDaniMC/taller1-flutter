# Taller 1 - Flutter: StatefulWidget y setState()

## Datos del estudiante
- **Nombre completo:** Jose Daniel Rivas
- **Código:** 230232009
- **Asignatura:** Electiva Profesional
- **Taller:** taller1
- **Repositorio:** https://github.com/zDaniMC/taller1-flutter

## Descripción del taller
Este taller construye una pantalla básica en Flutter (`HomePage`) usando un
`StatefulWidget`. La pantalla incluye:

- Un `AppBar` cuyo título cambia dinámicamente con `setState()`.
- Un `Text` centrado con el nombre del estudiante.
- Un `Row` con una imagen desde `Image.network()` y otra desde `Image.asset()`.
- Un `ElevatedButton` que alterna el título entre "Hola, Flutter" y
  "¡Título cambiado!", mostrando además un `SnackBar` con el mensaje
  "Título actualizado".
- Dos widgets adicionales: un `Stack` (texto superpuesto sobre una imagen) y
  un `ListView` (lista de verificación del taller).

## Estructura de ramas
Este proyecto sigue el flujo de trabajo:

```
main (producción)
  └── dev (desarrollo)
        └── feature/taller1
```

Todos los cambios de este taller se desarrollaron en `feature/taller1`,
luego se integraron a `dev` mediante Pull Request, y finalmente `dev` se
integró a `main`.

## Cómo ejecutar el proyecto

1. Clona el repositorio:
   ```bash
   git clone https://github.com/zDaniMC/taller1-flutter.git
   cd taller1-flutter
   git checkout feature/taller1
   ```
2. Coloca una imagen en `assets/images/local.png` (ya está declarada en
   `pubspec.yaml`).
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la app en un emulador o dispositivo físico:
   ```bash
   flutter run
   ```

## Capturas de pantalla


## Explicación de StatefulWidget y setState()
`HomePage` extiende `StatefulWidget` porque necesita mantener y modificar
estado a lo largo del tiempo (el texto del título). La clase `_HomePageState`
guarda la variable `_titulo`. Al presionar el botón, se llama a
`setState()`, lo que le indica a Flutter que el estado cambió y que debe
reconstruir (`build()`) la interfaz para reflejar el nuevo valor de
`_titulo`, además de disparar el `SnackBar` como confirmación visual del
cambio.
