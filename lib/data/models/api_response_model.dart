// api_response_model.dart
import 'package:flutter_application_1/data/models/experience_model.dart';

class ApiResponse {
  final String message;
  final ApiData data;

  ApiResponse({
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String,
      data: ApiData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ApiData {
  final List<Experience> experiences;

  ApiData({required this.experiences});

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      experiences: (json['experiences'] as List)
          .map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}