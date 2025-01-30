import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://moodify-v2-1afv.onrender.com/api/v2';
  // ============================== fetch SONGS ==============================
  Future<List<dynamic>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch songs');
    }
  }

  Future<List<dynamic>> fetchSongByMood(String mood) async {
    final response = await http.get(Uri.parse('$baseUrl/songs/mood?=$mood'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch songs by mood');
    }
  }

  Future<Map<String, dynamic>> fetchSongDetails(int songId) async {
    final response = await http.get(Uri.parse('$baseUrl/songs/$songId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch song details');
    }
  }
  
  // ============================= fetch Albums ==================================
  Future<List<dynamic>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch albums');
    }
  }

  Future<Map<String, dynamic>> fetchAlbumDetails(int albumId) async {
    final response = await http.get(Uri.parse('$baseUrl/albums/$albumId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch album details');
    }
  }

  // ============================= fetch users ==================================
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch users.');
    }
  }

  Future<Map<String, dynamic>> compareUserDetails(String username, String password) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/users/login/$username'),
        headers: { 'Content-Type': 'application/json' },
        body: json.encode({ 'password': password })
      );

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to fetch user details.');
    }
  }

  Future<Map<String, dynamic>> createUser(String username,String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password
      }),
      headers: {'Content-Type': 'application/json'}
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user. Status code: Status code: ${response.statusCode}. Response: ${response.body}');
    }
  }
}
