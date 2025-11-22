import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance
    .collection('eventos')
    .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> categoriaPorId(
    String categoriaId
  ) {
    return FirebaseFirestore.instance
    .collection('categorias')
    .doc(categoriaId)
    .get();
  }

  Future<void> agregarEvento(
    String titulo, 
    DateTime fechaHora, 
    String lugar, 
    String categoriaId
  ) {
    return FirebaseFirestore.instance
    .collection('eventos')
    .doc().set(
      {
      'titulo': titulo, 
      'autor': FirebaseAuth.instance.currentUser!.email, 
      'categoriaId': categoriaId, 
      'lugar': lugar, 
      'fechaHora': Timestamp.fromDate(fechaHora),
      'creadoEn': Timestamp.now(), // opcional
      }
    );
  }

  Future<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance
    .collection('categorias')
    .orderBy('nombre')
    .get();
  }

  Future<void> borrarEventoPorId(String eventoId) {
    return FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventoId)
        .delete();
  }
}