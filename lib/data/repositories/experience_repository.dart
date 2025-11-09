// experience_repository.dart
import 'package:flutter_application_1/data/models/api_response_model.dart';
import 'package:flutter_application_1/data/models/experience_model.dart';
import 'package:flutter_application_1/data/services/api_service.dart';

class ExperienceRepository {
  final ApiService _apiService;

  ExperienceRepository(this._apiService);

  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _apiService.get(
        '/v1/experiences',
        queryParameters: {'active': 'true'},
      );

      final apiResponse = ApiResponse.fromJson(response.data);
      return apiResponse.data.experiences;
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }
}
