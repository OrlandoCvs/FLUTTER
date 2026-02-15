class Note {
  int? id;
  String title;
  String content;
  int color;
  String category; // "Ciencia", "Naturaleza", etc.
  int folderId;    // Relación con la carpeta

  Note({
    this.id, 
    required this.title, 
    this.content = '', 
    required this.color,
    this.category = 'Vida Diaria',
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'title': title, 
      'content': content, 
      'color': color,
      'category': category,
      'folderId': folderId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      category: map['category'] ?? 'Vida Diaria',
      folderId: map['folderId'],
    );
  }
}