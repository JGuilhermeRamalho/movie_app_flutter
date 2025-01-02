import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../data/model/filme.dart';
import '../data/repository/filme_repository.dart';

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

  Future<void> carregarFilmesLancamentos() async {
    try {
      final filmes = await repository.buscarFilmesLancamentos();
      emit(filmes);
    } catch (e) {
      debugPrint('Erro: $e');
      emit([]);
    }
  }

  Future<String?> carregarTrailerFilme(int movieId) async {
    try {
      final trailerId = await repository.buscarTrailerId(movieId);
      return trailerId;
    } catch (e) {
      debugPrint('Erro: $e');
      return null;
    }
  }

  Future<void> carregarFilmesEmAlta() async {
    try {
      final filmes = await repository.buscarFilmesEmAlta();
      emit(filmes);
    } catch (e) {
      debugPrint('Erro: $e');
      emit([]);
    }
  }
}
