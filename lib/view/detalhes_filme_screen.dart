import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import '../data/model/filme.dart';
import '../data/repository/filme_repository.dart';

class DetalhesFilmeScreen extends StatefulWidget {
  final Filme filme;
  final String trailerId;

  const DetalhesFilmeScreen({
    Key? key,
    required this.filme,
    required this.trailerId,
  }) : super(key: key);

  @override
  _DetalhesFilmeScreenState createState() => _DetalhesFilmeScreenState();
}

class _DetalhesFilmeScreenState extends State<DetalhesFilmeScreen> {
  late YoutubePlayerController _controller;
  late FilmeRepository _filmeRepository;
  List<Map<String, String>> atores = [];
  int atoresVisiveis = 5;

  @override
  void initState() {
    super.initState();
    _filmeRepository = FilmeRepository();
    _initializeYoutubePlayer();
    _buscarAtores();
  }

  @override
  void dispose() {
    _disableFullScreenMode();
    _controller.dispose();
    super.dispose();
  }

  void _initializeYoutubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        isLive: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isFullScreen) {
        _enableFullScreenMode();
      } else {
        _disableFullScreenMode();
      }
    });
  }

  Future<void> _buscarAtores() async {
    try {
      final atoresDoFilme = await _filmeRepository.buscarAtores(widget.filme.id);
      setState(() {
        atores = atoresDoFilme;
      });
    } catch (e) {
      print('Erro ao carregar atores: $e');
    }
  }

  void _carregarMaisAtores() {
    setState(() {
      atoresVisiveis += 5;
    });
  }

  void _enableFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _disableFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildFilmDetails(),
            _buildYoutubePlayer(),
            _buttonBack(),
          ],
        ),
      ),
    );
  }

  Widget _buttonBack () {
   return Positioned(
      top: 8.0,
      left: 8.0,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildFilmDetails() {
    final DateTime releaseDate = DateTime.parse(widget.filme.releaseDate);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(releaseDate);

    return Padding(
      padding: const EdgeInsets.only(top: 250.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(widget.filme.titulo),
            _buildDescription(widget.filme.descricao),
            _buildReleaseDate(formattedDate),
            _buildActorsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildReleaseDate(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Data de lançamento: $date',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActorsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atores:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildActorsList(),
          if (atoresVisiveis < atores.length)
            ElevatedButton(
              onPressed: _carregarMaisAtores,
              child: const Text('Carregar mais atores'),
            ),
        ],
      ),
    );
  }

  Widget _buildActorsList() {
    return atores.isEmpty
        ? const CircularProgressIndicator()
        : Wrap(
      spacing: 8.0,
      direction: Axis.vertical,
      children: atores.take(atoresVisiveis).map((ator) {
        return Chip(
          label: Row(
            children: [
              ator['image'] != null && ator['image'] != ''
                  ? CircleAvatar(
                backgroundImage: NetworkImage(ator['image']!),
              )
                  : const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 8.0),
              Text(
                ator['name']!,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        );
      }).toList(),
    );
  }

  Widget _buildYoutubePlayer() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
