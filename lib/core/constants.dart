import 'package:portfolio_web/features/portfolio/data/models/experience_model.dart';
import 'package:portfolio_web/features/portfolio/data/models/project_model.dart';
import 'package:portfolio_web/features/portfolio/domain/entities/project.dart';
import 'package:portfolio_web/features/portfolio/domain/entities/skill.dart';

const String kName = 'Yousef Habbeh';
const String kLocation = 'Amman, Jordan';
const String kEmail = 'yousef.habbeh@hotmail.com';
const String kPhone = '+962781543080';
const String kLinkedInUrl = 'https://www.linkedin.com/in/yhabbeh/';
const String kGitHubUrl = 'https://github.com/yhabbeh';
const String kCvAsset = 'assets/pdf/Yousef_Habbeh_CV.pdf';
const String kProfileImage = 'assets/images/profile_placeholder.png';
const String kHeroHeadline =
    'Mobile Software Engineer | Flutter Developer | AI Engineer';
const String kHeroSubtitle =
    'Building high-performance mobile applications with Flutter and integrating intelligent solutions through Machine Learning. Focused on clean architecture, scalable systems, and modern UX.';
const String kAboutDescription =
    '''Mobile Software Engineer and AI Specialist with 6+ years of professional experience.

Specialized in Flutter, Dart, and Machine Learning, with experience developing scalable mobile applications, intelligent systems, and data-driven solutions.

Passionate about clean code, scalable architecture, problem solving, and combining mobile technology with AI to create impactful digital products.''';
const List<String> kAboutHighlights = [
  'Flutter Development',
  'AI / Machine Learning',
  'Clean Architecture',
  'Mobile Systems',
];
const List<String> kNavItems = [
  'Home',
  'About',
  'Experience',
  'Skills',
  'Projects',
  'Certifications',
  'Awards',
  'Contact',
];

class ContactDetail {
  final String title;
  final String value;
  final String link;

  const ContactDetail({
    required this.title,
    required this.value,
    required this.link,
  });
}

const List<ContactDetail> kContactDetails = [
  ContactDetail(title: 'Email', value: kEmail, link: 'mailto:$kEmail'),
  ContactDetail(title: 'Phone', value: kPhone, link: 'tel:$kPhone'),
  ContactDetail(
    title: 'LinkedIn',
    value: 'linkedin.com/in/yhabbeh',
    link: kLinkedInUrl,
  ),
  ContactDetail(title: 'GitHub', value: 'github.com/yhabbeh', link: kGitHubUrl),
  ContactDetail(
    title: 'Location',
    value: kLocation,
    link: 'https://www.google.com/maps/search/?api=1&query=Amman+Jordan',
  ),
];

const List<ExperienceModel> kExperienceItems = [
  ExperienceModel(
    title: 'Mobile Developer',
    company: 'Futeric',
    period: 'May 2025 — Present',
    location: 'Amman, Jordan',
    responsibilities: [
      'Mobile application design and execution with Flutter.',
      'Feature delivery, UI implementation, and performance optimization.',
      'Collaborated with product and QA teams for stable releases.',
    ],
  ),
  ExperienceModel(
    title: 'Mobile Developer',
    company: 'Integrated Technology Group (ITG)',
    period: 'March 2022 — May 2025',
    location: 'Amman, Jordan',
    responsibilities: [
      'Flutter application development and REST API integration.',
      'Delivered polished user interfaces and technical solutions.',
      'Shared product ownership and collaborated with cross-functional teams.',
    ],
  ),
  ExperienceModel(
    title: 'Machine Learning Mentor',
    company: 'AI For SHAI',
    period: 'Jan 2022 — Jun 2023',
    location: 'Remote',
    responsibilities: [
      'Mentored students on ML fundamentals and model evaluation.',
      'Led workshops and built real-world dataset solutions.',
      'Supported practical machine learning and data science projects.',
    ],
  ),
  ExperienceModel(
    title: 'Deep Learning & Machine Learning Intern',
    company: 'AI For SHAI',
    period: 'Jan 2021 — Jan 2022',
    location: 'Remote',
    responsibilities: [
      'Built TensorFlow and Keras models for computer vision and regression.',
      'Worked on classification and Kaggle project workflows.',
      'Explored neural network performance and training best practices.',
    ],
  ),
  ExperienceModel(
    title: 'Core Curriculum Student',
    company: '42 Amman',
    period: 'Sep 2024 — Apr 2025',
    location: 'Amman, Jordan',
    responsibilities: [
      'Completed intensive programming and problem-solving curriculum.',
    ],
  ),
  ExperienceModel(
    title: 'Fellow',
    company: 'Correlation One',
    period: 'Aug 2024 — Apr 2025',
    location: 'Remote',
    responsibilities: [
      'Participated in a data and AI fellowship focused on practical skills.',
    ],
  ),
  ExperienceModel(
    title: 'Service Management Analyst',
    company: 'Electronic Health Solutions',
    period: 'Jan 2022 — Apr 2022',
    location: 'Amman, Jordan',
    responsibilities: [
      'Supported service management processes for healthcare operations.',
    ],
  ),
  ExperienceModel(
    title: 'System Implementor',
    company: 'GoClinic',
    period: 'Nov 2021 — Jan 2022',
    location: 'Amman, Jordan',
    responsibilities: [
      'Implemented system workflows and supported deployment processes.',
    ],
  ),
  ExperienceModel(
    title: 'Academic Team Leader',
    company: 'Ahl Al Hemmeh',
    period: 'Jan 2020 — Sep 2021',
    location: 'Amman, Jordan',
    responsibilities: [
      'Led student teams for academic and community technology programs.',
    ],
  ),
];
const List<SkillCategory> kSkillCategories = [
  SkillCategory(
    title: 'Mobile Development',
    skills: ['Flutter', 'Dart', 'Bloc', 'Cubit', 'REST APIs', 'JSON'],
  ),
  SkillCategory(
    title: 'AI & Data Science',
    skills: [
      'Machine Learning',
      'Deep Learning',
      'TensorFlow',
      'Keras',
      'Statistical Modeling',
    ],
  ),
  SkillCategory(title: 'Programming', skills: ['Python', 'SQL', 'MATLAB']),
  SkillCategory(
    title: 'Big Data',
    skills: ['Hadoop', 'Spark', 'Hive', 'MapReduce'],
  ),
  SkillCategory(
    title: 'Tools',
    skills: ['Android Studio', 'VS Code', 'Jupyter', 'Google Colab'],
  ),
];

final List<ProjectCategory> kProjectCategories = [
  ProjectCategory(
    title: 'Professional Projects',
    projects: [
      ProjectModel(
        name: 'BinDowal Bank',
        description:
            'Engineered core banking UIs encompassing financial transactions, account overviews, and debit/credit card management. Architected with Clean Architecture for maintainability and scalability. Implemented BLoC to orchestrate complex financial state transitions with high-performance execution.',
        technologies: const ['Flutter', 'BLoC', 'Clean Architecture'],
        githubUrl: '',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.mobile.newdemobanking',
        stars: 0,
      ),
      ProjectModel(
        name: 'Sanad — Ministry of Foreign Affairs',
        description:
            'Spearheaded micro-services digitizing legal government processes including marriage declarations and sponsorships. Integrated complex Ministry of Economy APIs handling sensitive government data under strict security protocols. Adhered to enterprise-grade government standards for code architecture and UI/UX compliance.',
        technologies: const ['Flutter', 'REST APIs'],
        githubUrl: '',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.modee.sanad',
        stars: 0,
      ),
      ProjectModel(
        name: 'EduWave K-12',
        description:
            'Developed and optimized assessment and assignment modules for student engagement and educator administration. Built administrative dashboards enabling educators to monitor class progress, author exams, and track student grading.',
        technologies: const ['Flutter', 'BLoC'],
        githubUrl: '',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.itgsolutions.eduwave',
        stars: 0,
      ),
      ProjectModel(
        name: 'WaveDMS',
        description:
            'Executed debugging and performance optimization protocols, significantly improving system stability. Pioneered a digital document signature feature with automated routing for seamless multi-department authorization.',
        technologies: const ['Flutter', 'Digital Signatures', 'Workflow Automation'],
        githubUrl: '',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.itgsolutions.WaveDMS',
        stars: 0,
      ),
      ProjectModel(
        name: 'ITG Timecard',
        description:
            'Upgraded GPS-based attendance tracking with advanced anti-spoofing mechanisms ensuring location data integrity. Engineered employee management modules for leave and departure request submission and tracking.',
        technologies: const ['Flutter', 'GPS', 'Anti-Spoofing'],
        githubUrl: '',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.itgsolutions.gpsAttendanceSystem',
        stars: 0,
      ),
    ],
  ),
  ProjectCategory(
    title: 'Mobile Applications',
    projects: [
      ProjectModel(
        name: 'Drug Managment',
        description:
            'Home Pharmacy Management & Medication Reminders. An offline-first Android app built with Clean Architecture and BLoC/Cubit.',
        technologies: const [
          'Flutter',
          'Dart',
          'BLoC',
          'Clean Architecture',
          'SQLite',
        ],
        githubUrl: 'https://github.com/yhabbeh/drugMNG',
        stars: 1,
      ),
      // ProjectModel(
      //   name: 'drug_reminder',
      //   description: 'Medication management app with scheduling, dose reminders, and contact integration.',
      //   technologies: ['Flutter', 'Dart', 'BLoC', 'Notifications'],
      //   githubUrl: 'https://github.com/yhabbeh/drug_reminder',
      // ),
      const ProjectModel(
        name: 'AppointDent Dental Manager',
        description:
            'Architected and deployed from inception as a comprehensive end-to-end solution for dental clinic management. Designed with Clean Architecture for scalability. Integrated Firebase for secure authorization and real-time cloud database. Employs BLoC for fluid performance and rapid responsiveness.',
        technologies: ['Flutter', 'Firebase', 'BLoC', 'Clean Architecture'],
        githubUrl: 'https://github.com/yhabbeh/dental-appointment-mobile',
        googlePlayUrl:
            'https://play.google.com/store/apps/details?id=com.habbeh.dental',
        stars: 1,
      ),
      const ProjectModel(
        name: 'al-mathurat',
        description:
            'Islamic morning and evening adhkar (remembrances) mobile application.',
        technologies: ['Flutter', 'Dart'],
        githubUrl: 'https://github.com/yhabbeh/al-mathurat',
        stars: 1,
      ),
      const ProjectModel(
        name: 'Neuro_Stem',
        description:
            'Flutter-based mobile application exploring neurotechnology concepts.',
        technologies: ['Flutter', 'Dart'],
        githubUrl: 'https://github.com/yhabbeh/Neuro_Stem',
        stars: 2,
      ),
      // ProjectModel(
      //   name: 'Clean_architecture',
      //   description: 'Flutter project demonstrating clean architecture principles with domain, data, and presentation layer separation.',
      //   technologies: ['Flutter', 'Dart', 'Clean Architecture'],
      //   githubUrl: 'https://github.com/yhabbeh/Clean_architecture',
      //   stars: 1,
      // ),
      // ProjectModel(
      //   name: 'Flutter_UI_task1',
      //   description: 'Flutter UI exploration project showcasing custom widget design and layout techniques.',
      //   technologies: ['Flutter', 'Dart', 'UI/UX'],
      //   githubUrl: 'https://github.com/yhabbeh/Flutter_UI_task1',
      //   stars: 1,
      // ),
      // ProjectModel(
      //   name: 'taskProgressSoft',
      //   description: 'Flutter task management application with progress tracking features.',
      //   technologies: ['Flutter', 'Dart'],
      //   githubUrl: 'https://github.com/yhabbeh/taskProgressSoft',
      // ),
    ],
  ),
  const ProjectCategory(
    title: 'AI & Machine Learning',
    projects: [
      ProjectModel(
        name: 'Diamonds-price-prediction',
        description:
            'Machine learning model to predict diamond prices based on attributes like carat, cut, color, and clarity.',
        technologies: ['Python', 'Jupyter', 'ML', 'Data Analysis'],
        githubUrl: 'https://github.com/yhabbeh/Diamonds-price-prediction',
        stars: 1,
      ),
      ProjectModel(
        name: 'autism_efficient',
        description:
            'Flask-based API for classifying images as potentially indicating autism using a pre-trained deep learning model.',
        technologies: [
          'Python',
          'Flask',
          'TensorFlow',
          'Keras',
          'Deep Learning',
        ],
        githubUrl: 'https://github.com/yhabbeh/autism_efficient',
        stars: 1,
      ),
    ],
  ),
  const ProjectCategory(
    title: 'Web & Tools',
    projects: [
      // ProjectModel(
      //   name: 'audit_project',
      //   description:
      //       'Audit Committee Management System — a production-ready SPA for managing audit operations with role-based access, meeting/decision CRUD, Word report generation, and Claude AI integration.',
      //   technologies: [
      //     'JavaScript',
      //     'HTML',
      //     'CSS',
      //     'Claude AI',
      //     'Google Sheets',
      //   ],
      //   githubUrl: 'https://github.com/yhabbeh/audit_project',
      // ),
      ProjectModel(
        name: 'Water_Metric_Steps',
        description:
            'Interactive water intake tracker with step-based goal tracking and visual progress indicators.',
        technologies: ['CSS', 'HTML', 'JavaScript'],
        githubUrl: 'https://github.com/yhabbeh/Water_Metric_Steps',
        stars: 1,
      ),
      ProjectModel(
        name: 'library-inventory',
        description: 'JavaScript-based library inventory management system.',
        technologies: ['JavaScript', 'HTML', 'CSS'],
        githubUrl: 'https://github.com/yhabbeh/library-inventory',
        stars: 1,
      ),
    ],
  ),
];

const String kCertificationTitle =
    'Tech for Jobs Professional Development for Tech Roles — High Performing Certificate';
const String kAwardTitle =
    '🏆 3rd Place — HAAC (Hakeem Annual Academy Competition)';
