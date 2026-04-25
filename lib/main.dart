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
          // ── Ambient background glow blobs ──
          Positioned(
            top: -120,
            right: -120,
            child: _GlowBlob(color: primaryColor, size: 500, opacity: 0.07),
          ),
          Positioned(
            top: 400,
            left: -160,
            child: _GlowBlob(color: accentColor, size: 400, opacity: 0.06),
          ),
          Positioned(
            bottom: 200,
            right: -100,
            child: _GlowBlob(color: primaryColor, size: 350, opacity: 0.05),
          ),

          // ── Scrollable content (with top padding for sticky nav) ──
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 72), // navbar height offset

                // Hero
                SizedBox(key: _homeKey, child: HeroSection(onScrollToSection: _scrollTo)),

                // Skills bar
                SizedBox(key: _skillsKey, child: const SkillsSection()),

                // Projects
                SizedBox(key: _projectsKey, child: const ProjectsSection()),

                // Experience
                SizedBox(key: _experienceKey, child: const ExperienceSection()),

                const SizedBox(height: 32),

                // Contact
                SizedBox(key: _contactKey, child: const ContactSection()),

                // Footer
                const Footer(),
              ],
            ),
          ),

          // ── Sticky Navbar (on top) ──
          Positioned(
            top: 0, left: 0, right: 0,
            child: CustomNavBar(
              selectedSection: _activeSection,
              onMenuTap: _scrollTo,
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

// ── Ambient glow helper ───────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowBlob({required this.color, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
