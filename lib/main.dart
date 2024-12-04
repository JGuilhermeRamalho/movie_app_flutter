import 'package:flutter/material.dart';
import 'package:movie_app_flutter/view/filme_catalogo_page.dart';
import 'package:movie_app_flutter/view/usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: FilmeCatalogoPage(),
    );
  }
}
