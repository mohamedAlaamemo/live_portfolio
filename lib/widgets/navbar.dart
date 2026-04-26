import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';
class CustomNavBar extends StatefulWidget {
  final Function(String) onMenuTap;
  final String selectedSection;

  const CustomNavBar({
    super.key,
    required this.onMenuTap,
    this.selectedSection = 'Home',
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool isMobileMenuOpen = false;

  final List<String> menuItems = [
    'Home', 'About', 'Skills', 'Projects', 'Experience', 'Contact',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.97),
            border: Border(
              bottom: BorderSide(color: primaryColor.withOpacity(0.12), width: 1),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              // Logo
              GestureDetector(
                onTap: () => widget.onMenuTap('Home'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(gradient: primaryGradient, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.code_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      PortfolioData.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textPrimary, fontWeight: FontWeight.w700, fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              if (isDesktop) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: menuItems.map((item) => _NavItem(
                    label: item,
                    isSelected: widget.selectedSection == item,
                    onTap: () => widget.onMenuTap(item),
                  )).toList(),
                ),
                const SizedBox(width: 16),
                _DownloadCvButton(onPressed: () async {
                  final uri = Uri.parse(PortfolioData.cvDownloadUrl);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }),
              ] else ...[
                GestureDetector(
                  onTap: () => setState(() => isMobileMenuOpen = !isMobileMenuOpen),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
                    ),
                    child: Icon(
                      isMobileMenuOpen ? Icons.close_rounded : Icons.menu_rounded,
                      color: textPrimary, size: 22,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Mobile menu dropdown
        if (!isDesktop && isMobileMenuOpen)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(color: primaryColor.withOpacity(0.12), width: 1),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                ...menuItems.map((item) => _MobileNavItem(
                  label: item,
                  isSelected: widget.selectedSection == item,
                  onTap: () {
                    widget.onMenuTap(item);
                    setState(() => isMobileMenuOpen = false);
                  },
                )),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _DownloadCvButton(onPressed: () async {
                    final uri = Uri.parse(PortfolioData.cvDownloadUrl);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    setState(() => isMobileMenuOpen = false);
                  }),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.isSelected, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: active ? Colors.white : textSecondary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: active ? 24 : 0,
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadCvButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _DownloadCvButton({required this.onPressed});

  @override
  State<_DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<_DownloadCvButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: _hovered ? primaryGradient : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? Colors.transparent : primaryColor.withOpacity(0.7),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: glowColor.withOpacity(0.4), blurRadius: 16, spreadRadius: 1)]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, color: _hovered ? Colors.white : primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(
                'Download CV',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _hovered ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileNavItem({required this.label, required this.isSelected, required this.onTap});

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: active ? primaryColor.withOpacity(0.1) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: active ? primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: active ? Colors.white : textSecondary,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
