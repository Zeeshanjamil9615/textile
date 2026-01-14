import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  
  const CustomAppBar({Key? key, required this.onMenuPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF4A9B9B),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuPressed,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.analytics_outlined, color: Colors.amber, size: 24),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('TEXTILE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                Text('ANALYTICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber, height: 1.1)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // const Icon(Icons.flag, color: Colors.white, size: 20),
        IconButton(icon: const Icon(Icons.grid_view, color: Colors.white), onPressed: () {}),
        // IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.white), onPressed: () {}),
        // IconButton(icon: const Icon(Icons.dark_mode, color: Colors.white), onPressed: () {}),
        Stack(
          children: [
            IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
            Positioned(
              right: 8, top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}