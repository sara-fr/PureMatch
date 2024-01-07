import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Bottom navigation menu items (icons)
List<BottomNavigationBarItem> menuItems() {
  return [
    BottomNavigationBarItem(
      icon: Image.asset('assets/icon/users.png'),
      activeIcon: Image.asset('assets/icon/users.png'),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icon/burger.png'),
      activeIcon: Image.asset('assets/icon/burger.png'),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icon/chat.png'),
      activeIcon: Image.asset('assets/icon/chat.png'),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icon/Group 3.png'),
      activeIcon: Image.asset('assets/icon/Group 3.png'),
      label: '',
    ),
  ];
}