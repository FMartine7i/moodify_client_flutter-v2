import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://moodify-v2-1afv.onrender.com/api/v2';
  // ============================== SONGS ==============================
  Future<List<dynamic>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch songs');
    }
  }

  Future<List<dynamic>> fetchSongsByMood(String mood) async {
    final response = await http.get(Uri.parse('$baseUrl/songs?mood=$mood'));
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
  
  // ============================= ALBUMS ==================================
  Future<List<dynamic>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch albums');
    }
  }

  Future<List<dynamic>> fetchAlbumsByMood(String mood) async {
    final response = await http.get(Uri.parse('$baseUrl/albums?mood=$mood'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch albums by mood');
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

  // ============================= USERS ==================================
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
      return json.decode(response.body);
    } else {
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

  Future<Map<String, dynamic>> updateUsername(int userId, String newUsername) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      body: json.encode({ 'username': newUsername }),
      headers: {'Content-Type': 'application/json'}
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update username. Status code: ${response.statusCode}. Response: ${response.body}');
    }
  }
}
