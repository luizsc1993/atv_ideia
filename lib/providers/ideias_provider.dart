import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/ideia_model.dart';
import '../services/ideias_service.dart';

class IdeiasProvider extends ChangeNotifier {
  final IdeiasService _service;

  IdeiasProvider(this._service) {
    _subscription = _service.listarIdeias().listen(
      (ideias) {
        _ideias = ideias;
        _erro = null;
        notifyListeners();
      },
      onError: (error) {
        _erro = error.toString();
        notifyListeners();
      },
    );
  }

  List<IdeiaModel> _ideias = [];
  String? _erro;
  StreamSubscription<List<IdeiaModel>>? _subscription;

  List<IdeiaModel> get ideias => _ideias;
  String? get erro => _erro;
  bool get temIdeias => _ideias.isNotEmpty;

  IdeiaModel? get ideiaMaisVotada =>
      _ideias.isEmpty ? null : _ideias.first;

  Future<void> cadastrarIdeia({
    required String titulo,
    required String descricao,
    required String autor,
  }) {
    return _service.cadastrarIdeia(
      titulo: titulo,
      descricao: descricao,
      autor: autor,
    );
  }

  Future<void> votar(String id) {
    return _service.votar(id);
  }

  Future<void> excluir(String id) {
    return _service.excluir(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
