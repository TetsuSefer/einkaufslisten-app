import 'package:cloud_firestore/cloud_firestore.dart';

class EinkaufItem {
  String id;
  String name;
  bool erledigt;

  EinkaufItem({required this.id, required this.name, this.erledigt = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'erledigt': erledigt,
    };
  }

  static EinkaufItem fromDocumentSnapshot(DocumentSnapshot doc) {
    return EinkaufItem(
      id: doc.id,
      name: doc['name'],
      erledigt: doc['erledigt'],
    );
  }
}
