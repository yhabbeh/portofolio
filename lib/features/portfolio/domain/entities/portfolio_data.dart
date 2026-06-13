import 'package:equatable/equatable.dart';

import 'experience.dart';
import 'project.dart';
import 'skill.dart';

class PortfolioData extends Equatable {
  final String name;
  final String location;
  final String email;
  final String phone;
  final String linkedinUrl;
  final String githubUrl;
  final String cvAsset;
  final String profileImage;
  final String heroHeadline;
  final String heroSubtitle;
  final String aboutDescription;
  final List<String> aboutHighlights;
  final List<Experience> experiences;
  final List<SkillCategory> skillCategories;
  final List<ProjectCategory> projectCategories;
  final String certificationTitle;
  final String awardTitle;

  const PortfolioData({
    required this.name,
    required this.location,
    required this.email,
    required this.phone,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.cvAsset,
    required this.profileImage,
    required this.heroHeadline,
    required this.heroSubtitle,
    required this.aboutDescription,
    required this.aboutHighlights,
    required this.experiences,
    required this.skillCategories,
    required this.projectCategories,
    required this.certificationTitle,
    required this.awardTitle,
  });

  @override
  List<Object?> get props => [
        name,
        location,
        email,
        phone,
        linkedinUrl,
        githubUrl,
        cvAsset,
        profileImage,
        heroHeadline,
        heroSubtitle,
        aboutDescription,
        aboutHighlights,
        experiences,
        skillCategories,
        projectCategories,
        certificationTitle,
        awardTitle,
      ];
}
