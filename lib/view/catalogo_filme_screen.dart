import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/filme.dart';
import '../data/repository/filme_repository.dart';
import '../logic/filme_cubit.dart';
import 'detalhes_filme_screen.dart';

class FilmeCatalogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 29, 1),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _buildSection(context, 'Filmes em Lançamento',
                FilmeCubit(FilmeRepository())..carregarFilmesLancamentos(), true, true, MediaQuery.sizeOf(context).height * 0.3, 0.95),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _buildSection(context, 'Filmes Populares',
                FilmeCubit(FilmeRepository())..carregarFilmesPopulares(), false, false, MediaQuery.sizeOf(context).height * 0.3, 0.5),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _buildSection(context, 'Filmes em Alta',
                FilmeCubit(FilmeRepository())..carregarFilmesEmAlta(), false, false, MediaQuery.sizeOf(context).height * 0.3, 0.5),
          ],
        ),
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade900, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Movie App Flutter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }

  // Cria uma seção de filmes com título e carrossel.
  Widget _buildSection(BuildContext context, String title, FilmeCubit cubit, bool autoPlay, bool centerFocus, double height, double viewportFraction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title),
        _buildFilmeCarousel(context, cubit, height, viewportFraction, autoPlay, centerFocus),
      ],
    );
  }

  // Cria o título de uma seção.
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width * 0.05,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Cria o carrossel de filmes.
  Widget _buildFilmeCarousel(BuildContext context, FilmeCubit cubit, double height, double viewportFraction, bool autoPlay, bool centerFocus) {
    return BlocProvider(
      create: (_) => cubit,
      child: BlocBuilder<FilmeCubit, List<Filme>>(
        builder: (context, filmes) {
          return CarouselSlider(
            items: filmes.map((filme) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9), // Ajuste o valor para o espaçamento desejado
                child: _buildFilmeCard(context, filme, cubit),
              );
            }).toList(),
            options: CarouselOptions(
              enlargeFactor: 2,
              height: height,
              autoPlay: autoPlay,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: centerFocus,
              viewportFraction: viewportFraction,
            ),
          );
        },
      ),
    );
  }


  // Cria o cartão de um filme no carrossel.
  Widget _buildFilmeCard(BuildContext context, Filme filme, FilmeCubit cubit) {
    return GestureDetector(
      onTap: () => _navigateToDetalhesFilme(context, filme, cubit),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w500${filme.posterPath}',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }

  // Navega para a tela de detalhes do filme.
  Future<void> _navigateToDetalhesFilme(BuildContext context, Filme filme, FilmeCubit cubit) async {
    final trailerId = await cubit.carregarTrailerFilme(filme.id);
    if (trailerId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalhesFilmeScreen(
            filme: filme,
            trailerId: trailerId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trailer não encontrado')),
      );
    }
  }
}
