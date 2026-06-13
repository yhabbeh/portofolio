import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String name;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final String googlePlayUrl;
  final int stars;

  const Project({
    required this.name,
    required this.description,
    required this.technologies,
    this.githubUrl = '',
    this.googlePlayUrl = '',
    required this.stars,
  });

  @override
  List<Object?> get props =>
      [name, description, technologies, githubUrl, googlePlayUrl, stars];
}

class ProjectCategory extends Equatable {
  final String title;
  final List<Project> projects;

  const ProjectCategory({
    required this.title,
    required this.projects,
  });

  @override
  List<Object?> get props => [title, projects];
}
