import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/song_slide.dart';
import '../services/api_service.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String _username = "user";
  dynamic _profilePic;
  String? assetImage;
  String? _selectedMood;
  List<Map<String, dynamic>> _songs = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Calling _fetchSongs...');
      _fetchSongs();
      _loadUserData();
    });
  }
  
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState((){
      _username = prefs.getString('username') ?? '';
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null){
        if (imagePath.startsWith('assets/')) {
          assetImage = imagePath;
        } else {
          _profilePic = File(imagePath);
        }
      }
    });
  }
  
  Future<void> _fetchSongs() async {
    try {
      final response = await _apiService.fetchSongs();
      print('Songs fetched: $response');
      setState(() {
        _songs = response.cast<Map<String, dynamic>>();
      });
    } catch (err) {
      print('Error fetching songs: $err');
    }
  }

  void _onSongTap(int index) {
    Navigator.pushNamed(context, 'songs_list', arguments: {'index': index});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('welcome to moodify!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(' hi, $_username!', style: const TextStyle(fontSize: 16))
                ],
              ),
              const Spacer(),
              CircleAvatar(
                backgroundImage: _profilePic != null ? FileImage(_profilePic) : AssetImage(assetImage!),
                radius: 25,
              )
            ]
          )
        ),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: ShaderMask(shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 139, 44, 191), Color.fromARGB(255, 30, 152, 245)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                    ).createShader(bounds),
                    child: const Text('now trending', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white), textAlign: TextAlign.start),
                )
              ),      
              _songs.isEmpty ? const Center(child: CircularProgressIndicator())
              : SongSlide(songs: _songs, onSongTap: _onSongTap),
              const SizedBox(height: 40),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color.fromARGB(255, 139, 44, 191), Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight 
                  ).createShader(bounds),
                  child: const Text('Listen to music according to your mood!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))
                ),
              const SizedBox(height: 20),
              const Text('discover songs based on your mood and emotions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const Text('Select your mood and let the music play!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              ShaderMask(shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color.fromARGB(255, 139, 44, 191), Colors.blueAccent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
                  ).createShader(bounds),
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(color: Color.fromARGB(255, 108, 192, 228), width: 2)
                  ),
                  onPressed: () {
                    _showMoodDialog(context);
                  },
                  child: const Text('Get started', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))
                )
              ),
            ]
          )
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/gradient.png', fit: BoxFit.cover),
            )
          )
        ]
      )
    );
  }

  void _showMoodDialog(BuildContext context) {
    final moods = [
      {'name': 'relaxed'},
      {'name': 'happy'},
      {'name': 'sad'},
      {'name': 'angry'},
      {'name': 'badass'},
      {'name': 'romantic'},
      {'name': 'epic'},
    ];
    
    showModalBottomSheet(
      context: context, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [ 
              const Text('select your mood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox( height: 16 ),
              ...moods.map((mood) {
                final isSelected = _selectedMood  == mood['name'];
                return ListTile(
                  leading: Icon( isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: const Color.fromARGB(255, 101, 56, 191)),
                  title: Text(mood['name']!),
                  onTap: () {
                    Navigator.pushNamed(context, 'songs_list', arguments: { 'filter': mood['name'] });
                    if (mounted) {
                    setState(() {
                        _selectedMood = mood['name'];
                      });
                    }
                    _filterByMood(mood['name']!);
                  }
                );
              }
            )]
          )
        );
      }
    );
  }

  void _filterByMood(String mood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filtering by mood: $mood'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}