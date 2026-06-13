import '../../domain/entities/experience.dart';

class ExperienceModel extends Experience {
  const ExperienceModel({
    required super.title,
    required super.company,
    required super.period,
    required super.location,
    required super.responsibilities,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'] as String,
      company: json['company'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      responsibilities: List<String>.from(json['responsibilities'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'period': period,
      'location': location,
      'responsibilities': responsibilities,
    };
  }
}
