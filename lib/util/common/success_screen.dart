import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessScreen extends StatefulWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Duration animationDuration;
  final Duration displayDuration;
  final Widget? nextPage;
  final VoidCallback? onComplete;
  final bool showProgressIndicator;
  final bool allowManualSkip;
  final List<Color>? backgroundGradient;
  final double iconSize;
  final TextStyle? messageStyle;
  final TextStyle? subtitleStyle;
  final bool hapticFeedback;

  const SuccessScreen({
    Key? key,
    required this.message,
    this.subtitle,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 800),
    this.displayDuration = const Duration(seconds: 2),
    this.nextPage,
    this.onComplete,
    this.showProgressIndicator = false,
    this.allowManualSkip = true,
    this.backgroundGradient,
    this.iconSize = 100,
    this.messageStyle,
    this.subtitleStyle,
    this.hapticFeedback = true,
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Primary animation controller
    _primaryController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: widget.displayDuration,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Slide animation for text
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    // Progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.linear,
      ),
    );

    // Pulse animation for icon
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimationSequence() async {
    // Haptic feedback
    if (widget.hapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    // Start primary animation
    await _primaryController.forward();

    // Start pulse animation (repeating)
    _pulseController.repeat(reverse: true);

    // Start progress animation if enabled
    if (widget.showProgressIndicator) {
      _progressController.forward();
    }

    // Wait for display duration
    await Future.delayed(widget.displayDuration);

    // Complete the screen
    _completeScreen();
  }

  void _completeScreen() {
    if (_isCompleted) return;
    
    setState(() {
      _isCompleted = true;
    });

    if (widget.nextPage != null) {
      Navigator.pushReplacement(
        context,
        _createPageTransition(),
      );
    }

    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  PageRouteBuilder _createPageTransition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget.nextPage!,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: widget.allowManualSkip ? _completeScreen : null,
        child: Container(
          decoration: _buildBackgroundDecoration(),
          child: SafeArea(
            child: Stack(
              children: [
                _buildMainContent(),
                if (widget.showProgressIndicator) _buildProgressIndicator(),
                if (widget.allowManualSkip) _buildSkipButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    if (widget.backgroundGradient != null) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.backgroundGradient!,
        ),
      );
    }
    return BoxDecoration(color: widget.backgroundColor);
  }

  Widget _buildMainContent() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _primaryController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAnimatedIcon(),
                  const SizedBox(height: 30),
                  _buildMessage(),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 12),
                    _buildSubtitle(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return Transform.scale(
      scale: _scaleAnimation.value * _pulseAnimation.value,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.iconColor.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: widget.iconColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        widget.message,
        style: widget.messageStyle ?? 
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        widget.subtitle!,
        style: widget.subtitleStyle ??
          TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Positioned(
      bottom: 60,
      left: 40,
      right: 40,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Column(
            children: [
              LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(widget.iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Auto-redirecting... ${((1 - _progressAnimation.value) * widget.displayDuration.inSeconds).ceil()}s',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value * 0.7,
            child: TextButton(
              onPressed: _completeScreen,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}