// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_application_base/mocks/playlists_mock.dart'
    show elements;
import 'playlists_list_item.dart';

class PlaylistsListScreen extends StatefulWidget {
  const PlaylistsListScreen({super.key});
  @override
  PlaylistsListScreenState createState() => PlaylistsListScreenState();
}

class PlaylistsListScreenState extends State<PlaylistsListScreen> {
  String _searchQuery = '';
  List<List<dynamic>> _filteredElements = elements.cast<List<dynamic>>();

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredElements = elements
          .where((playlist) =>
              playlist[1]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              playlist[2]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList()
          .cast<List<dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            hintText: 'search...',
            isDense: true,
            filled: true,
            fillColor: Colors.transparent, 
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(  
              borderSide: BorderSide(
              color: Color.fromARGB(255, 151, 13, 225),
              width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
              ),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _updateSearchQuery,
        )
      ),
      body: ListView.builder(
        itemCount: _filteredElements.length,
        itemBuilder: (context, index) {
          final playlist = _filteredElements[index];
          return GestureDetector(
            onTap: () async {
              //ir a la pantalla de visualizacion individual
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistListItem(
                    index: index,
                    playlist: {
                      'id': playlist[0],
                      'playlistName': playlist[1],
                      'artists': playlist[2],
                      'description': playlist[3],
                    },
                  ),
                ),
              );
              setState(() {});
            },
            child: PlaylistCard(
              index: index,
              id: playlist[0],
              playlistName: playlist[1],
              artists: playlist[2],
              description: playlist[3],
            ),
          );
        },
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final int index;
  final String id;
  final String playlistName;
  final String artists;
  final String description;

  const PlaylistCard({
    super.key,
    required this.index,
    required this.id,
    required this.playlistName,
    required this.artists,
    required this.description,
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
                child: Image.asset(
                  'assets/playlists/$id.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/album.png', width: 100, height: 100, fit: BoxFit.cover);
                  },
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlistName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(artists),
                  ],
                )
              ),
            ]
          ),
        ],
      )
    );
  }
}
