import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/einkauf_item.dart';

class FirestoreService {
  final CollectionReference _einkaufsCollection = FirebaseFirestore.instance.collection('einkaufsitems');

  Future<void> addEinkaufItem(EinkaufItem item) {
    return _einkaufsCollection.add(item.toMap());
  }

  Stream<List<EinkaufItem>> getEinkaufItems() {
    return _einkaufsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EinkaufItem.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<void> updateEinkaufItem(EinkaufItem item) {
    return _einkaufsCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteEinkaufItem(String id) {
    return _einkaufsCollection.doc(id).delete();
  }
}
