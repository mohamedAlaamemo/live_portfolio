import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';

// ── Skill item model ──────────────────────────────────────────────────────────
class _Skill {
  final String name;
  final String? svgUrl;   // null → use custom widget
  final Color color;
  final bool isCustom;
  final String? customLabel; // for badge-style icons

  const _Skill(this.name, this.svgUrl, this.color,
      {this.isCustom = false, this.customLabel});
}

const _skills = <_Skill>[
  _Skill('Flutter',  'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg',   Color(0xFF54C5F8)),
  _Skill('Dart',     'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg',         Color(0xFF01589B)),
  _Skill('Firebase', 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg',    Color(0xFFFFCA28)),
  _Skill('BLoC',     null, Color(0xFF4ECDC4),   isCustom: true, customLabel: 'B'),
  _Skill('REST API', null, Color(0xFF6366F1),   isCustom: true, customLabel: 'API'),
  _Skill('Dio',      null, Color(0xFF818CF8),   isCustom: true, customLabel: 'DIO'),
  _Skill('Git',      'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg',           Color(0xFFF05032)),
  _Skill('SQLite',   'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sqlite/sqlite-original.svg',     Color(0xFF44A1C9)),
  _Skill('Figma',    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg',       Color(0xFFEC4899)),
  _Skill('Maps',     null, Color(0xFF34D399),   isCustom: true, customLabel: '📍'),
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──────────────────────────────────────────────────────────
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
          Container(
            width: isDesktop ? 56 : 44,
            height: 3,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 36),

          // ── Skill bar ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F1624),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: isDesktop
                // Desktop: all visible, centered
                ? _SkillBarRow(skills: _skills, isDesktop: true)
                // Mobile/tablet: horizontally scrollable
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: _SkillBarRow(skills: _skills, isDesktop: false),
                  ),
          ),

          const SizedBox(height: 20),

          // ── Additional skills as compact chips ─────────────────────────────
          _AdditionalSkills(isDesktop: isDesktop),
        ],
      ),
    );
  }
}

// ── Bar Row ───────────────────────────────────────────────────────────────────
class _SkillBarRow extends StatelessWidget {
  final List<_Skill> skills;
  final bool isDesktop;
  const _SkillBarRow({required this.skills, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.start,
        children: [
          for (int i = 0; i < skills.length; i++) ...[
            _SkillTile(skill: skills[i], isDesktop: isDesktop),
            if (i < skills.length - 1)
              Container(
                width: 1,
                color: Colors.white.withOpacity(0.07),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Skill Tile ────────────────────────────────────────────────────────────────
class _SkillTile extends StatefulWidget {
  final _Skill skill;
  final bool isDesktop;
  const _SkillTile({required this.skill, required this.isDesktop});

  @override
  State<_SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<_SkillTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.skill;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isDesktop ? 28 : 22,
          vertical:   widget.isDesktop ? 22 : 18,
        ),
        decoration: BoxDecoration(
          color: _hovered ? s.color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _hovered ? 1.15 : 1.0,
              child: SizedBox(
                width:  widget.isDesktop ? 28 : 24,
                height: widget.isDesktop ? 28 : 24,
                child: _buildIcon(s, widget.isDesktop),
              ),
            ),
            SizedBox(width: widget.isDesktop ? 10 : 8),
            // name
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: widget.isDesktop ? 15 : 13,
                color: _hovered ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(s.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(_Skill s, bool isDesktop) {
    if (s.isCustom) {
      // Badge-style icon
      return Container(
        decoration: BoxDecoration(
          color: s.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: s.color.withOpacity(0.4), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          s.customLabel ?? '',
          style: TextStyle(
            color: s.color,
            fontSize: (s.customLabel?.length ?? 1) > 2 ? 7 : 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      );
    }
    // SVG icon
    return SvgPicture.network(
      s.svgUrl!,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => Container(
        decoration: BoxDecoration(
          color: s.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(Icons.code_rounded, color: s.color, size: 16),
      ),
    );
  }
}

// ── Additional skills (compact chips below the bar) ───────────────────────────
class _AdditionalSkills extends StatelessWidget {
  final bool isDesktop;
  const _AdditionalSkills({required this.isDesktop});

  static const _extra = [
    'MVVM', 'Clean Architecture', 'BLoC / Cubit', 'Dependency Injection',
    'Caching APIs', 'Hive', 'Shared Preferences', 'Local Notifications',
    'FCM', 'Paymob', 'Stripe', 'Localisation', 'Null Safety',
    'OOP', 'Data Structures', 'Algorithms', 'SOLID Principles',
    'Arabic (Native)', 'English',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _extra.map((s) => _ExtraChip(label: s, isDesktop: isDesktop)).toList(),
    );
  }
}

class _ExtraChip extends StatefulWidget {
  final String label;
  final bool isDesktop;
  const _ExtraChip({required this.label, required this.isDesktop});

  @override
  State<_ExtraChip> createState() => _ExtraChipState();
}

class _ExtraChipState extends State<_ExtraChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isDesktop ? 12 : 10,
          vertical:   widget.isDesktop ? 6  : 5,
        ),
        decoration: BoxDecoration(
          color: _hovered
              ? primaryColor.withOpacity(0.12)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? primaryColor.withOpacity(0.45)
                : Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTextStyles.caption.copyWith(
            color: _hovered ? Colors.white : Colors.white.withOpacity(0.55),
            fontWeight: FontWeight.w500,
            fontSize: widget.isDesktop ? 12 : 11,
          ),
        ),
      ),
    );
  }
}
