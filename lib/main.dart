import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/widgets/navbar.dart';
import 'package:memo_portfolio/widgets/hero_section.dart';
import 'package:memo_portfolio/widgets/skills_section.dart';
import 'package:memo_portfolio/widgets/projects_section.dart';
import 'package:memo_portfolio/widgets/experience_section.dart';
import 'package:memo_portfolio/widgets/contact_section.dart';
import 'package:memo_portfolio/widgets/footer.dart';
import 'package:memo_portfolio/widgets/animations.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohamed Alaa – Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _scrollController = ScrollController();
  String _activeSection = 'Home';

  // Section keys for scroll-to behavior
  final _homeKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _contactKey = GlobalKey();

  void _scrollTo(String section) {
    setState(() => _activeSection = section);
    GlobalKey? key;
    switch (section) {
      case 'Home':
        key = _homeKey;
        break;
      case 'About':
        key = _homeKey; // About scrolls to home section
        break;
      case 'Skills':
        key = _skillsKey;
        break;
      case 'Projects':
        key = _projectsKey;
        break;
      case 'Experience':
        key = _experienceKey;
        break;
      case 'Contact':
        key = _contactKey;
        break;
      default:
        key = _homeKey;
    }
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ── Enhanced Animated Background ──
          const AnimatedBackgroundBlobs(),
          const FloatingParticles(),

          // ── Scrollable content (with top padding for sticky nav) ──
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 72), // navbar height offset

                // Hero section - يظهر من تحت (fadeInUp)
                AnimatedSection(
                  key: _homeKey,
                  animationType: AnimationType.fadeInUp,
                  delay: const Duration(milliseconds: 100),
                  child: HeroSection(onScrollToSection: _scrollTo),
                ),

                // Skills section - يظهر من اليسار (fadeInLeft)
                AnimatedSection(
                  key: _skillsKey,
                  animationType: AnimationType.fadeInLeft,
                  delay: const Duration(milliseconds: 300),
                  child: const SkillsSection(),
                ),

                // Projects section - يظهر من اليمين (fadeInRight)
                AnimatedSection(
                  key: _projectsKey,
                  animationType: AnimationType.fadeInRight,
                  delay: const Duration(milliseconds: 500),
                  child: const ProjectsSection(),
                ),

                // Experience section - يظهر من فوق (fadeInDown)
                AnimatedSection(
                  key: _experienceKey,
                  animationType: AnimationType.fadeInDown,
                  delay: const Duration(milliseconds: 700),
                  child: const ExperienceSection(),
                ),

                const SizedBox(height: 32),

                // Contact section - يظهر بتكبير من المركز (scaleIn)
                AnimatedSection(
                  key: _contactKey,
                  animationType: AnimationType.scaleIn,
                  delay: const Duration(milliseconds: 900),
                  child: const ContactSection(),
                ),

                // Footer - يظهر من تحت مع حركة انزلاق (slideInUp)
                AnimatedSection(
                  animationType: AnimationType.slideInUp,
                  delay: const Duration(milliseconds: 1100),
                  child: const Footer(),
                ),
              ],
            ),
          ),

          // ── Sticky Navbar (on top) with slide down animation ──
          Positioned(
            top: 0, left: 0, right: 0,
            child: AnimatedSection(
              animationType: AnimationType.fadeInDown,
              delay: const Duration(milliseconds: 50),
              child: CustomNavBar(
                selectedSection: _activeSection,
                onMenuTap: _scrollTo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

