import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:memo_portfolio/widgets/animations.dart';

// ── per-category config (no pink) ────────────────────────────────────────────
class _Cfg {
  final IconData icon;
  final Color color;
  const _Cfg(this.icon, this.color);
}

const List<_Cfg> _cfgs = [
  _Cfg(Icons.terminal_rounded,       Color(0xFF38BDF8)), // Core      – sky
  _Cfg(Icons.psychology_rounded,     Color(0xFF818CF8)), // CS        – indigo
  _Cfg(Icons.phone_android_rounded,  Color(0xFF34D399)), // Flutter   – emerald
  _Cfg(Icons.account_tree_rounded,   Color(0xFFF59E0B)), // Arch      – amber
  _Cfg(Icons.translate_rounded,      Color(0xFF94A3B8)), // Languages – slate
];

// ─────────────────────────────────────────────────────────────────────────────
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w         = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet  = w > 768 && w <= 1024;
    final hPad      = isDesktop ? 80.0 : (isTablet ? 40.0 : 20.0);
    final cats      = PortfolioData.skillCategories;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,       // ← title LEFT
        children: [

          // ── Title (left-aligned) ──────────────────────────────────────────
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'My ',
                style: AppTextStyles.h3.copyWith(
                  fontSize: isDesktop ? 36 : 28,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Skills',
                style: AppTextStyles.h3.copyWith(
                  fontSize: isDesktop ? 36 : 28,
                  foreground: Paint()
                    ..shader = primaryGradient
                        .createShader(const Rect.fromLTWH(0, 0, 160, 40)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),

          // subtle underline accent
          Container(
            width: isDesktop ? 56 : 44,
            height: 3,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),

          // ── Skill categories ─────────────────────────────────────────────
          ...List.generate(cats.length, (i) => StaggeredItem(
            index: i,
            direction: StaggerDirection.alternating,
            baseDelay: const Duration(milliseconds: 150),
            child: _SkillRow(
              category: cats[i],
              cfg: _cfgs[i],
              isDesktop: isDesktop,
              isLast: i == cats.length - 1,
            ),
          )),
        ],
      ),
    );
  }
}

// ─── One skill row ────────────────────────────────────────────────────────────
class _SkillRow extends StatefulWidget {
  final SkillCategory category;
  final _Cfg cfg;
  final bool isDesktop;
  final bool isLast;

  const _SkillRow({
    required this.category,
    required this.cfg,
    required this.isDesktop,
    required this.isLast,
  });

  @override
  State<_SkillRow> createState() => _SkillRowState();
}

class _SkillRowState extends State<_SkillRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent  = widget.cfg.color;
    final w       = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── row ──────────────────────────────────────────────────────────
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isDesktop ? 20 : 14,
              vertical:   widget.isDesktop ? 20 : 16,
            ),
            decoration: BoxDecoration(
              color: _hovered
                  ? accent.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border(
                left: BorderSide(
                  color: _hovered ? accent : accent.withOpacity(0.35),
                  width: 3,
                ),
              ),
            ),
            child: isMobile
                // mobile: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(cfg: widget.cfg, name: widget.category.name,
                          isDesktop: widget.isDesktop),
                      const SizedBox(height: 12),
                      _ChipWrap(skills: widget.category.skills,
                          accent: accent, isDesktop: widget.isDesktop),
                    ],
                  )
                // desktop/tablet: side by side
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: widget.isDesktop ? 210 : 170,
                        child: _Header(cfg: widget.cfg, name: widget.category.name,
                            isDesktop: widget.isDesktop),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _ChipWrap(skills: widget.category.skills,
                            accent: accent, isDesktop: widget.isDesktop),
                      ),
                    ],
                  ),
          ),
        ),

        // ── divider (not after last) ──────────────────────────────────────
        if (!widget.isLast)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.isDesktop ? 4 : 2,
              horizontal: widget.isDesktop ? 20 : 14,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
      ],
    );
  }
}

// ── Category header (icon + label) ───────────────────────────────────────────
class _Header extends StatelessWidget {
  final _Cfg cfg;
  final String name;
  final bool isDesktop;
  const _Header({required this.cfg, required this.name, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:  isDesktop ? 38 : 32,
          height: isDesktop ? 38 : 32,
          decoration: BoxDecoration(
            color: cfg.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(cfg.icon, color: cfg.color, size: isDesktop ? 18 : 15),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: isDesktop ? 14 : 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Chip wrap ─────────────────────────────────────────────────────────────────
class _ChipWrap extends StatelessWidget {
  final List<String> skills;
  final Color accent;
  final bool isDesktop;
  const _ChipWrap({required this.skills, required this.accent, required this.isDesktop});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills
            .map((s) => _Chip(label: s, accent: accent, isDesktop: isDesktop))
            .toList(),
      );
}

// ── Chip ──────────────────────────────────────────────────────────────────────
class _Chip extends StatefulWidget {
  final String label;
  final Color accent;
  final bool isDesktop;
  const _Chip({required this.label, required this.accent, required this.isDesktop});

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.accent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isDesktop ? 12 : 9,
          vertical:   widget.isDesktop ? 6  : 4,
        ),
        decoration: BoxDecoration(
          color:  _hovered ? a.withOpacity(0.15) : a.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? a.withOpacity(0.55) : a.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTextStyles.caption.copyWith(
            color: _hovered ? Colors.white : a.withOpacity(0.85),
            fontWeight: FontWeight.w500,
            fontSize: widget.isDesktop ? 12 : 11,
          ),
        ),
      ),
    );
  }
}
