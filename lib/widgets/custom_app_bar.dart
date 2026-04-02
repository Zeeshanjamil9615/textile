import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/profile/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;

  /// When set (e.g. detail screens), shown instead of the default TEXTILE ANALYTICS branding.
  final String? title;

  /// If true, shows a back arrow instead of the menu icon.
  final bool showBack;

  /// Optional custom back action. Defaults to `Get.back()`.
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    this.onMenuPressed,
    this.title,
    this.showBack = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useDetailTitle = title != null && title!.trim().isNotEmpty;

    return AppBar(
      backgroundColor: const Color(0xFF4A9B9B),
      elevation: 0,
      leading: IconButton(
        icon: Icon(showBack ? Icons.arrow_back : Icons.menu, color: Colors.white),
        onPressed: showBack
            ? (onBackPressed ?? () => Get.back())
            : (onMenuPressed ?? () {}),
      ),
      title: useDetailTitle
          ? Text(
              title!.trim(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                letterSpacing: 0.6,
              ),
            )
          : Row(
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
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Get.to(() => const ProfilePage());
          },
        ),
        // IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.white), onPressed: () {}),
        // IconButton(icon: const Icon(Icons.dark_mode, color: Colors.white), onPressed: () {}),
       
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}