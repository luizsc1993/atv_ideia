class IdeiaModel {
  final String id;
  final String titulo;
  final String descricao;
  final String autor;
  final int votos;

  const IdeiaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.autor,
    required this.votos,
  });

  factory IdeiaModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return IdeiaModel(
      id: id,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      autor: map['autor'] ?? '',
      votos: (map['votos'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'autor': autor,
      'votos': votos,
    };
  }
}
