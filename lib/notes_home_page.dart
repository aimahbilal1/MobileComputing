import 'package:flutter/material.dart';
import 'note.dart';
import 'notes_database.dart';
import 'note_editor.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Note> notes = [];
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = ['All', 'Class Notes', 'Work', 'Personal'];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await NotesDatabase.getNotes(
      category: selectedCategory,
      searchQuery: searchQuery,
    );
    setState(() {
      notes = data;
    });
  }

  void _navigateToCreateNote(BuildContext context, [Note? note]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditor(note: note)),
    );
    loadNotes();
  }

  void _deleteNote(int id) async {
    await NotesDatabase.deleteNote(id);
    loadNotes();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Class Notes':
        return Color(0xFFE1D5F5);
      case 'Work':
        return Color(0xFFD1F2EB);
      case 'Personal':
        return Color(0xFFFFD8CC);
      default:
        return Color(0xFFDCF0F7);
    }
  }

  String _getCategoryEmoji(String category) {
    switch (category) {
      case 'Class Notes':
        return '📚';
      case 'Work':
        return '💼';
      case 'Personal':
        return '💖';
      default:
        return '🗂️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search notes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
                loadNotes();
              },
            ),
          ),
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    selectedColor: Colors.deepPurple.shade200,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat;
                        loadNotes();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Notes List
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      'No notes yet. Tap + to create one!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final bgColor = _getCategoryColor(note.category);
                      final emoji = _getCategoryEmoji(note.category);

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _navigateToCreateNote(context, note),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(emoji, style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      note.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                note.content.length > 100
                                    ? note.content.substring(0, 100) + '...'
                                    : note.content,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    note.timestamp,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => _deleteNote(note.id!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateNote(context),
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
    );
  }
}
