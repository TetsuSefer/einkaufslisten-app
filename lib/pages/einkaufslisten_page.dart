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

  Future<void> _addItem() async {
    String name = _controller.text.trim();
    if (name.isNotEmpty) {
      await _firestoreService.addEinkaufItem(EinkaufItem(id: '', name: name));
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte einen Namen eingeben')),
      );
    }
  }

  Widget _buildListItem(EinkaufItem item) {
    return Card(
      elevation: 3,
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
            item.erledigt ? Icons.check : Icons.shopping_cart, // Symbol rot bei Erledigt
            color: item.erledigt ? const Color.fromARGB(255, 149, 11, 11) : Colors.white,
          ),
        ),
        trailing: Checkbox(
          value: item.erledigt,
          onChanged: (bool? value) {
            setState(() {
              item.erledigt = value ?? false;
              _firestoreService.updateEinkaufItem(item);
            });
          },
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Item löschen'),
              content: Text('Möchtest du "${item.name}" wirklich löschen?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    _firestoreService.deleteEinkaufItem(item.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Löschen', style: TextStyle(color: Color.fromARGB(255, 149, 11, 11))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EINKAUFSLISTE',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 149, 11, 11),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Column(
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
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _addItem(), // Neues Item mit Enter bestätigen
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
    );
  }
}
