import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/einkauf_item.dart';

class EinkaufslistenPage extends StatefulWidget {
  const EinkaufslistenPage({super.key});

  @override
  State<EinkaufslistenPage> createState() => _EinkaufslistenPageState();
}

class _EinkaufslistenPageState extends State<EinkaufslistenPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = "";

  final FocusNode _focusNode = FocusNode(); // Fokus-Node für das Textfeld

  Future<void> _addItem() async {
    String name = _controller.text.trim();
    if (name.isNotEmpty) {
      await _firestoreService.addEinkaufItem(EinkaufItem(id: '', name: name));
      _controller.clear();
      _focusNode.requestFocus(); // Fokus bleibt auf dem Textfeld
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte einen Namen eingeben')),
      );
    }
  }

  Future<void> _editItem(EinkaufItem item) async {
    final TextEditingController editController = TextEditingController(text: item.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item bearbeiten'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(labelText: 'Neuer Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              final newName = editController.text.trim();
              if (newName.isNotEmpty) {
                item.name = newName;
                _firestoreService.updateEinkaufItem(item);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name darf nicht leer sein')),
                );
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(EinkaufItem item) {
    return Card(
      elevation: 3,
      color: Colors.white, // Card ist rein weiß
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.erledigt ? TextDecoration.lineThrough : null,
            color: item.erledigt ? Colors.grey : Colors.black,
            fontSize: 18,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: item.erledigt ? Colors.white : const Color.fromARGB(255, 149, 11, 11),
          child: Icon(
            item.erledigt ? Icons.check : Icons.shopping_cart,
            color: item.erledigt ? const Color.fromARGB(255, 149, 11, 11) : Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => _editItem(item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _firestoreService.deleteEinkaufItem(item.id);
              },
            ),
            Checkbox(
              value: item.erledigt,
              onChanged: (bool? value) {
                setState(() {
                  item.erledigt = value ?? false;
                  _firestoreService.updateEinkaufItem(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1000;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EINKAUFSLISTE',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 149, 11, 11),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: isWideScreen ? 900 : screenWidth, // Responsive Breite
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Colors.white, // Card bleibt rein weiß
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query.trim();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Suchen',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<EinkaufItem>>(
                    stream: _firestoreService.getEinkaufItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Fehler: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = snapshot.data ?? [];

                      // Sortierung: Alphabetisch nach dem Namen
                      items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                      final filteredItems = items.where((item) {
                        return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'Keine Items gefunden!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return _buildListItem(filteredItems[index]);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 149, 11, 11),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode, // Fokus auf Textfeld
                          onSubmitted: (_) => _addItem(),
                          decoration: const InputDecoration(
                            hintText: 'Neues Item hinzufügen',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addItem,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
