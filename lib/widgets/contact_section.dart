import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1024;
    final isTablet = w > 768 && w <= 1024;
    final hPad = isDesktop ? 80.0 : (isTablet ? 40.0 : 24.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 0),
      margin: const EdgeInsets.only(bottom: 0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 24,
          vertical: isDesktop ? 40 : 32,
        ),
        decoration: BoxDecoration(
          color: secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(color: primaryColor.withOpacity(0.06), blurRadius: 40, spreadRadius: 5),
          ],
        ),
        child: isDesktop
            ? Row(
                children: [
                  // Left: CTA text
                  Expanded(
                    flex: 3,
                    child: _CtaText(),
                  ),

                  // Center: contact info
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: _ContactItem(
                            icon: Icons.email_outlined,
                            label: PortfolioData.email,
                            iconColor: primaryColor,
                            onTap: () => _launchUrl('mailto:${PortfolioData.email}'),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Flexible(
                          child: _ContactItem(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: PortfolioData.phone,
                            iconColor: const Color(0xFF25D366),
                            onTap: () => _launchUrl(PortfolioData.whatsappUrl),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right: button
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ContactMeButton(onTap: () {}),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _CtaText(centered: true),
                  const SizedBox(height: 28),
                  _ContactItem(
                    icon: Icons.email_outlined,
                    label: PortfolioData.email,
                    iconColor: primaryColor,
                    onTap: () => _launchUrl('mailto:${PortfolioData.email}'),
                  ),
                  const SizedBox(height: 16),
                  _ContactItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: PortfolioData.phone,
                    iconColor: const Color(0xFF25D366),
                    onTap: () => _launchUrl(PortfolioData.whatsappUrl),
                  ),
                  const SizedBox(height: 28),
                  _ContactMeButton(onTap: () {}),
                ],
              ),
      ),
    );
  }
}

class _CtaText extends StatelessWidget {
  final bool centered;
  const _CtaText({this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Let's work ",
                style: AppTextStyles.h4.copyWith(fontSize: 24, color: Colors.white),
              ),
              TextSpan(
                text: 'together',
                style: AppTextStyles.h4.copyWith(
                  fontSize: 24,
                  foreground: Paint()
                    ..shader = primaryGradient.createShader(const Rect.fromLTWH(0, 0, 160, 30)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Have a project in mind? Let\'s build something great!',
          style: AppTextStyles.bodySmall.copyWith(color: textSecondary, fontSize: 13),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }
}

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
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
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(_hovered ? 0.2 : 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: widget.iconColor.withOpacity(0.4), width: 1),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 17),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _hovered ? Colors.white : textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactMeButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ContactMeButton({required this.onTap});

  @override
  State<_ContactMeButton> createState() => _ContactMeButtonState();
}

class _ContactMeButtonState extends State<_ContactMeButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [BoxShadow(color: glowColor.withOpacity(0.45), blurRadius: 20, spreadRadius: 2)]
                : [BoxShadow(color: glowColor.withOpacity(0.15), blurRadius: 10)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Me',
                style: AppTextStyles.buttonPrimary.copyWith(fontSize: 14),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
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
