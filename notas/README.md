# Tarea 04: Aplicación de Notas - UNISON 📝

[cite_start]Este proyecto consiste en el desarrollo de una aplicación móvil para la toma de notas, diseñada específicamente para cumplir con los requisitos de la asignatura de Programación de Sistemas III en la Universidad de Sonora[cite: 1, 3].

## 📌 Descripción del Proyecto
[cite_start]La aplicación permite a los usuarios organizar sus pensamientos y tareas de manera eficiente a través de una interfaz intuitiva y visualmente atractiva[cite: 4, 108]. Incluye un sistema de gestión de grupos (carpetas) y notas personalizables con colores y categorías iconográficas.

## 🛠️ Tecnologías Utilizadas
[cite_start]Para este desarrollo se emplearon las siguientes herramientas y versiones[cite: 95]:
* **Framework**: Flutter 3.38.7 (Canal stable).
* **Lenguaje**: Dart.
* [cite_start]**Base de Datos**: `sqflite ^2.3.0` para la persistencia de datos local en el dispositivo[cite: 88, 89].
* **Manejo de Rutas**: `path ^1.9.1`.
* **Diseño Visual**: `google_fonts ^6.2.1` para tipografía moderna y `Material Design 3`.

## ✨ Funcionalidades Principales
* [cite_start]**Vista de Inicio**: Pantalla de bienvenida con identidad institucional de la Universidad de Sonora, incluyendo el logo oficial y el nombre del desarrollador[cite: 33, 34].
* **Gestión de Grupos**: Permite crear carpetas personalizadas con colores para organizar notas por materias o temas (ej. Matemáticas, Ciencia, Tecnología).
* **Sistema de Notas**:
  - [cite_start]Creación y edición de notas con **título obligatorio** (no se aceptan cadenas vacías) [cite: 52-54, 68-71].
  - [cite_start]Contenido opcional para descripciones detalladas[cite: 55, 56, 72, 73].
  - [cite_start]Selección de colores preestablecidos que cambian el fondo de la nota y el formulario [cite: 58-61, 74-77].
  - **Categorías iconográficas**: Cada nota incluye una figura de fondo (Ciencia, Naturaleza, etc.) para identificar rápidamente el tipo de contenido.
* [cite_start]**Persistencia**: Todos los datos se guardan localmente en una base de datos SQLite, garantizando que la información se mantenga al cerrar la app[cite: 89].
* [cite_start]**Confirmación de Eliminación**: Diálogos de seguridad antes de borrar cualquier registro[cite: 42].

## 🎨 Identidad Institucional
[cite_start]Se utilizaron los colores oficiales recomendados por la Universidad de Sonora para asegurar la coherencia visual[cite: 81]:
* [cite_start]**Azul Unison**: `#00529e` [cite: 82]
* [cite_start]**Dorado Unison**: `#f8bb00` [cite: 84]

## 📸 Capturas de Pantalla
> [cite_start]*Aquí puedes insertar las imágenes de tu aplicación funcionando en tu celular, tal como pide la rúbrica.*

| Inicio | Grupos | Listado de Notas |
| :---: | :---: | :---: |
| ![Inicio](/screenshots/968b7133-5a6a-40bb-b272-3600c286791b.jpg) | ![Grupos](/screenshots/22525cfe-0f5c-46b5-bec9-ef0cf134a3f8.jpg) | ![Notas](/screenshots/218e57de-a11a-4e9a-a787-04f3c357341c.jpg) | ![VistaNotas](/screenshots/afb857b4-37f7-4479-aa7e-de0c3cc10af7.jpg)|

## 👤 Autores
* [cite_start]**Saul Filiberto Espinoza Rivera** 
* [cite_start]**Lilian Yeitnaletzi Álvarez portillo** 
* [cite_start]**María Yamile Valencia Loroña** 
* [cite_start]**Orlando Cervantes Sousa** 
* [cite_start]**Hugo Alan Hinojoza Lopez** 
* Estudiante de Ingeniería en Sistemas de Información - UNISON.

---