import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';

/// Main navigation shell dengan bottom navigation bar
class MainNavigation extends StatefulWidget {
  final Widget child;
  final String location;

  const MainNavigation({
    Key? key,
    required this.child,
    required this.location,
  }) : super(key: key);

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
    const items = [
      (Icons.home_outlined, Icons.home, 'Beranda'),
      (Icons.smart_toy_outlined, Icons.smart_toy, 'TARA AI'),
      (Icons.menu_book_outlined, Icons.menu_book, 'Jurnal'),
      (Icons.pan_tool_outlined, Icons.pan_tool, 'BISINDO'),
      (Icons.person_outline, Icons.person, 'Profil'),
    ];
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: TaraColors.divider)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = index == _selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 76, minHeight: 64),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected ? TaraColors.blue.withOpacity(0.16) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(selected ? item.$2 : item.$1, color: selected ? TaraColors.blue : TaraColors.textMuted, size: 27),
                          const SizedBox(height: 3),
                          Text(item.$3, overflow: TextOverflow.ellipsis, style: TextStyle(color: selected ? TaraColors.blue : TaraColors.textMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
