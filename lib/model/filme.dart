class Filme {
  final int id;
  final String titulo;
  final String posterPath;
  final String descricao;

  Filme({
    required this.id,
    required this.titulo,
    required this.posterPath,
    required this.descricao,
  });

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: json['id'],
      titulo: json['title'],
      posterPath: json['poster_path'] ?? '',
      descricao: json['overview'],
    );
  }
}
