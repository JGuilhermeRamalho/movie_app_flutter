import 'package:flutter/material.dart';

import '../model/filme.dart';

class DetalhesFilmeScreen extends StatelessWidget {
  final Filme filme;

  const DetalhesFilmeScreen({Key? key, required this.filme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'imagem_${filme.posterPath}', // O mesmo tag usado no Hero da lista
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${filme.posterPath}',
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.7,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              filme.titulo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              filme.descricao,
              style: TextStyle(fontSize: 16, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
