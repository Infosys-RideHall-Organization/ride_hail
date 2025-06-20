import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String backendUrl = dotenv.env['BACKEND_URL']!;
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String jwtKey = 'JWT_TOKEN_KEY';
  static final String userIdKey = 'USER_ID_KEY';
  static final String playerIdKey = 'PLAYER_ID_KEY';
  static final String mapKey = dotenv.env['GOOGLE_MAPS_SDK_API_KEY']!;
  static final String oneSignalAppId = dotenv.env['ONE_SIGNAL_APP_ID']!;
}
