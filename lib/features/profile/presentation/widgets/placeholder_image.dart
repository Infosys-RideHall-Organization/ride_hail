import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      color: AppPalette.greyColor.withAlpha(100),
      child: Center(child: Icon(Icons.person, size: 120)),
    );
  }
}
