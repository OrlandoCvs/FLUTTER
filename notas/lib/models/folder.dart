class Folder {
  int? id;
  String name;
  int color; // Nuevo campo para el color

  Folder({this.id, required this.name, required this.color});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'color': color};

  factory Folder.fromMap(Map<String, dynamic> map) => Folder(
    id: map['id'],
    name: map['name'],
    color: map['color'] ?? 0xFF00529E, // Color por defecto (Azul Unison)
  );
}