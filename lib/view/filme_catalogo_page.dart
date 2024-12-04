import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/filme.dart';
import '../repository/filme_repository.dart';
import '../view_model/filme_cubit.dart';
import 'detalhe_filme_screen.dart';

class FilmeCatalogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 29, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade900,

                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text('Movie App Flutter', style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Container(height: MediaQuery.sizeOf(context).height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Filmes Populares',
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.05,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(height: MediaQuery.sizeOf(context).height * 0.01),
          BlocProvider(
            create: (context) =>
                FilmeCubit(FilmeRepository())..carregarFilmesPopulares(),
            child: BlocBuilder<FilmeCubit, List<Filme>>(
              builder: (context, filmes) {
                if (filmes.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return CarouselSlider(
                  items: filmes.map((filme) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesFilmeScreen(filme: filme),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'imagem_${filme.posterPath}', // Identificador único para o Hero
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${filme.posterPath}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    enlargeCenterPage: true,
                    viewportFraction: 0.4,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
