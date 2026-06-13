import 'package:equatable/equatable.dart';

class SkillCategory extends Equatable {
  final String title;
  final List<String> skills;

  const SkillCategory({
    required this.title,
    required this.skills,
  });

  @override
  List<Object?> get props => [title, skills];
}
