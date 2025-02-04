import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';
import '../widgets/animated_play_button.dart';
import '../widgets/glassmorphism.dart';

class SongsListItem extends StatefulWidget {
  const SongsListItem({ super.key });
  @override
  State<SongsListItem> createState() => _SongsListItemState();
}

class _SongsListItemState extends State<SongsListItem> {
  double currentTime = 0;
  double volume = 0.5;
  bool isPlaying = false;
  bool isLoading = true;
  late Map<String, dynamic> currentSong = {};
  late List<Map<String, dynamic>> songs;
  late int currentIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    songs = List<Map<String, dynamic>>.from(args['songs_list']);
    currentIndex = args['index'];
    currentSong = songs[currentIndex];
    isLoading = false;
  }
  
  void _toggleFavorite() {
    setState(() {
      currentSong['isFavorite'] = !currentSong['isFavorite'];
    });
  }

  void playPause(){
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextSong() {
    if (currentIndex < songs.length - 1) {
      setState(() {
        currentIndex++;
        currentSong = songs[currentIndex];
        currentTime = 0;
        isPlaying = true;
        isLoading = false;
      });
    }
  }

  void previousSong() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSong = songs[currentIndex];
        currentTime = 0;
        isPlaying = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

  return Scaffold(
    appBar: AppBar(toolbarHeight: 65), backgroundColor: isDarkTheme ? Colors.black : Colors.white,
    endDrawer: const DrawerMenu(),
    body: Column(
      children: [
          // Imagen superior
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    currentSong['image']!,
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el área disponible
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDarkTheme ? const Color.fromARGB(255, 12, 10, 15) : Colors.transparent,
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    )
                  )
                ),
                // Gradiente superpuesto
                Positioned(
                  bottom: -1,
                  child: Container(
                    height: 150, // Altura del gradiente ajustada
                    width: MediaQuery.of(context).size.width, // Ancho completo
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDarkTheme ? const Color.fromARGB(255, 12, 10, 15) : Colors.transparent,
                          isDarkTheme ? const Color.fromARGB(255, 12, 10, 15).withValues(alpha: 0.8) : Colors.transparent,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    child: Glassmorphism(blur: 10, opacity: 0.1, radius: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(currentSong['name'] ?? 'Not found',style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(203, 255, 255, 255)), overflow: TextOverflow.ellipsis, maxLines: 1),
                                      const SizedBox(height: 10),
                                      Text(currentSong['artist'] ?? 'Not found', style: const TextStyle(fontSize: 20, color: Color.fromARGB(203, 255, 255, 255)), overflow: TextOverflow.ellipsis, maxLines: 1),
                                      const SizedBox(height: 10),
                                    ]
                                  )
                                )
                              ),                       
                              IconButton(
                                icon: currentSong['isFavorite'] ?
                                  ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color.fromARGB(255, 109, 37, 233), Color.fromARGB(255, 79, 130, 239)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds),
                                  child: const Icon(Icons.favorite_sharp, color: Colors.white),
                                ) : const Icon(Icons.favorite, color: Color.fromARGB(133, 171, 171, 171)),
                                onPressed: _toggleFavorite
                              )
                            ]
                          ),
                        ]
                      )
                    )
                )
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            flex: 3,
            child: Container(
              color: isDarkTheme ? const Color.fromARGB(255, 12, 10, 15) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Slider(
                        activeColor: const Color.fromARGB(255, 118, 17, 206),
                        value: currentTime,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            currentTime = value;
                          });
                        }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shuffle),
                            onPressed: previousSong,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, size: 35),
                            onPressed: previousSong,
                          ),
                          AnimatedPlayButton(
                            isPlaying: isPlaying,
                            onPressed: playPause,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 35),
                            onPressed: nextSong,
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat_rounded),
                            onPressed: nextSong,
                          )
                        ] 
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 20), child: Icon(Icons.volume_down_rounded)),
                          Expanded(
                            child: Slider(
                              activeColor: const Color.fromARGB(208, 70, 113, 231),
                              value: volume,
                              max: 1,
                              onChanged: (value) {
                                setState(() {
                                  volume = value;
                                });
                              }
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.volume_up_rounded))
                          ]
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/gradient.png', fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}

class HeaderProfileCustomItem extends StatelessWidget {
  final Size size;
  final String songCover;

  const HeaderProfileCustomItem({
    super.key,
    required this.songCover,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      margin: const EdgeInsets.all(20),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: songCover.isNotEmpty
              ? Image.network(songCover, fit: BoxFit.cover)
              : Image.asset('assets/images/album.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
