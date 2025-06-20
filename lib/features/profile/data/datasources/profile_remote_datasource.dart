import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:ride_hail/features/profile/data/models/profile_model.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({
    required String token,
    required String userId,
  });
  Future<ProfileModel> updateProfile({
    required String token,
    required String userId,
    required String name,
    required String gender,
    required File? imageFile,
  });

  Future<ProfileModel> deleteProfile({
    required String token,
    required String userId,
  });

  Future<ProfileModel> updatePlayerId({
    required String playerId,
    required String userId,
  });
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.backendUrl}/profile/$userId'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.body);
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String token,
    required String userId,
    required String name,
    required String gender,
    required File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('${Constants.backendUrl}/profile/$userId');
      final request = http.MultipartRequest('PUT', uri);
      request.headers['x-auth-token'] = token;

      // Add text fields
      request.fields['name'] = name;
      request.fields['gender'] = gender;

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();

        // Add Image
        request.files.add(
          http.MultipartFile(
            'image',
            fileStream,
            fileLength,
            filename: imageFile.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        debugPrint('success');
        return ProfileModel.fromJson(responseBody);
      } else {
        throw ServerException(message: jsonDecode(responseBody)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProfileModel> deleteProfile({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.backendUrl}/profile/$userId'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint('Delete success');
        return ProfileModel.fromJson(response.body);
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProfileModel> updatePlayerId({
    required String playerId,
    required String userId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.backendUrl}/profile/update-player-id/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"playerId": playerId}),
      );

      debugPrint("Profile ID update = ${response.body}");

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.body);
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
