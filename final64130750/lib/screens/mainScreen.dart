import 'package:flutter/material.dart';
import 'package:final_app/screens/aboutScreen.dart';
import 'package:final_app/screens/showlistScreen.dart';
import 'package:final_app/screens/catalogsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CatalogsScreen(),
    ListScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Booking'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.car_rental_outlined),
                label: 'Catalogs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Edit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xff53B175),
            unselectedItemColor: Color(0xff7C7C7C),
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }
}
