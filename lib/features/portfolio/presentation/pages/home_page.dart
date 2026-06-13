import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../widgets/cursor_glow.dart';
import '../../../../widgets/navbar.dart';
import '../../../../widgets/particle_background.dart' show ParticleOverlay;
import '../../../../widgets/responsive_container.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';
import '../sections/about_section.dart';
import '../sections/awards_section.dart';
import '../sections/certifications_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';

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
    // Trigger initial loading of portfolio data
    context.read<PortfolioBloc>().add(const LoadPortfolioDataEvent());
  }

  void _onScroll() {
    if (mounted) {
      setState(() => _scrollOffset = _scrollController.offset);
    }
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

  Future<void> _openDownload(String cvAsset, String email) async {
    final uri = Uri.base.resolve(cvAsset);
    final launched = await launchUrlString(
      uri.toString(),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      await launchUrlString(
        'mailto:$email',
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: Navbar(
        items: isMobile ? [] : navItems,
        isMobile: isMobile,
        scrollController: _scrollController,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: theme.scaffoldBackgroundColor,
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  children: [
                    Text(
                      'Menu',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    ...navItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.title),
                          textColor: colors.onSurface,
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
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading || state is PortfolioInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PortfolioError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 60, color: colors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load portfolio details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: () {
                        context.read<PortfolioBloc>().add(const LoadPortfolioDataEvent());
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PortfolioLoaded) {
            final data = state.data;
            return Stack(
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
                              headline: data.heroHeadline,
                              subtitle: data.heroSubtitle,
                              name: data.name,
                              location: data.location,
                              profileImage: data.profileImage,
                              scrollOffset: _scrollOffset,
                              onContactPressed: () => _scrollToSection(_contactKey),
                              onDownloadPressed: () => _openDownload(data.cvAsset, data.email),
                            ),
                            ResponsiveContainer(
                              key: _aboutKey,
                              child: AboutSection(
                                description: data.aboutDescription,
                                highlights: data.aboutHighlights,
                              ),
                            ),
                            ResponsiveContainer(
                              key: _experienceKey,
                              child: ExperienceSection(
                                experiences: data.experiences,
                              ),
                            ),
                            ResponsiveContainer(
                              key: _skillsKey,
                              child: SkillsSection(
                                skillCategories: data.skillCategories,
                              ),
                            ),
                            ResponsiveContainer(
                              key: _projectsKey,
                              child: const ProjectsSection(),
                            ),
                            ResponsiveContainer(
                              key: _certificationsKey,
                              child: CertificationsSection(
                                certificationTitle: data.certificationTitle,
                              ),
                            ),
                            ResponsiveContainer(
                              key: _awardsKey,
                              child: AwardsSection(
                                awardTitle: data.awardTitle,
                              ),
                            ),
                            ResponsiveContainer(
                              key: _contactKey,
                              child: ContactSection(
                                email: data.email,
                                phone: data.phone,
                                linkedinUrl: data.linkedinUrl,
                                githubUrl: data.githubUrl,
                                location: data.location,
                              ),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
