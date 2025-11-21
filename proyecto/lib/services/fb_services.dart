import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> categoriaPorId(
    String categoriaId,
  ) {
    return FirebaseFirestore.instance
        .collection('categorias')
        .doc(categoriaId)
        .get();
  }

  Future<void> borrarEventoPorId(String eventoId) {
    return FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventoId)
        .delete();
  }
}
