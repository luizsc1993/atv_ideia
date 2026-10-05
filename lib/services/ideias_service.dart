import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ideia_model.dart';

class IdeiasService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('ideias');

  Stream<List<IdeiaModel>> listarIdeias() {
    return _collection
        .orderBy('votos', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => IdeiaModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> cadastrarIdeia({
    required String titulo,
    required String descricao,
    required String autor,
  }) async {
    await _collection.add({
      'titulo': titulo,
      'descricao': descricao,
      'autor': autor,
      'votos': 0,
    });
  }

  Future<void> votar(String id) async {
    await _collection.doc(id).update({
      'votos': FieldValue.increment(1),
    });
  }

  Future<void> excluir(String id) async {
    await _collection.doc(id).delete();
  }
}
