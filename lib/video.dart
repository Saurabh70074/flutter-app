import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'services/api_service.dart';
import 'models/video_model.dart';
import 'schedule.dart';
import 'profile.dart';
import 'favourites.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Video> _videos = [];
  YoutubePlayerController? _playerController;
  bool _isLoading = true;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavouritesPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  void _fetchVideos() async {
    try {
      const playlistId = "PL2ZuPzC06fL3IxwivCpqgHu9UblebIkit";
      List<Video> videos = await APIService.instance.fetchVideosFromPlaylist(
        playlistId: playlistId,
      );

      setState(() {
        _videos = videos;
        _isLoading = false;

        if (_videos.isNotEmpty) {
          _initializePlayer(_videos[0].id);
        }
      });
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }

  void _initializePlayer(String videoId) {
    _playerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = screenSize.width > 600 ? 600.0 : screenSize.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0027),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0027),
        foregroundColor: Colors.white,
        title: Center(
          child: Container(
            width: containerWidth,
            alignment: Alignment.center,
            child: const Text(
              "Radio Bollywood Beats",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A0027),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_outlined),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: containerWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "OUR PODCASTS🎧",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Listen to the best podcasts of Bollywood & more on Radio Bollywood Beats!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_playerController != null)
                YoutubePlayer(
                  controller: _playerController!,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print("Player is ready.");
                  },
                ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          Video video = _videos[index];
                          return GestureDetector(
                            onTap: () {
                              _initializePlayer(video.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        video.thumbnailUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      const Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      video.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
