import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/filme.dart';
import '../repository/filme_repository.dart';
import '../view_model/filme_cubit.dart';

class FilmeCatalogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Filmes')),
      body: BlocProvider(
        create: (context) => FilmeCubit(FilmeRepository())..carregarFilmesPopulares(),
        child: BlocBuilder<FilmeCubit, List<Filme>>(
          builder: (context, filmes) {
            if (filmes.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return ListTile(
                  leading: Image.network('https://image.tmdb.org/t/p/w500${filme.posterPath}'),
                  title: Text(filme.titulo),
                  subtitle: Text(filme.descricao),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
