// lib/data/models/experience_model.dart

import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String imageUrl;
  final String iconUrl;
  final bool isSelected;
  final String? customText;

  const Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
    this.isSelected = false,
    this.customText,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      iconUrl: json['icon_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'is_selected': isSelected,
      'custom_text': customText,
    };
  }

  Experience copyWith({
    int? id,
    String? name,
    String? tagline,
    String? description,
    String? imageUrl,
    String? iconUrl,
    bool? isSelected,
    String? customText,
  }) {
    return Experience(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      isSelected: isSelected ?? this.isSelected,
      customText: customText ?? this.customText,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        tagline,
        description,
        imageUrl,
        iconUrl,
        isSelected,
        customText,
      ];

  @override
  String toString() {
    return 'Experience(id: $id, name: $name, isSelected: $isSelected, customText: $customText)';
  }
}