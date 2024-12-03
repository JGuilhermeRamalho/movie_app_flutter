import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../model/filme.dart';
import '../repository/filme_repository.dart';

class FilmeCubit extends Cubit<List<Filme>> {
  final FilmeRepository repository;

  FilmeCubit(this.repository) : super([]);

  Future<void> carregarFilmesPopulares() async {
    try {
      final filmes = await repository.buscarFilmesPopulares();
      emit(filmes);
    } catch (e) {
      debugPrint('Erro: $e');
      emit([]);
    }
  }
}
