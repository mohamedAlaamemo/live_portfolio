import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:memo_portfolio/widgets/animations.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet = w > 768 && w <= 1024;
    final hPad = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title – left aligned
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'My ',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: isDesktop ? 36 : 28,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Experience',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: isDesktop ? 36 : 28,
                    foreground: Paint()
                      ..shader = primaryGradient.createShader(
                        const Rect.fromLTWH(0, 0, 240, 40),
                      ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: isDesktop ? 56 : 44,
            height: 3,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),

          // Experience timeline
          ...PortfolioData.experiences.asMap().entries.map((e) => StaggeredItem(
                index: e.key,
                direction: StaggerDirection.alternating,
                baseDelay: const Duration(milliseconds: 150),
                child: _ExperienceCard(
                  experience: e.value,
                  isLast: e.key == PortfolioData.experiences.length - 1,
                  isDesktop: isDesktop,
                ),
              )),

          const SizedBox(height: 48),

          // Activities
          _sectionSubtitle('Activities', isDesktop),
          const SizedBox(height: 24),
          ...PortfolioData.activities.asMap().entries.map((e) => StaggeredItem(
                index: e.key,
                direction: StaggerDirection.random,
                baseDelay: const Duration(milliseconds: 120),
                child: _ActivityCard(
                  activity: e.value,
                  isLast: e.key == PortfolioData.activities.length - 1,
                  isDesktop: isDesktop,
                ),
              )),

          const SizedBox(height: 48),

          // Education
          _sectionSubtitle('Education', isDesktop),
          const SizedBox(height: 24),
          ...PortfolioData.education.asMap().entries.map((e) => StaggeredItem(
                index: e.key,
                direction: StaggerDirection.alternating,
                baseDelay: const Duration(milliseconds: 150),
                child: _EducationCard(edu: e.value, isDesktop: isDesktop),
              )),
        ],
      ),
    );
  }

  Widget _sectionSubtitle(String text, bool isDesktop) {
    return Row(
      children: [
        Container(
          width: 4,
          height: isDesktop ? 28 : 22,
          decoration: BoxDecoration(
            gradient: primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.h4.copyWith(
            fontSize: isDesktop ? 24 : 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ─── Experience Card ──────────────────────────────────────────────────────────

class _ExperienceCard extends StatefulWidget {
  final ExperienceData experience;
  final bool isLast;
  final bool isDesktop;

  const _ExperienceCard({
    required this.experience,
    required this.isLast,
    required this.isDesktop,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hovered ? primaryGradient : null,
                  color: _hovered ? null : primaryColor.withOpacity(0.5),
                  border: Border.all(color: primaryColor, width: 2),
                ),
              ),
              if (!widget.isLast)
                Container(
                  width: 2,
                  height: 140,
                  margin: const EdgeInsets.only(top: 8),
                  color: primaryColor.withOpacity(0.2),
                ),
            ],
          ),
          const SizedBox(width: 24),

          // Card
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 32),
              padding: EdgeInsets.all(widget.isDesktop ? 24 : 18),
              decoration: BoxDecoration(
                color: _hovered ? cardColor.withOpacity(0.9) : cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hovered ? primaryColor.withOpacity(0.3) : primaryColor.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: _hovered
                    ? [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      if (exp.logoPath != null) ...[
                        Container(
                          width: widget.isDesktop ? 52 : 44,
                          height: widget.isDesktop ? 52 : 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryColor.withOpacity(0.15), width: 1),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(exp.logoPath!, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],

                      // Title + company
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp.title,
                              style: AppTextStyles.h5.copyWith(
                                fontSize: widget.isDesktop ? 18 : 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  exp.company,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.isDesktop ? 14 : 13,
                                  ),
                                ),
                                if (exp.companyType.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      exp.companyType,
                                      style: AppTextStyles.caption.copyWith(
                                        color: primaryColor.withOpacity(0.85),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Period
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
                        ),
                        child: Text(
                          exp.period,
                          style: AppTextStyles.caption.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: widget.isDesktop ? 11 : 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Bullet points
                  ...exp.description.split('. ').where((s) => s.trim().isNotEmpty).map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.endsWith('.') ? s : '$s.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: textSecondary,
                                    height: 1.5,
                                    fontSize: widget.isDesktop ? 13 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Activity Card ────────────────────────────────────────────────────────────

class _ActivityCard extends StatefulWidget {
  final ActivityData activity;
  final bool isLast;
  final bool isDesktop;

  const _ActivityCard({required this.activity, required this.isLast, required this.isDesktop});

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final act = widget.activity;
    final iconData = act.icon == 'school' ? Icons.school_rounded : Icons.code_rounded;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hovered ? primaryGradient : null,
                  color: _hovered ? null : primaryColor.withOpacity(0.5),
                  border: Border.all(color: primaryColor, width: 2),
                ),
              ),
              if (!widget.isLast)
                Container(
                  width: 2,
                  height: 110,
                  margin: const EdgeInsets.only(top: 8),
                  color: primaryColor.withOpacity(0.2),
                ),
            ],
          ),
          const SizedBox(width: 24),

          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 24),
              padding: EdgeInsets.all(widget.isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: _hovered ? cardColor.withOpacity(0.9) : cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hovered ? primaryColor.withOpacity(0.3) : primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor.withOpacity(0.25), width: 1),
                        ),
                        child: Icon(iconData, color: primaryColor, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              act.title,
                              style: AppTextStyles.h5.copyWith(
                                fontSize: widget.isDesktop ? 16 : 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
                              ),
                              child: Text(
                                act.period,
                                style: AppTextStyles.caption.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    act.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textSecondary,
                      height: 1.5,
                      fontSize: widget.isDesktop ? 13 : 12,
                    ),
                  ),
                  if (act.link != null) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(act.link!);
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            act.linkLabel ?? act.link!,
                            style: AppTextStyles.caption.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.open_in_new_rounded, color: primaryColor, size: 12),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Education Card ───────────────────────────────────────────────────────────

class _EducationCard extends StatefulWidget {
  final EducationData edu;
  final bool isDesktop;

  const _EducationCard({required this.edu, required this.isDesktop});

  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(widget.isDesktop ? 24 : 18),
        decoration: BoxDecoration(
          color: _hovered ? cardColor.withOpacity(0.9) : cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? primaryColor.withOpacity(0.3) : primaryColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.25), width: 1),
              ),
              child: Icon(Icons.school_rounded, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.edu.degree,
                    style: AppTextStyles.h5.copyWith(
                      fontSize: widget.isDesktop ? 17 : 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.edu.institution,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: widget.isDesktop ? 13 : 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
              ),
              child: Text(
                widget.edu.period,
                style: AppTextStyles.caption.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: widget.isDesktop ? 11 : 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



