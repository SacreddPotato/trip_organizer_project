import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(Icons.explore),
      title: Text(
        'Voyage',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [IconButton(icon: Icon(Icons.notifications), onPressed: () {})],
      titleSpacing: 0,
    );
  }
}
