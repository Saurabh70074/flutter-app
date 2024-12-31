import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'schedule.dart';
import 'profile.dart';
import 'favourites.dart';
import 'video.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBB0nQp_-D8VAsREPI2OezBo6WT4BFDOQc",
            authDomain: "mussic-39ba3.firebaseapp.com",
            projectId: "mussic-39ba3",
            storageBucket: "mussic-39ba3.firebasestorage.app",
            messagingSenderId: "780881688366",
            appId: "1:780881688366:web:cf94db17de550698286cbf"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoIntroPage(),
    );
  }
}

class VideoIntroPage extends StatefulWidget {
  const VideoIntroPage({super.key});

  @override
  _VideoIntroPageState createState() => _VideoIntroPageState();
}

class _VideoIntroPageState extends State<VideoIntroPage> {
  bool showLogo = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showLogo = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SongPlayerPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: showLogo ? 1.0 : 0.0,
          duration: const Duration(seconds: 1),
          child: Image.asset('assets/logo.png', width: 600),
        ),
      ),
    );
  }
}

class SongPlayerPage extends StatefulWidget {
  const SongPlayerPage({super.key});

  @override
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool isCommentBoxVisible = false;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool isLiked = false;

  void _postComment(String comment) async {
    if (comment.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment posted successfully!")),
      );

      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post comment: $e")),
      );
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLiked ? "You liked this song" : "You unliked this"),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.setAsset('assets/song.mp3');

    _scrollController.addListener(() {
      setState(() {
        isCommentBoxVisible = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoPage()),
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

  final List<Map<String, String>> artists = [
    {"name": "Diljit Dosanjh", "image": "assets/dilj.jpg"},
    {"name": "Harshdeep Kaur Jawanda", "image": "assets/hk.jpg"},
    {"name": "Jordan Sandhu", "image": "assets/jordan.jpg"},
    {"name": "Kanika Kapoor", "image": "assets/knika.jpg"},
    {"name": "Neha Kakkar", "image": "assets/nk.jpg"},
    {"name": "Shankar Mahadevan", "image": "assets/shm.jpg"},
    {"name": "Sunanda Sharma", "image": "assets/sush.png"},
    {"name": "Amrinder Gill", "image": "assets/amg.webp"},
    {"name": "Babbu Maan", "image": "assets/bu.jpg"},
    {"name": "Sidhu Moosewala", "image": "assets/sdu.webp"},
    {"name": "AP Dhillon", "image": "assets/app.jpeg"},
    {"name": "Guru Randhawa", "image": "assets/gru.jpg"},
    {"name": "Yo Yo Honey Singh", "image": "assets/hny.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 0, 39),
      appBar: AppBar(
        title: const Text("Radio Bollywood Beats"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 0, 39),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Container(
            width: screenSize.width > 600 ? 600 : double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: artists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.yellow,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.purple,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage(artists[index]["image"]!),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                artists[index]["name"]!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/bhul.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage('assets/ka.jpg'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bhool Bhulaiyaa Title Track",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Neeraj Shridhar",
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite,
                                color: isLiked ? Colors.red : Colors.white),
                            onPressed: _toggleLike,
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.comment, color: Colors.white),
                            onPressed: () {
                              _commentFocusNode.requestFocus();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              print("Share button clicked");
                            },
                          ),
                        ],
                      ),
                      StreamBuilder<Duration>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration =
                              _audioPlayer.duration ?? Duration.zero;
                          return Column(
                            children: [
                              Slider(
                                value: position.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _audioPlayer.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.black],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          suffixIconColor: Colors.white,
                          hintText: "Write a comment...",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              String comment = _commentController.text;
                              _postComment(comment);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Comments:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final comments = snapshot.data!.docs;

                          if (comments.isEmpty) {
                            return const Text(
                              "No comments yet. Be the first to comment!",
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              var commentData = comments[index];
                              var commentText =
                                  commentData['comment'] as String? ?? '';
                              var timestamp =
                                  commentData['timestamp'] as Timestamp?;
                              var formattedTime = timestamp != null
                                  ? timestamp.toDate().toLocal().toString()
                                  : "Unknown time";

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.comment,
                                        color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            commentText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            formattedTime,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 26, 0, 39),
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
    );
  }
}
