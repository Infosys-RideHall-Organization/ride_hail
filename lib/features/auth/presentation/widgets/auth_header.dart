import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Center(
      child: Text(
        header,
        style: TextStyle(
          fontSize: isPortrait ? width * 0.070 : width * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
