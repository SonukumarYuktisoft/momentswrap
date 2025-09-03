import 'dart:async';
import 'package:flutter/material.dart';

/// A highly-reusable animated text widget with multiple built-in effects.
///
/// Supported [AnimatedTextEffect]:
/// - fade
/// - slideUp
/// - slideLeft
/// - scale
/// - typewriter
///
/// Example:
/// ```dart
/// AnimatedText(
///   'Hello Flutter!',
///   effect: AnimatedTextEffect.typewriter,
///   duration: const Duration(milliseconds: 1200),
///   textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
///   loop: true,
/// )
/// ```
class AnimatedText extends StatefulWidget {
  const 
  AnimatedText(
    this.text, {
    super.key,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.duration = const Duration(milliseconds: 900),
    this.curve = Curves.easeInOut,
    this.effect = AnimatedTextEffect.fade,
    this.loop = false,
    this.pause = const Duration(milliseconds: 500),
    this.onFinished,
    this.startDelay = Duration.zero,
  });

  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Duration duration;
  final Curve curve;
  final AnimatedTextEffect effect;
  final bool loop;
  final Duration pause;
  final Duration startDelay;
  final VoidCallback? onFinished;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.effect == AnimatedTextEffect.typewriter
        ? _typewriterDuration
        : widget.duration,
  );

  // For typewriter we animate from 0..text.length
  late Animation<int> _typing;
  Timer? _loopTimer;

  Duration get _typewriterDuration => widget.duration;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _start();
  }

  @override
  void didUpdateWidget(covariant AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final needsRetune = oldWidget.text != widget.text ||
        oldWidget.effect != widget.effect ||
        oldWidget.duration != widget.duration;

    if (needsRetune) {
      _controller.stop();
      _controller.duration = widget.effect == AnimatedTextEffect.typewriter
          ? _typewriterDuration
          : widget.duration;
      _setupAnimation();
      _start();
    }
  }

  void _setupAnimation() {
    if (widget.effect == AnimatedTextEffect.typewriter) {
      _typing = StepTween(begin: 0, end: widget.text.length).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
    }
  }

  Future<void> _start() async {
    if (widget.startDelay > Duration.zero) {
      await Future.delayed(widget.startDelay);
    }

    if (widget.loop) {
      if (widget.effect == AnimatedTextEffect.typewriter) {
        _controller.forward(from: 0.0);
        _controller.addStatusListener(_handleLoopForTypewriter);
      } else {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.forward(from: 0.0).whenComplete(() {
        widget.onFinished?.call();
      });
    }
  }

  void _handleLoopForTypewriter(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _loopTimer?.cancel();
      _loopTimer = Timer(widget.pause, () {
        if (mounted && widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    }
  }

  @override
  void dispose() {
    _loopTimer?.cancel();
    _controller.removeStatusListener(_handleLoopForTypewriter);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.effect) {
      case AnimatedTextEffect.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: widget.curve),
          child: _buildText(widget.text),
        );
      case AnimatedTextEffect.slideUp:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final anim = CurvedAnimation(
              parent: _controller,
              curve: widget.curve,
            );
            return Transform.translate(
              offset: Offset(0, 20 * (1 - anim.value)),
              child: Opacity(opacity: anim.value, child: child),
            );
          },
          child: _buildText(widget.text),
        );
      case AnimatedTextEffect.slideLeft:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final anim = CurvedAnimation(
              parent: _controller,
              curve: widget.curve,
            );
            return Transform.translate(
              offset: Offset(20 * (1 - anim.value), 0),
              child: Opacity(opacity: anim.value, child: child),
            );
          },
          child: _buildText(widget.text),
        );
      case AnimatedTextEffect.scale:
        return ScaleTransition(
          scale: CurvedAnimation(parent: _controller, curve: widget.curve),
          child: _buildText(widget.text),
        );
      case AnimatedTextEffect.typewriter:
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final count = (_typing.value).clamp(0, widget.text.length);
            final visible = widget.text.substring(0, count);
            return RichText(
              textAlign: widget.textAlign ?? TextAlign.start,
              maxLines: widget.maxLines,
              overflow: widget.overflow ?? TextOverflow.clip,
              text: TextSpan(
                style: widget.textStyle ?? DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: visible),
                  // Cursor block
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: _BlinkingCursor(
                      height: (widget.textStyle?.fontSize ??
                          DefaultTextStyle.of(context).style.fontSize ??
                              14) * 0.9,
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _buildText(String value) => Text(
        value,
        style: widget.textStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor({required this.height});
  final double height;

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: widget.height,
        margin: const EdgeInsets.only(left: 2),
        color: DefaultTextStyle.of(context).style.color,
      ),
    );
  }
}

/// --- DEMO PAGE (Optional) ---
/// Drop this into `home:` of MaterialApp to see all effects quickly.
class AnimatedTextDemo extends StatelessWidget {
  const AnimatedTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedText Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Fade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const AnimatedText(
              'Welcome to your shop',
              effect: AnimatedTextEffect.fade,
              duration: Duration(milliseconds: 1200),
              textStyle: TextStyle(fontSize: 22),
              loop: true,
            ),
            const SizedBox(height: 20),

            const Text('Slide Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const AnimatedText(
              'Trending Products',
              effect: AnimatedTextEffect.slideUp,
              textStyle: TextStyle(fontSize: 22),
              loop: true,
            ),
            const SizedBox(height: 20),

            const Text('Slide Left', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const AnimatedText(
              'Limited Time Offer',
              effect: AnimatedTextEffect.slideLeft,
              textStyle: TextStyle(fontSize: 22),
              loop: true,
            ),
            const SizedBox(height: 20),

            const Text('Scale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const AnimatedText(
              'Buy 1 Get 1',
              effect: AnimatedTextEffect.scale,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              loop: true,
            ),
            const SizedBox(height: 20),

            const Text('Typewriter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const AnimatedText(
              'Checkout in seconds...',
              effect: AnimatedTextEffect.typewriter,
              duration: Duration(milliseconds: 1200),
              textStyle: TextStyle(fontSize: 22),
              loop: true,
              pause: Duration(milliseconds: 600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where to use
/// -------------
/// 1) Put this file anywhere in `lib/`.
/// 2) Use `AnimatedText('Hello', effect: AnimatedTextEffect.typewriter)` wherever you need animated headings.

/// Effect options for [AnimatedText].
enum AnimatedTextEffect { fade, slideUp, slideLeft, scale, typewriter }
