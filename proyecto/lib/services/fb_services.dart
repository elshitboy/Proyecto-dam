import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
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

  Future<void> agregarEvento({
    required String titulo,
    required DateTime fechaHora,
    required String lugar,
    required String categoriaId,
    required String autor,
  }) async {
    await FirebaseFirestore.instance.collection('eventos').add({
      'titulo': titulo,
      'fechaHora': fechaHora,
      'lugar': lugar,
      'categoriaId': categoriaId,
      'autor': autor,
      'creadoEn': Timestamp.now(), // opcional
    });
  }
}
