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

  Future<void> _addItem() async {
    String name = _controller.text.trim();
    if (name.isNotEmpty) {
      await _firestoreService.addEinkaufItem(EinkaufItem(id: '', name: name));
      _controller.clear();
    }
  }

  Widget _buildListItem(EinkaufItem item) {
    return ListTile(
      title: Text(item.name),
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
        _firestoreService.deleteEinkaufItem(item.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einkaufsliste'),
      ),
      body: Column(
        children: [
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
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(items[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Neues Item hinzufügen',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
