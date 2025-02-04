import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/search_area.dart';
import '../services/api_service.dart';

class SongsListScreen extends StatefulWidget {
  const SongsListScreen({super.key});
  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  String _username = "user";
  bool _searchActive = false;
  bool  isLoading = true;
  List<Map<String, dynamic>> _filteredSongs = [];
  List<Map<String, dynamic>> _songs = [];
  List<Map<String, dynamic>> _favSongs = [];
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final filter = args['filter'] ?? 'all';
      _loadUserData();
      if (filter == 'all') {
        _fetchSongs();
      } else {
        _fetchSongsByMood(filter);
      }
    });
  }

  Future<void> _fetchSongs() async {
    try {
      final songs = await _apiService.fetchSongs();
      setState(() {
        _filteredSongs = songs.cast<Map<String, dynamic>>();
        _songs = List.from(_filteredSongs);
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching songs: $err');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchSongsByMood(String mood) async {
    try {
      final response = await _apiService.fetchSongsByMood(mood);
      setState(() {
        _songs = response.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching songs by mood: $err');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = SharedPreferences.getInstance();
    _username = (await prefs).getString('username') ?? '';
  }

  Future<void> _saveFavSongs() async {
    final prefs = await SharedPreferences.getInstance();
    // _favSongs = _songs.where((song) => song['isFavorite']).map((song) => song['id']).toList();
  }

  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget appBar({required VoidCallback onSearchPressed}) {
    return AppBar(
      title: Text('Welcome, $_username!', style: const TextStyle(fontSize: 18)),
      toolbarHeight: 80,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchPressed
        ),
        ]
    );
  }

  void _updateSearch(String query) {
    setState(() {
    _songs = _songs.where((song) => song['name'].toLowerCase().contains(query.toLowerCase())
    || song['artist'].toLowerCase().contains(query.toLowerCase())).toList();
    });
    if (query.isEmpty) {
      _songs = List.from(_filteredSongs);
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      _songs[index]['isFavorite'] = !_songs[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body:
          Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _searchActive 
                ? SearchArea(
                    onSearch: _updateSearch,
                    onClose: () => setState(() => _searchActive = false)) 
                : appBar(
                    onSearchPressed: () => setState(() => _searchActive = true),
                )
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Image(image: AssetImage('assets/images/banner.png'))
              ),
              songsItemsArea()
            ]
          ),
        )
      );
  }

  Expanded songsItemsArea() {
    if (isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _songs.length,
        itemBuilder: (BuildContext context, int index) {
          final song = _songs[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context, 
                'songs_list_item',
                arguments: {
                  'songs_list': _songs,
                  'index': index,
                  });
              FocusManager.instance.primaryFocus?.unfocus();
            },
           child:SongCard(
              index: index,
              id: song['id'],
              name: song['name'],
              artist: song['artist'],
              image: song['image'],
              album: song['album'],
              length: song['duration'],
              isFavorite: song['isFavorite'],
              onFavoriteToggle: () => _toggleFavorite(index),
            )
          );
        },
      ),
    );
  }
}
// visualización de las canciones en lista
class SongCard extends StatelessWidget {
  final int index;
  final int id;
  final String name;
  final String image;
  final String artist;
  final String album;
  final String length;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SongCard({
    super.key,
    required this.index,
    required this.id,
    required this.name,
    required this.artist,
    required this.image,
    required this.album,
    required this.length,
    required this.isFavorite,
    required this.onFavoriteToggle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect( 
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image, 
                  width: 100, 
                  height: 100, 
                  fit: BoxFit.cover, 
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(image, width: 100, height: 100, fit: BoxFit.cover);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                    Text(artist, style: const TextStyle(fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 2),
                    Text(album, overflow: TextOverflow.ellipsis, maxLines: 1),
                    Text(length),
                  ],
                ),
              ),              
              IconButton(
                icon: isFavorite
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color.fromARGB(255, 132, 50, 225), Color.fromARGB(255, 79, 98, 239)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Icon(Icons.favorite, color: Colors.white),
                  )
                : const Icon(Icons.favorite, color: Color.fromARGB(133, 171, 171, 171)),
                onPressed: onFavoriteToggle,
               ),
              ]
            ),
          ],
        ), 
    ); 
  }
}
