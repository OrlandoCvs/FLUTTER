import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/note.dart';
import 'models/folder.dart';
import 'helpers/database_helper.dart';

void main() => runApp(const NotasApp());

class NotasApp extends StatelessWidget {
  const NotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00529E),
          primary: const Color(0xFF00529E),
          secondary: const Color(0xFFF8BB00),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: const VistaInicio(),
    );
  }
}

// --- VISTA INICIO ---
class VistaInicio extends StatelessWidget {
  const VistaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00529E), Color(0xFF015294)], // [cite: 82-83]
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_shared, size: 120, color: Color(0xFFF8BB00)), // [cite: 84]
            const SizedBox(height: 20),
            Text("UNISON NOTES", 
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Desarrollado por: Saul Espinoza", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8BB00), 
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const VistaCarpetas())),
              child: const Text("INGRESAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- VISTA DE CARPETAS MEJORADA ---
class VistaCarpetas extends StatefulWidget {
  const VistaCarpetas({super.key});

  @override
  State<VistaCarpetas> createState() => _VistaCarpetasState();
}

class _VistaCarpetasState extends State<VistaCarpetas> {
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  _refresh() async {
    final data = await DatabaseHelper().getFolders();
    setState(() => folders = data);
  }

  // Diálogo para crear carpeta con selección de color
  _addFolder() async {
    String name = "";
    Color selectedColor = const Color(0xFF00529E);
    final List<Color> palette = [
      const Color(0xFF00529E), const Color(0xFFD99E30), 
      const Color(0xFF43A047), const Color(0xFFE53935),
      const Color(0xFF8E24AA), const Color(0xFF00ACC1)
    ];

    await showDialog(
      context: context,
      builder: (c) => StatefulBuilder( // Para actualizar el color dentro del diálogo
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Nueva Carpeta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (v) => name = v,
                decoration: const InputDecoration(hintText: "Ej: Matemáticas", labelText: "Nombre"),
              ),
              const SizedBox(height: 20),
              const Text("Selecciona un color:"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: palette.map((color) => GestureDetector(
                  onTap: () => setDialogState(() => selectedColor = color),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 15,
                    child: selectedColor == color ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
                  ),
                )).toList(),
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                if(name.isNotEmpty) {
                  await DatabaseHelper().insertFolder(Folder(name: name, color: selectedColor.value));
                  _refresh();
                }
                Navigator.pop(c);
              }, 
              child: const Text("Crear")
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Mis Grupos"), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15
        ),
        itemCount: folders.length,
        itemBuilder: (c, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => VistaNotas(folder: folders[i]))),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_copy, size: 60, color: Color(folders[i].color)),
                const SizedBox(height: 10),
                Text(
                  folders[i].name, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFolder,
        label: const Text("Nuevo Grupo"),
        icon: const Icon(Icons.create_new_folder),
      ),
    );
  }
}

// --- VISTA NOTAS (FILTRADA) ---
class VistaNotas extends StatefulWidget {
  final Folder folder;
  const VistaNotas({super.key, required this.folder});

  @override
  State<VistaNotas> createState() => _VistaNotasState();
}

class _VistaNotasState extends State<VistaNotas> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  _refresh() async {
    final data = await DatabaseHelper().getNotesByFolder(widget.folder.id!);
    setState(() => notes = data);
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ciencia': return Icons.science;
      case 'Naturaleza': return Icons.eco;
      case 'Tecnología': return Icons.memory;
      default: return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        backgroundColor: Color(widget.folder.color).withOpacity(0.1),
      ),
      body: notes.isEmpty 
        ? const Center(child: Text("No hay notas en este grupo."))
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12
            ),
            itemCount: notes.length,
            itemBuilder: (c, i) => GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (c) => FormularioNota(folderId: widget.folder.id!, note: notes[i])
                ));
                _refresh();
              },
              onLongPress: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text("Eliminar nota"),
                    content: const Text("¿Seguro que quieres eliminar esta nota?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancelar")),
                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Aceptar")),
                    ],
                  ),
                );
                if (confirm == true) {
                  await DatabaseHelper().deleteNote(notes[i].id!);
                  _refresh();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(notes[i].color),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10, bottom: -10,
                      child: Icon(_getCategoryIcon(notes[i].category), size: 70, color: Colors.white.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notes[i].title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                          const Divider(height: 10, thickness: 0.5),
                          Expanded(child: Text(notes[i].content, style: const TextStyle(fontSize: 12), maxLines: 4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(widget.folder.color),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => FormularioNota(folderId: widget.folder.id!)));
          _refresh();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- FORMULARIO NOTA ---
class FormularioNota extends StatefulWidget {
  final int folderId;
  final Note? note;
  const FormularioNota({super.key, required this.folderId, this.note});

  @override
  State<FormularioNota> createState() => _FormularioNotaState();
}

class _FormularioNotaState extends State<FormularioNota> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _t, _c;
  late Color _col;
  String _cat = "Vida Diaria";

  final List<String> _categories = ["Vida Diaria", "Ciencia", "Naturaleza", "Tecnología"];
  final List<Color> _palette = [const Color(0xFFD1E9F6), const Color(0xFFF1D3CE), const Color(0xFFEEE9DA), const Color(0xFFD4E2D4)];

  @override
  void initState() {
    super.initState();
    _t = TextEditingController(text: widget.note?.title ?? '');
    _c = TextEditingController(text: widget.note?.content ?? '');
    _col = widget.note != null ? Color(widget.note!.color) : _palette[0];
    _cat = widget.note?.category ?? "Vida Diaria";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _col,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _t,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(hintText: "Título...", border: InputBorder.none),
                validator: (v) => (v == null || v.trim().isEmpty) ? "El título es obligatorio" : null, // [cite: 53]
              ),
              const Divider(),
              TextFormField(
                controller: _c,
                maxLines: 10,
                decoration: const InputDecoration(hintText: "Contenido de la nota...", border: InputBorder.none),
              ),
              const SizedBox(height: 20),
              const Text("Selecciona Figura/Categoría:"),
              DropdownButton<String>(
                value: _cat,
                isExpanded: true,
                items: _categories.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _cat = v!),
              ),
              const SizedBox(height: 20),
              const Text("Color de nota:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _palette.map((c) => GestureDetector(
                  onTap: () => setState(() => _col = c),
                  child: CircleAvatar(backgroundColor: c, radius: 20, child: _col == c ? const Icon(Icons.check) : null),
                )).toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00529E), 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15)
                ),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    final n = Note(
                      id: widget.note?.id, title: _t.text, content: _c.text, 
                      color: _col.value, category: _cat, folderId: widget.folderId
                    );
                    widget.note == null ? await DatabaseHelper().insertNote(n) : await DatabaseHelper().updateNote(n);
                    if(mounted) Navigator.pop(context);
                  }
                },
                child: const Text("GUARDAR NOTA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}