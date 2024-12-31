import 'package:flutter/material.dart';
import 'profile.dart';
import 'main.dart';
import 'favourites.dart';
import 'video.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedIndex = 1;
  int _selectedDayIndex = 0;
  int _selectedShowTypeIndex = 0;

  // List of days
  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  // Sample schedule data
  final Map<String, List<Map<String, String>>> schedule = {
    "Sunday": [
      {"time": "9:00 AM", "show": "Morning Melodies"},
      {"time": "12:00 PM", "show": "Lunchtime Beats"},
      {"time": "3:00 PM", "show": "Afternoon Vibes"},
      {"time": "6:00 PM", "show": "Evening Chill"},
    ],
    "Monday": [
      {"time": "10:00 AM", "show": "Top Hits"},
      {"time": "2:00 PM", "show": "Siesta Sounds"},
      {"time": "5:00 PM", "show": "Golden Hour"},
    ],
    // Add data for other days...
  };

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation to other pages
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SongPlayerPage()), // Home Page
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const VideoPage()), // Navigate to the VideoPage
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 0, 39),
      appBar: AppBar(
        title: const Text("Radio Bollywood Beats"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 0, 39),
        foregroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenSize.width > 600 ? 600 : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Toggle buttons for "Show Schedule" and "Popular Shows"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedShowTypeIndex = 0; // "Show Schedule"
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedShowTypeIndex == 0
                              ? const Color.fromARGB(
                                  255, 209, 190, 190) // Selected state color
                              : Colors.transparent, // Unselected state
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            "Show Schedule",
                            style: TextStyle(
                              color: _selectedShowTypeIndex == 0
                                  ? const Color.fromARGB(
                                      255, 26, 0, 39) // Selected text color
                                  : Colors.white, // Unselected text color
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedShowTypeIndex = 1; // "Popular Shows"
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedShowTypeIndex == 1
                              ? const Color.fromARGB(
                                  255, 209, 190, 190) // Selected state color
                              : Colors.transparent, // Unselected state
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            "Popular Shows",
                            style: TextStyle(
                              color: _selectedShowTypeIndex == 1
                                  ? const Color.fromARGB(255, 26, 0, 39)
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Horizontal list of days
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index; // Update the selected day
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedDayIndex == index
                              ? const Color.fromARGB(255, 209, 190, 190)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: _selectedDayIndex == index
                                  ? const Color.fromARGB(255, 26, 0, 39)
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Display shows based on the selected day and show type
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: schedule[days[_selectedDayIndex]]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = schedule[days[_selectedDayIndex]]![index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 179, 18, 125),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item["time"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["show"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
