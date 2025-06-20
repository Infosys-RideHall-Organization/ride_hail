import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/campus/campus_model.dart';

abstract interface class CampusRemoteDataSource {
  Future<List<CampusModel>> fetchCampuses();
}

class CampusRemoteDataSourceImpl implements CampusRemoteDataSource {
  @override
  Future<List<CampusModel>> fetchCampuses() async {
    final response = await http.get(
      Uri.parse('${Constants.backendUrl}/campus'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List campusesList = decoded['campuses'];

      return campusesList
          .map((item) => CampusModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(message: 'Failed to load campuses');
    }
  }
}
