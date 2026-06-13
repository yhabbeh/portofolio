import '../../domain/entities/skill.dart';

class SkillCategoryModel extends SkillCategory {
  const SkillCategoryModel({
    required super.title,
    required super.skills,
  });

  factory SkillCategoryModel.fromJson(Map<String, dynamic> json) {
    return SkillCategoryModel(
      title: json['title'] as String,
      skills: List<String>.from(json['skills'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'skills': skills,
    };
  }
}
