import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/filme.dart';

class FilmeRepository {
  final String apiKey = '7b429991f15b799668186b7e3baf5565';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Filme>> buscarFilmesPopulares() async {
    final url =
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List resultados = dados['results'];
      return resultados.map((json) => Filme.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes');
    }
  }

  Future<List<Filme>> buscarFilmesLancamentos() async {
    final url =
        Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey&language=pt-BR');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List resultados = dados['results'];
      return resultados.map((json) => Filme.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes em lançamentos');
    }
  }

  Future<String?> buscarTrailerId(int movieId) async {
    final baseUrl = 'https://api.themoviedb.org/3';
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List resultados = dados['results'];

      // Filtrar pelo tipo Trailer e site YouTube
      final trailer = resultados.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );

      return trailer?['key']; // Retorna o ID do vídeo no YouTube
    } else {
      throw Exception('Erro ao buscar trailer');
    }
  }

  // Função para buscar atores de um filme com as imagens
  Future<List<Map<String, String>>> buscarAtores(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List<dynamic> cast = dados['cast'];

      return cast.map((actor) {
        return {
          'name': actor['name'] as String,
          'image':
              'https://image.tmdb.org/t/p/w500${actor['profile_path'] ?? ''}' // Monta a URL da imagem
        };
      }).toList();
    } else {
      throw Exception('Erro ao buscar atores');
    }
  }

  // Método para buscar filmes em alta (trending)
  Future<List<Filme>> buscarFilmesEmAlta() async {
    final url = Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final List resultados = dados['results']; // Filmes em alta
      return resultados.map((json) => Filme.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes em alta');
    }
  }
}
