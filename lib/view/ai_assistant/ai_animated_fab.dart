import 'dart:math';

import 'package:flutter/material.dart';

class AIAnimatedFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? heroTag;
  
  const AIAnimatedFAB({
    super.key,
    this.onPressed,
    this.heroTag,
  });

  @override
  State<AIAnimatedFAB> createState() => _AIAnimatedFABState();
}

class _AIAnimatedFABState extends State<AIAnimatedFAB>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late AnimationController _sparkleController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _sparkleAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Sparkle animation
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isPressed = true;
    });
    
    // Reset after animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
    
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _rotationController,
        _glowController,
        _sparkleController,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow rings
            for (int i = 0; i < 3; i++)
              Transform.scale(
                scale: _pulseAnimation.value * (1.5 + i * 0.3),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   border: Border.all(
                  //     color: Colors.blue.withOpacity(0.3 - i * 0.1),
                  //     width: 2.0,
                  //   ),
                  // ),
                ),
              ),
            
            // Rotating gradient background
            Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: const [
                      Colors.purple,
                      Colors.blue,
                      Colors.cyan,
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                      Colors.pink,
                      Colors.purple,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(_glowAnimation.value * 0.4),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            
            // Main FAB
            Transform.scale(
              scale: _isPressed ? 0.95 : _pulseAnimation.value,
              child: FloatingActionButton(
                heroTag: widget.heroTag,
                onPressed: _handleTap,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.blue.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // AI brain icon with shimmer
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.purple,
                            Colors.cyan,
                            Colors.blue,
                          ],
                          stops: [
                            _sparkleAnimation.value - 0.3,
                            _sparkleAnimation.value - 0.1,
                            _sparkleAnimation.value + 0.1,
                            _sparkleAnimation.value + 0.3,
                          ],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.psychology_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      
                      // Sparkle particles
                      ...List.generate(8, (index) {
                        final angle = (index * 45) * 3.14159 / 180;
                        final distance = 20.0;
                        return Transform.translate(
                          offset: Offset(
                            cos(angle + _sparkleAnimation.value * 2 * 3.14159) * distance,
                            sin(angle + _sparkleAnimation.value * 2 * 3.14159) * distance,
                          ),
                          child: Transform.scale(
                            scale: (sin(_sparkleAnimation.value * 2 * 3.14159) + 1) / 4 + 0.5,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.6),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            
            // AI text indicator
            Positioned(
              bottom: -25,
              child: AnimatedOpacity(
                opacity: _glowAnimation.value * 0.8,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.cyan,
                      ],
                      stops: [
                        _sparkleAnimation.value - 0.2,
                        _sparkleAnimation.value,
                        _sparkleAnimation.value + 0.2,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// // Usage Example Screen
// class ExampleScreen extends StatelessWidget {
//   const ExampleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AI Animated FAB Demo'),
//         backgroundColor: Colors.blueGrey[900],
//         foregroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.grey[900],
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'AI-Powered Interface',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Tap the AI button to interact',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white70,
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: AIAnimatedFAB(
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Row(
//                 children: [
//                   Icon(Icons.psychology, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text('AI Assistant Activated!'),
//                 ],
//               ),
//               backgroundColor: Colors.purple,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }