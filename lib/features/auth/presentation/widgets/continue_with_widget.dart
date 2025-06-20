import 'package:flutter/material.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Divider()),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Text(
              'or continue with',
              style: TextStyle(
                fontSize: isPortrait ? width * 0.04 : width * 0.02,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/app_palette.dart';
//
// class ContinueWithWidget extends StatelessWidget {
//   const ContinueWithWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Divider(),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             'or continue with',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.normal,
//               color: AppPalette.whiteColor,
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
