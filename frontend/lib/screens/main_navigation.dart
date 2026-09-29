import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';

/// Main navigation shell dengan bottom navigation bar
class MainNavigation extends StatefulWidget {
  final Widget child;
  final String location;

  const MainNavigation({Key? key, required this.child, required this.location})
    : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _getIndexFromLocation(widget.location);
  }

  @override
  void didUpdateWidget(MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _selectedIndex = _getIndexFromLocation(widget.location);
    }
  }

  int _getIndexFromLocation(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/journal')) return 2;
    if (location.startsWith('/bisindo')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chat');
        break;
      case 2:
        context.go('/journal');
        break;
      case 3:
        context.go('/bisindo');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          height: 72,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          indicatorColor: TaraColors.blue.withValues(alpha: 0.14),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
              tooltip: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'TARA AI',
              tooltip: 'Percakapan dengan TARA',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Jurnal',
              tooltip: 'Jurnal dan perkembangan',
            ),
            NavigationDestination(
              icon: Icon(Icons.sign_language_outlined),
              selectedIcon: Icon(Icons.sign_language),
              label: 'BISINDO',
              tooltip: 'Kamus video BISINDO',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
              tooltip: 'Profil dan pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}
