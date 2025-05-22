class Note {
  int? id;
  String title;
  String content;
  String category;
  String timestamp;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'timestamp': timestamp,
    };
  }

  // Optionally: fromMap method for clarity
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      timestamp: map['timestamp'],
    );
  }
}
