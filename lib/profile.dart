import 'package:flutter/material.dart';
import 'schedule.dart';
import 'main.dart';
import 'favourites.dart';
import 'video.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SongPlayerPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FavouritesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 0, 39),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text("Radio Bollywood Beats"),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 0, 39),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: screenSize.width > 600 ? 600 : double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.white),
                    title: const Text(
                      "Provide Feedback",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.white),
                    title: const Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.cookie, color: Colors.white),
                    title: const Text(
                      "Cookie Policy",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text(
                      "Privacy Manager",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.gavel, color: Colors.white),
                    title: const Text(
                      "3rd Party License Agreement",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 200,
                      width: 300,
                      fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Radio Bollywood Beats © 2024 All Rights Reserved.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
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
