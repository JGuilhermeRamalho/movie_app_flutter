import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/filme.dart';

class FilmeRepository {
  final String apiKey = '4ca717da42ff2a127e5e8c9a0ae1a2b3';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Filme>> buscarFilmesPopulares() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List resultados = dados['results'];
      return resultados.map((json) => Filme.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes');
    }
  }
}
