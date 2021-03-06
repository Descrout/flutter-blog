import 'package:flutter/material.dart';
import 'package:flutter_blog/views/routes.dart';

class BottomNav extends StatelessWidget {
  final String currentPage;
  final int _currentIndex;
  final VoidCallback onSamePage;

  BottomNav({Key key, @required this.currentPage, @required this.onSamePage})
      : _currentIndex = Routes.KEYNAMES.indexOf(currentPage),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) {
          if (index == _currentIndex) {
            onSamePage();
            return;
          }
          final route = Routes.KEYNAMES[index];
          Navigator.of(context).pushReplacementNamed(route);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page), label: "Contact"),
        ]);
  }
}
