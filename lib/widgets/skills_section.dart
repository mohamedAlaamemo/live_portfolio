import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final skills = PortfolioData.skills;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: secondaryBackground,
        border: Border.symmetric(
          horizontal: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
      ),
      child: isDesktop
        ? // Desktop: horizontal scrollable row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: skills.asMap().entries.map((e) {
                  final isLast = e.key == skills.length - 1;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SkillTile(skill: e.value),
                      if (!isLast)
                        Container(
                          width: 1,
                          color: primaryColor.withOpacity(0.1),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          )
        : // Mobile/Tablet: centered grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: skills.map((skill) => _MobileSkillChip(skill: skill)).toList(),
              ),
            ),
          ),
    );
  }
}

class _SkillTile extends StatefulWidget {
  final SkillData skill;
  const _SkillTile({required this.skill});

  @override
  State<_SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<_SkillTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        color: _hovered ? primaryColor.withOpacity(0.06) : Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Text(
              widget.skill.name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: _hovered ? Colors.white : textSecondary,
                fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.skill.isCustom && widget.skill.customType == SkillType.bloc) {
      // Custom Bloc icon using a colored widget icon
      return Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: Color(widget.skill.color).withOpacity(_hovered ? 1.0 : 0.7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.widgets_rounded, color: Colors.white, size: 18),
      );
    }
    if (widget.skill.isCustom && widget.skill.customType == SkillType.api) {
      // REST API icon using a cloud badge
      return Container(
        width: 36, height: 26,
        decoration: BoxDecoration(
          color: Color(widget.skill.color).withOpacity(_hovered ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(widget.skill.color).withOpacity(0.6), width: 1),
        ),
        child: Center(
          child: Text(
            'API',
            style: TextStyle(
              color: Color(widget.skill.color),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }
    return SvgPicture.network(
      widget.skill.iconUrl,
      width: 26,
      height: 26,
      placeholderBuilder: (_) => Icon(
        Icons.code_rounded,
        color: Color(widget.skill.color).withOpacity(0.7),
        size: 26,
      ),
    );
  }
}

class _MobileSkillChip extends StatefulWidget {
  final SkillData skill;
  const _MobileSkillChip({required this.skill});

  @override
  State<_MobileSkillChip> createState() => _MobileSkillChipState();
}

class _MobileSkillChipState extends State<_MobileSkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _hovered ? primaryColor.withOpacity(0.1) : cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? primaryColor.withOpacity(0.4) : primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: 8),
            Text(
              widget.skill.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: _hovered ? Colors.white : textSecondary,
                fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.skill.isCustom && widget.skill.customType == SkillType.bloc) {
      return Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: Color(widget.skill.color).withOpacity(_hovered ? 1.0 : 0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.widgets_rounded, color: Colors.white, size: 14),
      );
    }
    if (widget.skill.isCustom && widget.skill.customType == SkillType.api) {
      return Container(
        width: 28, height: 20,
        decoration: BoxDecoration(
          color: Color(widget.skill.color).withOpacity(_hovered ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(widget.skill.color).withOpacity(0.6), width: 1),
        ),
        child: Center(
          child: Text(
            'API',
            style: TextStyle(
              color: Color(widget.skill.color),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }
    return SvgPicture.network(
      widget.skill.iconUrl,
      width: 20,
      height: 20,
      placeholderBuilder: (_) => Icon(
        Icons.code_rounded,
        color: Color(widget.skill.color).withOpacity(0.7),
        size: 20,
      ),
    );
  }
}
