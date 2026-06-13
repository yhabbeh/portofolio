import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.name,
    required super.description,
    required super.technologies,
    required super.githubUrl,
    required super.stars,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['github_url'] as String,
      stars: json['stars'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'github_url': githubUrl,
      'stars': stars,
    };
  }
}

class ProjectCategoryModel extends ProjectCategory {
  const ProjectCategoryModel({
    required super.title,
    required List<ProjectModel> super.projects,
  });

  factory ProjectCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProjectCategoryModel(
      title: json['title'] as String,
      projects: (json['projects'] as List)
          .map((p) => ProjectModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'projects': projects.map((p) => (p as ProjectModel).toJson()).toList(),
    };
  }
}
