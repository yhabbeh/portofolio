class ProjectModel {
  final String name;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final int stars;

  const ProjectModel({
    required this.name,
    required this.description,
    required this.technologies,
    required this.githubUrl,
    this.stars = 0,
  });
}

class ProjectCategory {
  final String title;
  final List<ProjectModel> projects;

  const ProjectCategory({required this.title, required this.projects});
}
