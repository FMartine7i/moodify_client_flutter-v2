import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_base/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/search_area.dart';

class AlbumesListScreen extends StatefulWidget {
  const AlbumesListScreen({super.key});

  @override
  State<AlbumesListScreen> createState() => _AlbumesListScreenState();
}

class _AlbumesListScreenState extends State<AlbumesListScreen> {
  bool isLoading = true;
  bool _searchActive = false;
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late SharedPreferences _prefs;
  List<Map<String, dynamic>> _albums = [];
  List<Map<String, dynamic>> _filteredAlbums = [];
  List<Map<String, dynamic>> _favAlbums = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final filter = args['filter'] ?? 'all';
      _initPrefs();
      if (filter == 'all') {
        _fetchAlbums();
      } else {
        _fetchAlbumsByMood(filter);
      }
    });
  }

  Future<void> _fetchAlbums() async {
    try {
      final response = await _apiService.fetchAlbums();
      setState(() {
        _filteredAlbums = response.cast<Map<String, dynamic>>();
        _albums = List.from(_filteredAlbums);
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching albums: $err');
    }
  }

  Future<void> _fetchAlbumsByMood(String mood) async {
    try {
      final response = await _apiService.fetchAlbumsByMood(mood);
      setState(() {
        _albums = response.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching albums by mood: $err');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavorites();
  }
  
  void _updateSearchQuery(String query) {
    setState(() {
      _albums = _albums.where((album) => album['name'].toLowerCase().contains(query.toLowerCase())
      || album['artist'].toLowerCase().contains(query.toLowerCase())).toList();
      if (query.isEmpty) {
        _albums = List.from(_filteredAlbums);
      }
    });
  }

  void _loadFavorites() {
    List<String> favAlbumsJson = _prefs.getStringList('favAlbums') ?? [];
    if (favAlbumsJson.isNotEmpty) {
      _favAlbums = favAlbumsJson.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
    }
  }

  void _toggleFavorite(int index) async {
    setState(() {
      _albums[index]['isFavorite'] = !_albums[index]['isFavorite'];
      if (_albums[index]['isFavorite']) {
        _favAlbums.add(_albums[index]);
      } else {
        _favAlbums.removeWhere((album) => album['id'] == _albums[index]['id']);
      }
      _saveFavorites();
    });
  }
  
  void _saveFavorites() {
    List<String> favAlbumsJson = _favAlbums.map((album) => jsonEncode(album)).toList();
    _prefs.setStringList('favAlbums', favAlbumsJson);
  }

  Widget appBar({required VoidCallback onSearchPressed}) {
    return AppBar(
      title: const Text('Albums', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      toolbarHeight: 80,
      actions: [
        IconButton(
        icon: const Icon(Icons.search),
        onPressed: onSearchPressed
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: _searchActive 
              ? SearchArea(
                  onSearch: _updateSearchQuery,
                  onClose: () => setState(() => _searchActive = false)) 
              : appBar(
                  onSearchPressed: () => setState(() => _searchActive = true),
              )
            ),
            albumsItemsArea()
          ]
        )
      )
    );
  }

  Expanded albumsItemsArea() {
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _albums.length,
        itemBuilder: (BuildContext context, int index) {
          final album = _albums[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'album_list_item', arguments: { 'albums_list': _albums, 'index': index });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: AlbumCard(
              index: index,
              id: album['id'],
              name: album['name'],
              artist: album['artist'],
              image: album['image'],
              releaseDate: album['release_date'],
              isFavorite: album['isFavorite'],
              onFavoriteToggle: () => _toggleFavorite(index),
            )
          );
        }
      )
    );
  }

  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class AlbumCard extends StatelessWidget {
  final int index;
  final int id;
  final String name;
  final String artist;
  final String image;
  final String releaseDate;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const AlbumCard({
    super.key,
    required this.index,
    required this.id,
    required this.name,
    required this.artist,
    required this.image,
    required this.releaseDate,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(image, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/albumes/error.jpg', width: 100, height: 100, fit: BoxFit.cover);})),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(artist),
                Text('release: $releaseDate')
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
        ],
      ),
    );
  }
}
