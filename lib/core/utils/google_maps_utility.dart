import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsUtility {
 static Future<BitmapDescriptor> getBytesFromAsset(String path, width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    final imageData = await fi.image.toByteData(format: ImageByteFormat.png);
    final image = imageData?.buffer.asUint8List();
    return BitmapDescriptor.bytes(image!);
  }
}
