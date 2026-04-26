import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math' show Random;
import 'package:memo_portfolio/constants/colors.dart';

// ════════════════════════════════════════════════════════════════════════════
// Floating Particles Background
// ════════════════════════════════════════════════════════════════════════════
class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<FloatingParticle> particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Generate floating particles
    for (int i = 0; i < 50; i++) {
      particles.add(FloatingParticle(_random));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FloatingParticlesPainter(particles, _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FloatingParticle {
  double x, y;
  double size;
  double speedX, speedY;
  Color color;
  double opacity;

  FloatingParticle(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble(),
        size = 1 + random.nextDouble() * 3,
        speedX = (random.nextDouble() - 0.5) * 0.02,
        speedY = -random.nextDouble() * 0.01 - 0.005,
        color = [primaryColor, accentColor, Colors.white][random.nextInt(3)],
        opacity = 0.3 + random.nextDouble() * 0.4;
}

class FloatingParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;

  FloatingParticlesPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = ((particle.x + animationValue * particle.speedX) % 1.0) * size.width;
      final y = ((particle.y + animationValue * particle.speedY) % 1.0) * size.height;

      paint.color = particle.color.withOpacity(particle.opacity);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ════════════════════════════════════════════════════════════════════════════
// Animated Background Blobs
// ════════════════════════════════════════════════════════════════════════════
class AnimatedBackgroundBlobs extends StatefulWidget {
  const AnimatedBackgroundBlobs({super.key});

  @override
  State<AnimatedBackgroundBlobs> createState() => _AnimatedBackgroundBlobsState();
}

class _AnimatedBackgroundBlobsState extends State<AnimatedBackgroundBlobs>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 3000 + index * 1000),
        vsync: this,
      )..repeat(reverse: true);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Blob 1
          AnimatedBuilder(
            animation: _animations[0],
            builder: (context, child) {
              return Positioned(
                top: -100 + _animations[0].value * 50,
                right: -120 + _animations[0].value * 40,
                child: Transform.rotate(
                  angle: _animations[0].value * math.pi * 2,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Blob 2
          AnimatedBuilder(
            animation: _animations[1],
            builder: (context, child) {
              return Positioned(
                top: 300 + _animations[1].value * 60,
                left: -140 + _animations[1].value * 30,
                child: Transform.rotate(
                  angle: -_animations[1].value * math.pi * 1.5,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Blob 3
          AnimatedBuilder(
            animation: _animations[2],
            builder: (context, child) {
              return Positioned(
                bottom: 150 + _animations[2].value * 40,
                right: -80 + _animations[2].value * 50,
                child: Transform.rotate(
                  angle: _animations[2].value * math.pi * 3,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Section Entrance Animations
// ════════════════════════════════════════════════════════════════════════════
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final AnimationType animationType;

  const AnimatedSection({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 200),
    this.animationType = AnimationType.fadeInUp,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

enum AnimationType { fadeInUp, fadeInDown, fadeInLeft, fadeInRight, scaleIn, slideInUp }

// ════════════════════════════════════════════════════════════════════════════
// Staggered Item Animation – يستخدم داخل الأقسام لكل عنصر على حدة
// ════════════════════════════════════════════════════════════════════════════
class StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index; // index العنصر لحساب الـ delay تلقائياً
  final StaggerDirection direction; // الاتجاه
  final Duration baseDelay;

  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.direction = StaggerDirection.alternating,
    this.baseDelay = const Duration(milliseconds: 120),
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

enum StaggerDirection { fromLeft, fromRight, fromTop, fromBottom, alternating, random }

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
    );

    // تحديد الاتجاه بناءً على الـ direction و index
    Offset begin;
    switch (widget.direction) {
      case StaggerDirection.fromLeft:
        begin = const Offset(-1.2, 0);
        break;
      case StaggerDirection.fromRight:
        begin = const Offset(1.2, 0);
        break;
      case StaggerDirection.fromTop:
        begin = const Offset(0, -1.2);
        break;
      case StaggerDirection.fromBottom:
        begin = const Offset(0, 1.2);
        break;
      case StaggerDirection.alternating:
        // يمين وشمال بالتناوب
        begin = widget.index.isEven
            ? const Offset(-1.2, 0)
            : const Offset(1.2, 0);
        break;
      case StaggerDirection.random:
        // تنوع بين 4 اتجاهات بناءً على index
        final directions = [
          const Offset(-1.2, 0),   // يسار
          const Offset(1.2, 0),    // يمين
          const Offset(0, -1.2),   // فوق
          const Offset(0, 1.2),    // تحت
        ];
        begin = directions[widget.index % 4];
        break;
    }

    _slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // delay بناءً على الـ index
    Future.delayed(widget.baseDelay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // مدة أطول قليلاً للتأثير الأقوى
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart), // تأثير أقوى
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5, // يبدأ أصغر للتأثير الدرامي
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Configure slide animation based on type
    Offset beginOffset;
    switch (widget.animationType) {
      case AnimationType.fadeInUp:
      case AnimationType.slideInUp:
        beginOffset = const Offset(0, 0.8); // من الأسفل - مسافة أكبر
        break;
      case AnimationType.fadeInDown:
        beginOffset = const Offset(0, -0.8); // من الأعلى - مسافة أكبر
        break;
      case AnimationType.fadeInLeft:
        beginOffset = const Offset(-0.8, 0); // من اليسار - مسافة أكبر
        break;
      case AnimationType.fadeInRight:
        beginOffset = const Offset(0.8, 0); // من اليمين - مسافة أكبر
        break;
      case AnimationType.scaleIn:
        beginOffset = Offset.zero;
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget animatedChild = widget.child;

        if (widget.animationType == AnimationType.scaleIn) {
          animatedChild = Transform.scale(
            scale: _scaleAnimation.value,
            child: animatedChild,
          );
        } else {
          animatedChild = SlideTransition(
            position: _slideAnimation,
            child: animatedChild,
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: animatedChild,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Hover Scale Animation
// ════════════════════════════════════════════════════════════════════════════
class HoverScaleWidget extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const HoverScaleWidget({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<HoverScaleWidget> createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<HoverScaleWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Pulse Animation
// ════════════════════════════════════════════════════════════════════════════
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

