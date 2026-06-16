import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:memo_portfolio/widgets/animations.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Hero Section
// ─────────────────────────────────────────────────────────────────────────────
class HeroSection extends StatelessWidget {
  final Function(String)? onScrollToSection;
  const HeroSection({super.key, this.onScrollToSection});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet = w > 768 && w <= 1024;
    final isMobile = w <= 768;
    final hPad = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);

    return Container(
      padding: EdgeInsets.only(
        left: hPad,
        right: hPad,
        top: isDesktop ? 100 : (isTablet ? 80 : 60),
        bottom: isDesktop ? 80 : (isTablet ? 60 : 40),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 55, child: _HeroContent(onScrollToSection: onScrollToSection)),
                const SizedBox(width: 60),
                Expanded(flex: 45, child: StaggeredItem(
                  index: 6, direction: StaggerDirection.fromRight, baseDelay: const Duration(milliseconds: 150),
                  child: _HeroVisual(),
                )),
              ],
            )
          : Column(
              children: [
                if (isMobile) ...[
                  StaggeredItem(index: 0, direction: StaggerDirection.fromTop, baseDelay: const Duration(milliseconds: 100),
                    child: _HeroVisual(),
                  ),
                  const SizedBox(height: 32),
                  _HeroContent(centered: true, onScrollToSection: onScrollToSection),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: _HeroContent(onScrollToSection: onScrollToSection)),
                      const SizedBox(width: 40),
                      Expanded(flex: 4, child: StaggeredItem(
                        index: 6, direction: StaggerDirection.fromRight, baseDelay: const Duration(milliseconds: 150),
                        child: _HeroVisual(),
                      )),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}

// ── Left: text content ────────────────────────────────────────────────────────
class _HeroContent extends StatelessWidget {
  final bool centered;
  final Function(String)? onScrollToSection;
  const _HeroContent({this.centered = false, this.onScrollToSection});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final align = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final tAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        // "Hi, I'm" – من اليسار
        StaggeredItem(index: 0, direction: StaggerDirection.fromLeft, baseDelay: const Duration(milliseconds: 150),
          child: Text(
            PortfolioData.subtitle,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: isDesktop ? 26 : 20,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Name – من اليمين
        StaggeredItem(index: 1, direction: StaggerDirection.fromRight, baseDelay: const Duration(milliseconds: 150),
          child: Text(
            PortfolioData.name,
            style: AppTextStyles.h1.copyWith(
              fontSize: isDesktop ? 68 : (w > 768 ? 50 : 36),
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            textAlign: tAlign,
          ),
        ),
        const SizedBox(height: 12),

        // Title – من الأعلى
        StaggeredItem(index: 2, direction: StaggerDirection.fromTop, baseDelay: const Duration(milliseconds: 150),
          child: ShaderMask(
            shaderCallback: (b) => primaryGradient.createShader(b),
            child: Text(
              PortfolioData.title,
              style: AppTextStyles.h3.copyWith(
                fontSize: isDesktop ? 38 : (w > 768 ? 28 : 22),
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: tAlign,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Description – من الأسفل
        StaggeredItem(index: 3, direction: StaggerDirection.fromBottom, baseDelay: const Duration(milliseconds: 150),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              PortfolioData.description,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: isDesktop ? 18 : 16,
              ),
              textAlign: tAlign,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Action buttons – من اليسار
        StaggeredItem(index: 4, direction: StaggerDirection.fromLeft, baseDelay: const Duration(milliseconds: 150),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: centered ? WrapAlignment.center : WrapAlignment.start,
            children: [
              _PrimaryBtn(
                label: "View My Work",
                icon: Icons.arrow_forward_rounded,
                onTap: () {
                  if (onScrollToSection != null) {
                    onScrollToSection!('Projects');
                  }
                },
              ),
              _SecondaryBtn(
                label: "Contact Me",
                icon: Icons.phone,
                onTap: () => _launchUrl('tel:${PortfolioData.phone}'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Social row – من اليمين
        StaggeredItem(index: 5, direction: StaggerDirection.fromRight, baseDelay: const Duration(milliseconds: 150),
          child: Row(
            mainAxisAlignment:
                centered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                "Follow me",
                style: AppTextStyles.bodySmall
                    .copyWith(color: textMuted, fontSize: 14),
              ),
              const SizedBox(width: 16),
              _SocialBtn(
                svgUrl: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg',
                tooltip: "LinkedIn",
                onTap: () => _launchUrl(PortfolioData.linkedinUrl),
              ),
              const SizedBox(width: 10),
              _SocialBtn(
                svgUrl: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg',
                tooltip: "GitHub",
                onTap: () => _launchUrl(PortfolioData.githubUrl),
              ),
              const SizedBox(width: 10),
              _SocialBtn(
                svgUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg',
                tooltip: "WhatsApp",
                onTap: () => _launchUrl(PortfolioData.whatsappUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Right: profile visual ─────────────────────────────────────────────────────
class _HeroVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      height: 420,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Dot grids (decorative)
          Positioned(
            left: 10,
            top: 30,
            child: _DotGrid(rows: 5, cols: 6),
          ),
          Positioned(
            right: 0,
            bottom: 40,
            child: _DotGrid(rows: 4, cols: 5),
          ),

          // Outer purple glow
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          // Gradient circle background
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryColor, accentColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Profile image area (replace Icon with Image.asset / Image.network)
          Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1B4B),
              border: Border.all(
                color: primaryColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child:  ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: Image.asset(
                'assets/images/memo_photo.png',
              ),
            ),
          ),

          // Experience floating card
          Positioned(
            top: 16,
            right: -10,
            child: _ExperienceCard(),
          ),

          // Decorative symbols
          Positioned(
            left: 60,
            bottom: 80,
            child: Text(
              "+",
              style: TextStyle(
                color: textSecondary.withOpacity(0.4),
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 160,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: textSecondary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── "4+ Years of Experience" card ─────────────────────────────────────────────
class _ExperienceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.code_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                PortfolioData.experienceYears,
                style: AppTextStyles.h4.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Years of\nExperience",
                style: AppTextStyles.caption.copyWith(
                  color: textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dot grid widget ───────────────────────────────────────────────────────────
class _DotGrid extends StatelessWidget {
  final int rows;
  final int cols;
  const _DotGrid({required this.rows, required this.cols});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rows,
        (_) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            cols,
            (_) => Container(
              margin: const EdgeInsets.all(4),
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textSecondary.withOpacity(0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Primary (gradient) button ─────────────────────────────────────────────────
class _PrimaryBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_PrimaryBtn> createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<_PrimaryBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: glowColor.withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 2,
                    )
                  ]
                : [
                    BoxShadow(
                      color: glowColor.withOpacity(0.2),
                      blurRadius: 12,
                    )
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style:
                    AppTextStyles.buttonPrimary.copyWith(fontSize: 15),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Secondary (outline) button ────────────────────────────────────────────────
class _SecondaryBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_SecondaryBtn> createState() => _SecondaryBtnState();
}

class _SecondaryBtnState extends State<_SecondaryBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.buttonPrimary.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Circular social icon button ───────────────────────────────────────────────
class _SocialBtn extends StatefulWidget {
  final String svgUrl;
  final String tooltip;
  final VoidCallback onTap;
  const _SocialBtn(
      {required this.svgUrl, required this.tooltip, required this.onTap});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hovered
                  ? primaryColor.withOpacity(0.15)
                  : cardColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: _hovered
                    ? primaryColor.withOpacity(0.6)
                    : primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: SvgPicture.network(
                widget.svgUrl,
                width: 18,
                height: 18,
                color:(widget.svgUrl=='https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg')? Colors.white:null,
                placeholderBuilder: (_) => Icon(
                  Icons.link,
                  color: _hovered ? primaryColor : textSecondary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to launch URLs
Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

