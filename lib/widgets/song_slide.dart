import 'package:flutter/material.dart';

import 'dart:math';

class SongSlide extends StatelessWidget {
  final List<Map<String, dynamic>> songs;
  final Function onSongTap;
  const SongSlide({ super.key, required this.songs, required this.onSongTap });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    List<Map<String, dynamic>> shuffledSongs = shuffleSongs(songs);
    return SizedBox(
      height: 250,
      child: shuffledSongs.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: shuffledSongs.length,
          itemBuilder: (context, index) {
            final song = shuffledSongs[index];
            return GestureDetector(
              onTap: () => onSongTap(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:  const [
                    BoxShadow(
                      color: Color.fromARGB(116, 25, 25, 26),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                width: 170,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDarkTheme ? const Color.fromARGB(255, 27, 27, 28) : Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(song['image'], width: MediaQuery.of(context).size.width, height: 150, fit: BoxFit.cover)
                      ),
                      const SizedBox(height: 20),
                      Text(song['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                      Text(song['artist'], style: const TextStyle(color: Color.fromARGB(162, 150, 150, 150)), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ],
                  ),
                )
              ),
            );
          },
        )
    );
  }

  List<Map<String, dynamic>> shuffleSongs(List<Map<String, dynamic>> songs) {
    if (songs.length <= 10) { return List.from(songs); }
    List<Map<String, dynamic>> shuffledSongs = List.from(songs);
    shuffledSongs.shuffle(Random());
    return shuffledSongs.take(10).toList();
  }
}