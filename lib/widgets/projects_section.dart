import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet = w > 768 && w <= 1024;
    final hPad = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);
    final projects = PortfolioData.projects;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'My ',
                        style: AppTextStyles.h4.copyWith(fontSize: isDesktop ? 28 : 22, color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Projects',
                        style: AppTextStyles.h4.copyWith(
                          fontSize: isDesktop ? 28 : 22,
                          foreground: Paint()
                            ..shader = primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 30),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                _ViewAllButton(onTap: () {}),
              ],
            ),
            const SizedBox(height: 32),

            // Project cards grid
            LayoutBuilder(builder: (ctx, constraints) {
              int crossAxisCount;
              double childAspectRatio;

              if (constraints.maxWidth > 1200) {
                // Desktop large - 4 columns
                crossAxisCount = 4;
                childAspectRatio = 0.8;
              } else if (constraints.maxWidth > 900) {
                // Desktop - 3 columns
                crossAxisCount = 3;
                childAspectRatio = 0.85;
              } else if (constraints.maxWidth > 600) {
                // Tablet - 2 columns
                crossAxisCount = 2;
                childAspectRatio = 0.9;
              } else {
                // Mobile - 1 column
                crossAxisCount = 1;
                childAspectRatio = 1.2;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return _ProjectCard(project: projects[index]);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectData project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isSmallCard = w <= 600; // للشاشات الصغيرة

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? primaryColor.withOpacity(0.35) : primaryColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 20, spreadRadius: 1)]
              : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project image area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: isSmallCard ? 120 : 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.project.gradientColors.map((c) => Color(c)).toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: widget.project.imagePath != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          // Gradient overlay
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.project.gradientColors.map((c) => Color(c).withOpacity(0.3)).toList(),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          // Project image
                          Padding(
                            padding: EdgeInsets.all(isSmallCard ? 16.0 : 20.0),
                            child: Image.asset(
                              widget.project.imagePath!,
                              fit: BoxFit.contain,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Decorative phone frame (fallback)
                          Container(
                            width: isSmallCard ? 50 : 70,
                            height: isSmallCard ? 80 : 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                            ),
                            child: Icon(
                              Icons.phone_android_rounded,
                              color: Colors.white.withOpacity(0.7),
                              size: isSmallCard ? 24 : 36
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isSmallCard ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.project.title,
                      style: AppTextStyles.h5.copyWith(
                        fontSize: isSmallCard ? 14 : 16,
                        color: Colors.white
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallCard ? 6 : 8),

                    // Description
                    Expanded(
                      child: Text(
                        widget.project.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                          height: 1.3,
                          fontSize: isSmallCard ? 11 : 12,
                        ),
                        maxLines: isSmallCard ? 3 : 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: isSmallCard ? 8 : 12),

                    // Tags
                    Container(
                      height: isSmallCard ? 20 : 24,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.project.technologies.take(3)
                              .map((t) => Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallCard ? 6 : 8,
                                      vertical: isSmallCard ? 2 : 3
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: primaryColor.withOpacity(0.25), width: 1),
                                    ),
                                    child: Text(
                                      t,
                                      style: AppTextStyles.caption.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallCard ? 8 : 9,
                                      )
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallCard ? 10 : 14),

                    // Actions
                    _buildActionButtons(isSmallCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isSmallCard) {
    final bool hasLiveDemo = widget.project.liveDemoUrl != null &&
        widget.project.liveDemoUrl!.isNotEmpty ||
        widget.project.demoUrl.isNotEmpty;
    final bool hasGitHub = widget.project.githubUrl.isNotEmpty;

    return Column(
      children: [
        // Store buttons row
        if (widget.project.playStoreUrl != null || widget.project.appStoreUrl != null)
          SizedBox(
            height: isSmallCard ? 24 : 30,
            child: Row(
              children: [
                if (widget.project.playStoreUrl != null) ...[
                  Expanded(
                    child: _StoreButton(
                      icon: Icons.shop,
                      label: 'Play',
                      onTap: () => _launchUrl(widget.project.playStoreUrl!),
                      isSmall: isSmallCard,
                    ),
                  ),
                  if (widget.project.appStoreUrl != null) const SizedBox(width: 6),
                ],
                if (widget.project.appStoreUrl != null)
                  Expanded(
                    child: _StoreButton(
                      icon: Icons.apple,
                      label: 'App Store',
                      onTap: () => _launchUrl(widget.project.appStoreUrl!),
                      isSmall: isSmallCard,
                    ),
                  ),
              ],
            ),
          ),

        // Only show spacing if we have store buttons AND (demo or github buttons)
        if ((widget.project.playStoreUrl != null || widget.project.appStoreUrl != null) &&
            (hasLiveDemo || hasGitHub))
          SizedBox(height: isSmallCard ? 6 : 8),

        // Demo and GitHub buttons row - only show if we have at least one
        if (hasLiveDemo || hasGitHub)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Live Demo button
              if (hasLiveDemo)
                _LiveDemoBtn(
                  onTap: () => _launchUrl(
                    widget.project.liveDemoUrl != null &&
                    widget.project.liveDemoUrl!.isNotEmpty
                        ? widget.project.liveDemoUrl!
                        : widget.project.demoUrl
                  ),
                  isSmall: isSmallCard,
                )
              else
                const SizedBox(), // Empty space if no demo URL

              // GitHub button
              if (hasGitHub)
                _GitHubIconBtn(
                  onTap: () => _launchUrl(widget.project.githubUrl),
                  isSmall: isSmallCard,
                )
              else
                const SizedBox(), // Empty space if no GitHub URL
            ],
          ),
      ],
    );
  }
}

class _LiveDemoBtn extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSmall;
  const _LiveDemoBtn({required this.onTap, this.isSmall = false});

  @override
  State<_LiveDemoBtn> createState() => _LiveDemoBtnState();
}

class _LiveDemoBtnState extends State<_LiveDemoBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Live Demo',
              style: AppTextStyles.bodySmall.copyWith(
                color: _hovered ? primaryColor.withOpacity(0.8) : primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: widget.isSmall ? 10 : 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_rounded,
              color: primaryColor,
              size: widget.isSmall ? 12 : 14
            ),
          ],
        ),
      ),
    );
  }
}

class _GitHubIconBtn extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSmall;
  const _GitHubIconBtn({required this.onTap, this.isSmall = false});

  @override
  State<_GitHubIconBtn> createState() => _GitHubIconBtnState();
}

class _GitHubIconBtnState extends State<_GitHubIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.isSmall ? 28.0 : 32.0;
    final iconSize = widget.isSmall ? 14.0 : 16.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _hovered ? primaryColor.withOpacity(0.15) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: _hovered ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.code_rounded,
            color: _hovered ? primaryColor : textSecondary,
            size: iconSize
          ),
        ),
      ),
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ViewAllButton({required this.onTap});

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Projects',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _hovered ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, color: primaryColor, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSmall;

  const _StoreButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  State<_StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<_StoreButton> {
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
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSmall ? 8 : 12,
            vertical: widget.isSmall ? 6 : 8
          ),
          decoration: BoxDecoration(
            color: _hovered ? primaryColor.withOpacity(0.15) : primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovered ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: _hovered ? primaryColor : primaryColor.withOpacity(0.8),
                size: widget.isSmall ? 12 : 14,
              ),
              SizedBox(width: widget.isSmall ? 4 : 6),
              Text(
                widget.label,
                style: AppTextStyles.caption.copyWith(
                  color: _hovered ? primaryColor : primaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: widget.isSmall ? 9 : 11,
                ),
              ),
            ],
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
