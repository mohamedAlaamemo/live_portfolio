import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet = w > 768 && w <= 1024;
    final hPad = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);
    final experiences = PortfolioData.experiences;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Center(
            child: RichText(
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
                          const Rect.fromLTWH(0, 0, 200, 40),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Experience timeline
          Column(
            children: experiences.asMap().entries.map((entry) {
              final index = entry.key;
              final experience = entry.value;
              final isLast = index == experiences.length - 1;

              return _ExperienceCard(
                experience: experience,
                isLast: isLast,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ExperienceData experience;
  final bool isLast;

  const _ExperienceCard({
    required this.experience,
    required this.isLast,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              // Timeline dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hovered ? primaryGradient : null,
                  color: _hovered ? null : primaryColor.withOpacity(0.5),
                  border: Border.all(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
              ),
              // Timeline line
              if (!widget.isLast)
                Container(
                  width: 2,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8),
                  color: primaryColor.withOpacity(0.2),
                ),
            ],
          ),
          const SizedBox(width: 24),

          // Content
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 32),
              padding: EdgeInsets.all(isDesktop ? 24 : 20),
              decoration: BoxDecoration(
                color: _hovered ? cardColor.withOpacity(0.8) : cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hovered ? primaryColor.withOpacity(0.3) : primaryColor.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job title and period
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.experience.title,
                              style: AppTextStyles.h5.copyWith(
                                fontSize: isDesktop ? 20 : 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.experience.company,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.experience.period,
                          style: AppTextStyles.caption.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.experience.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Technologies
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.experience.technologies
                        .map((tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.25),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tech,
                                style: AppTextStyles.caption.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ))
                        .toList(),
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
