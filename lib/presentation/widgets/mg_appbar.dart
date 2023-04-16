import 'package:flutter/material.dart';

class MGAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Size size;
  final String title;

  const MGAppbar({
    Key? key,
    required this.title,
    this.size = const Size.fromHeight(60),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => size;
}
