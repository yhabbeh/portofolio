import '../../domain/entities/portfolio_data.dart';
import 'experience_model.dart';
import 'project_model.dart';
import 'skill_model.dart';

class PortfolioDataModel extends PortfolioData {
  const PortfolioDataModel({
    required super.name,
    required super.location,
    required super.email,
    required super.phone,
    required super.linkedinUrl,
    required super.githubUrl,
    required super.cvAsset,
    required super.profileImage,
    required super.heroHeadline,
    required super.heroSubtitle,
    required super.aboutDescription,
    required super.aboutHighlights,
    required List<ExperienceModel> super.experiences,
    required List<SkillCategoryModel> super.skillCategories,
    required List<ProjectCategoryModel> super.projectCategories,
    required super.certificationTitle,
    required super.awardTitle,
  });

  factory PortfolioDataModel.fromJson(Map<String, dynamic> json) {
    return PortfolioDataModel(
      name: json['name'] as String,
      location: json['location'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      linkedinUrl: json['linkedin_url'] as String,
      githubUrl: json['github_url'] as String,
      cvAsset: json['cv_asset'] as String,
      profileImage: json['profile_image'] as String,
      heroHeadline: json['hero_headline'] as String,
      heroSubtitle: json['hero_subtitle'] as String,
      aboutDescription: json['about_description'] as String,
      aboutHighlights: List<String>.from(json['about_highlights'] as List),
      experiences: (json['experiences'] as List)
          .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skillCategories: (json['skill_categories'] as List)
          .map((s) => SkillCategoryModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      projectCategories: (json['project_categories'] as List)
          .map((p) => ProjectCategoryModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      certificationTitle: json['certification_title'] as String,
      awardTitle: json['award_title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'email': email,
      'phone': phone,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'cv_asset': cvAsset,
      'profile_image': profileImage,
      'hero_headline': heroHeadline,
      'hero_subtitle': heroSubtitle,
      'about_description': aboutDescription,
      'about_highlights': aboutHighlights,
      'experiences': experiences.map((e) => (e as ExperienceModel).toJson()).toList(),
      'skill_categories': skillCategories.map((s) => (s as SkillCategoryModel).toJson()).toList(),
      'project_categories': projectCategories.map((p) => (p as ProjectCategoryModel).toJson()).toList(),
      'certification_title': certificationTitle,
      'award_title': awardTitle,
    };
  }
}
