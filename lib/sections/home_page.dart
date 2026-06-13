import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../core/constants.dart';
import '../widgets/cursor_glow.dart';
import '../widgets/navbar.dart';
import '../widgets/particle_background.dart' show ParticleOverlay;
import '../widgets/responsive_container.dart';
import 'about_section.dart';
import 'awards_section.dart';
import 'certifications_section.dart';
import 'contact_section.dart';
import 'experience_section.dart';
import 'hero_section.dart';
import 'projects_section.dart';
import 'skills_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _certificationsKey = GlobalKey();
  final GlobalKey _awardsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() => _scrollOffset = _scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  Future<void> _openDownload() async {
    final uri = Uri.base.resolve(kCvAsset);
    final launched = await launchUrlString(
      uri.toString(),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      await launchUrlString(
        'mailto:$kEmail',
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 800;

    final navItems = [
      NavigationItem(
        title: 'Home',
        onTap: () => _scrollToSection(_heroKey),
      ),
      NavigationItem(
        title: 'About',
        onTap: () => _scrollToSection(_aboutKey),
      ),
      NavigationItem(
        title: 'Experience',
        onTap: () => _scrollToSection(_experienceKey),
      ),
      NavigationItem(
        title: 'Skills',
        onTap: () => _scrollToSection(_skillsKey),
      ),
      NavigationItem(
        title: 'Projects',
        onTap: () => _scrollToSection(_projectsKey),
      ),
      NavigationItem(
        title: 'Certifications',
        onTap: () => _scrollToSection(_certificationsKey),
      ),
      NavigationItem(
        title: 'Awards',
        onTap: () => _scrollToSection(_awardsKey),
      ),
      NavigationItem(
        title: 'Contact',
        onTap: () => _scrollToSection(_contactKey),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: Navbar(
        items: isMobile ? [] : navItems,
        isMobile: isMobile,
        scrollController: _scrollController,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  children: [
                    Text(
                      'Menu',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    ...navItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.title),
                          onTap: () {
                            Navigator.pop(context);
                            item.onTap();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleOverlay(particleCount: 12)),
          Positioned.fill(
            child: CursorGlow(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeroSection(
                        key: _heroKey,
                        scrollOffset: _scrollOffset,
                        onContactPressed: () =>
                            _scrollToSection(_contactKey),
                        onDownloadPressed: _openDownload,
                      ),
                      ResponsiveContainer(
                        key: _aboutKey,
                        child: const AboutSection(),
                      ),
                      ResponsiveContainer(
                        key: _experienceKey,
                        child: const ExperienceSection(),
                      ),
                      ResponsiveContainer(
                        key: _skillsKey,
                        child: const SkillsSection(),
                      ),
                      ResponsiveContainer(
                        key: _projectsKey,
                        child: const ProjectsSection(),
                      ),
                      ResponsiveContainer(
                        key: _certificationsKey,
                        child: const CertificationsSection(),
                      ),
                      ResponsiveContainer(
                        key: _awardsKey,
                        child: const AwardsSection(),
                      ),
                      ResponsiveContainer(
                        key: _contactKey,
                        child: const ContactSection(),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
