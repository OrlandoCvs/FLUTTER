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

// --- VISTA INICIO (FONDO CORREGIDO E INTEGRANTES) ---
class VistaInicio extends StatelessWidget {
  const VistaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00529E), Color(0xFF015294)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/logo_unison.png',
                          height: 120,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 80, color: Color(0xFF00529E)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text("UNISON NOTES", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFF8BB00))),
                      const SizedBox(height: 20),
                      const Text("Integrantes del Equipo:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8), child: Divider(color: Colors.white54)),
                      const Text("Saul Espinoza Rivera", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const Text("Orlando Cervantes Sousa", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const Text("Yeitnaletzi Álvarez Portillo", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const Text("María Valencia Loroña", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const Text("Hugo Hinojoza Lopez", style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF8BB00), 
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const VistaCarpetas())),
                        child: const Text("INGRESAR", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- VISTA GRUPOS ---
class VistaCarpetas extends StatefulWidget {
  const VistaCarpetas({super.key});
  @override
  State<VistaCarpetas> createState() => _VistaCarpetasState();
}

class _VistaCarpetasState extends State<VistaCarpetas> {
  List<Folder> folders = [];
  List<Folder> filtered = [];
  bool isSearching = false;

  @override
  void initState() { super.initState(); _refresh(); }

  _refresh() async {
    final data = await DatabaseHelper().getFolders();
    setState(() { folders = data; filtered = data; isSearching = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching ? const Text("Mis Grupos") : TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Buscar grupo...", border: InputBorder.none),
          onChanged: (q) => setState(() => filtered = folders.where((f) => f.name.toLowerCase().contains(q.toLowerCase())).toList()),
        ),
        actions: [IconButton(icon: Icon(isSearching ? Icons.close : Icons.search), onPressed: () => setState(() { isSearching = !isSearching; if(!isSearching) filtered = folders; }))],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: filtered.length,
        itemBuilder: (c, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => VistaNotas(folder: filtered[i]))),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder, size: 60, color: Color(filtered[i].color)),
                const SizedBox(height: 10),
                Text(filtered[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showAdd(context), child: const Icon(Icons.add)),
    );
  }

  _showAdd(BuildContext context) {
    String n = ""; Color col = const Color(0xFF00529E);
    showDialog(context: context, builder: (c) => StatefulBuilder(builder: (c, setS) => AlertDialog(
      title: const Text("Nuevo Grupo"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(onChanged: (v) => n = v, decoration: const InputDecoration(labelText: "Nombre")),
        const SizedBox(height: 20),
        Wrap(spacing: 10, children: [Colors.blue, Colors.orange, Colors.green, Colors.red].map((color) => GestureDetector(
          onTap: () => setS(() => col = color),
          child: CircleAvatar(backgroundColor: color, radius: 15, child: col == color ? const Icon(Icons.check, size: 15, color: Colors.white) : null),
        )).toList())
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancelar")), ElevatedButton(onPressed: () async {
        if(n.isNotEmpty) { await DatabaseHelper().insertFolder(Folder(name: n, color: col.value)); _refresh(); }
        Navigator.pop(c);
      }, child: const Text("Crear"))],
    )));
  }
}

// --- VISTA NOTAS (CON ICONOS RECUPERADOS) ---
class VistaNotas extends StatefulWidget {
  final Folder folder;
  const VistaNotas({super.key, required this.folder});
  @override
  State<VistaNotas> createState() => _VistaNotasState();
}

class _VistaNotasState extends State<VistaNotas> {
  List<Note> notes = [];
  List<Note> filtered = [];
  bool isSearching = false;

  @override
  void initState() { super.initState(); _refresh(); }

  _refresh() async {
    final data = await DatabaseHelper().getNotesByFolder(widget.folder.id!);
    setState(() { notes = data; filtered = data; });
  }

  IconData? _getIcon(String cat) {
    switch (cat) {
      case 'Ciencia': return Icons.science;
      case 'Naturaleza': return Icons.eco;
      case 'Tecnología': return Icons.memory;
      case 'Vida Diaria': return Icons.assignment;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching ? Text(widget.folder.name) : TextField(
          autofocus: true,
          onChanged: (q) => setState(() => filtered = notes.where((n) => n.title.toLowerCase().contains(q.toLowerCase())).toList()),
          decoration: const InputDecoration(hintText: "Buscar nota...", border: InputBorder.none),
        ),
        actions: [IconButton(icon: Icon(isSearching ? Icons.close : Icons.search), onPressed: () => setState(() { isSearching = !isSearching; if(!isSearching) filtered = notes; }))],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: filtered.length,
        itemBuilder: (c, i) => GestureDetector(
          onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (c) => FormularioNota(folderId: widget.folder.id!, note: filtered[i]))); _refresh(); },
          child: Container(
            decoration: BoxDecoration(color: Color(filtered[i].color), borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                if (_getIcon(filtered[i].category) != null)
                  Positioned(right: -10, bottom: -10, child: Icon(_getIcon(filtered[i].category), size: 70, color: Colors.white.withOpacity(0.2))),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(filtered[i].title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                    const Divider(),
                    Expanded(child: Text(filtered[i].content, style: const TextStyle(fontSize: 12), maxLines: 4)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Color(widget.folder.color), onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (c) => FormularioNota(folderId: widget.folder.id!))); _refresh();
      }, child: const Icon(Icons.add, color: Colors.white)),
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
  String _cat = "Sin icono";
  final List<String> _cats = ["Sin icono", "Vida Diaria", "Ciencia", "Naturaleza", "Tecnología"];

  @override
  void initState() {
    super.initState();
    _t = TextEditingController(text: widget.note?.title ?? '');
    _c = TextEditingController(text: widget.note?.content ?? '');
    _col = widget.note != null ? Color(widget.note!.color) : Colors.blue.shade100;
    _cat = (widget.note?.category == "" || widget.note?.category == null) ? "Sin icono" : widget.note!.category;
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
          child: ListView(children: [
            TextFormField(controller: _t, decoration: const InputDecoration(labelText: "Título *"), validator: (v) => v!.isEmpty ? "Obligatorio" : null),
            const Divider(),
            TextFormField(controller: _c, maxLines: 8, decoration: const InputDecoration(labelText: "Contenido")),
            const SizedBox(height: 20),
            const Text("Clasificación (Figura de fondo):"),
            DropdownButton<String>(
              value: _cat, isExpanded: true, items: _cats.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => _cat = v!),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Colors.blue.shade100, Colors.red.shade100, Colors.green.shade100, Colors.orange.shade100].map((c) => GestureDetector(
              onTap: () => setState(() => _col = c), child: CircleAvatar(backgroundColor: c, child: _col == c ? const Icon(Icons.check) : null),
            )).toList()),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00529E), foregroundColor: Colors.white),
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  final n = Note(id: widget.note?.id, title: _t.text, content: _c.text, color: _col.value, category: (_cat == "Sin icono" ? "" : _cat), folderId: widget.folderId);
                  widget.note == null ? await DatabaseHelper().insertNote(n) : await DatabaseHelper().updateNote(n);
                  Navigator.pop(context);
                }
              }, child: const Text("GUARDAR NOTA"),
            ),
          ]),
        ),
      ),
    );
  }
}