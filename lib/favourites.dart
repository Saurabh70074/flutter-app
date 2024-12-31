import 'package:flutter/material.dart';
import 'schedule.dart'; 
import 'main.dart'; 
import 'profile.dart'; 
import 'video.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  int _selectedIndex = 3; // Set 'Favourites' as the active tab
final List<String> favouriteThumbnails = [
    'assets/stree.jpg',
    'assets/nat.jpg',
    'assets/million.jpg',
    'assets/peg.jpg',
    'assets/rt.jpg',
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to other pages
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SongPlayerPage()), // Home Page
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } else if (index == 2) {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VideoPage()), // Navigate to the VideoPage
    );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 0, 39),
      appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 26, 0, 39),
  foregroundColor: Colors.white,
  title: Center(
    child: Container(
      width: screenSize.width > 600 ? 600 : screenSize.width,
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

      body: Center(
        child: Container(
          width: screenSize.width > 600 ? 600 : double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "FAVOURITES: ❤️",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Music expresses that which cannot be put into words and that which cannot remain silent.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2, // Make the boxes square
                  ),
                  itemCount: favouriteThumbnails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        image: DecorationImage(
                          image: AssetImage(favouriteThumbnails[index]),
                          fit: BoxFit.cover,
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
