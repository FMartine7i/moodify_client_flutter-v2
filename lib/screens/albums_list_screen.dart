import 'package:flutter/material.dart';
import 'package:flutter_application_base/mocks/albumes_mock.dart' show elementos;
import 'package:flutter_application_base/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumesListScreen extends StatefulWidget {
  const AlbumesListScreen({super.key});

  @override
  State<AlbumesListScreen> createState() => _AlbumesListScreenState();
}

class _AlbumesListScreenState extends State<AlbumesListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _albums = [];

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    try {
      final albums = await _apiService.fetchAlbums();
      setState(() {
        _albums = albums;
      });
    } catch (err) {
      print('Error fetching albums: $err');
    }
  }
  
  void _updateSearchQuery(String query) {
    setState(() {
      _albums = _albums.where((album) => album['name'].toLowerCase().contains(query).toLowerCase()).toList().cast<List<dynamic>>();
    });
  }

  void _toggleFavorite(int index) async {
    setState(() {
      _albums[index]['isFavorite'] = !_albums[index]['isFavorite'];
    });
    final prefs = await SharedPreferences.getInstance();
    final favoriteAlbums = elementos
      .where((album) => album['isFavorite']) // Solo los favoritos
      .map((album) => album['id'].toString()) // Guardar el id del álbum
      .toList();
    await prefs.setStringList('favoriteAlbums', favoriteAlbums);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            isDense: true,
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
            focusedBorder: UnderlineInputBorder(  
              borderSide: BorderSide(
              color: Color.fromARGB(255, 103, 5, 208),
              width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
              ),
            ),
          ),
          onChanged: _updateSearchQuery
        ),
      ),
      body: ListView.builder(
        itemCount: _albums.length,
        itemBuilder: (BuildContext context, int index) {
          final album = _albums[index];
          return GestureDetector(
            onTap: () {
              //ir a la pantalla de visualizacion individual
              Navigator.pushNamed(
                context, 
                'album_item',
                arguments: <String, dynamic>{
                  'id': album['id'],
                  'name': album['name'],
                  'artist': album['artist'],
                  'release_Date': album['release_date'],
                  'isFavorite': album['isFavorite'],
                });
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
            ),
          );
        },
      ),
    );
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
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? const Color.fromARGB(255, 152, 17, 230)
                    : Colors.grey),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
