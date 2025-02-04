import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';
import '../services/api_service.dart'; 

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({super.key});
  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final ApiService _apiService = ApiService();
  late Map<String, dynamic> currentAlbum = {};
  bool isLoading = true;
  
  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final albumId = args['id'];
    if (albumId != null) {
      _fetchAlbumDetails(albumId);
    }
  }

  Future<void> _fetchAlbumDetails(int albumId) async {
    try {
      final albumDetails = await _apiService.fetchAlbumDetails(albumId);
      setState(() {
        currentAlbum = albumDetails;
        isLoading = false;
      });
    } catch (err) {
      print('Error fetching album details: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 65,
      ),
      endDrawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    currentAlbum['image'],
                    fit: BoxFit.cover,
                  ),
                )
              ),
              const SizedBox(height: 20),
              Text(
                "${currentAlbum['name']}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "${currentAlbum['artist']}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text("Release: ${currentAlbum['release_date']}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

