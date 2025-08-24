import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Enum for different loading types
enum LoadingType {
  shopping,
  delivery,
  payment,
  upload,
  download,
  search,
  general,
  custom
}

class ReusableLoadingScreen extends StatelessWidget {
  final LoadingType loadingType;
  final String? title;
  final String? subtitle;
  final String? customLottieUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration? duration;
  final VoidCallback? onComplete;
  final Widget? navigateToScreen;
  final String? routeName;
  final bool autoNavigate;
  final double? lottieSize;

  const ReusableLoadingScreen({
    Key? key,
    this.loadingType = LoadingType.general,
    this.title,
    this.subtitle,
    this.customLottieUrl,
    this.backgroundColor,
    this.textColor,
    this.duration,
    this.onComplete,
    this.navigateToScreen,
    this.routeName,
    this.autoNavigate = true,
    this.lottieSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingScreenController(
      loadingType: loadingType,
      title: title,
      subtitle: subtitle,
      customLottieUrl: customLottieUrl,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      onComplete: onComplete,
      navigateToScreen: navigateToScreen,
      routeName: routeName,
      autoNavigate: autoNavigate,
      lottieSize: lottieSize,
    );
  }
}

class LoadingScreenController extends StatefulWidget {
  final LoadingType loadingType;
  final String? title;
  final String? subtitle;
  final String? customLottieUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration? duration;
  final VoidCallback? onComplete;
  final Widget? navigateToScreen;
  final String? routeName;
  final bool autoNavigate;
  final double? lottieSize;

  const LoadingScreenController({
    Key? key,
    required this.loadingType,
    this.title,
    this.subtitle,
    this.customLottieUrl,
    this.backgroundColor,
    this.textColor,
    this.duration,
    this.onComplete,
    this.navigateToScreen,
    this.routeName,
    required this.autoNavigate,
    this.lottieSize,
  }) : super(key: key);

  @override
  State<LoadingScreenController> createState() => _LoadingScreenControllerState();
}

class _LoadingScreenControllerState extends State<LoadingScreenController>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    // Auto navigate after duration
    if (widget.autoNavigate && widget.duration != null) {
      Future.delayed(widget.duration!, () {
        _handleNavigation();
      });
    }
  }

  void _handleNavigation() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    }

    if (widget.navigateToScreen != null) {
      Get.off(() => widget.navigateToScreen!);
    } else if (widget.routeName != null) {
      Get.offNamed(widget.routeName!);
    }
  }

  String _getLottieUrl() {
    if (widget.customLottieUrl != null) {
      return widget.customLottieUrl!;
    }

    switch (widget.loadingType) {
      case LoadingType.shopping:
        return 'https://assets2.lottiefiles.com/packages/lf20_9wpyhdzo.json'; // Shopping cart
      case LoadingType.delivery:
        return 'https://assets2.lottiefiles.com/packages/lf20_jbruce0q.json'; // Delivery truck
      case LoadingType.payment:
        return 'https://assets2.lottiefiles.com/packages/lf20_9d4kzaqg.json'; // Payment processing
      case LoadingType.upload:
        return 'https://assets2.lottiefiles.com/packages/lf20_5e7jcrho.json'; // Upload cloud
      case LoadingType.download:
        return 'https://assets2.lottiefiles.com/packages/lf20_4kx2q32n.json'; // Download
      case LoadingType.search:
        return 'https://assets2.lottiefiles.com/packages/lf20_wp8h3nzo.json'; // Search magnifier
      case LoadingType.general:
        return 'https://assets2.lottiefiles.com/packages/lf20_a2chheio.json'; // General loading
      case LoadingType.custom:
        return 'https://assets2.lottiefiles.com/packages/lf20_a2chheio.json'; // Fallback
    }
  }

  String _getDefaultTitle() {
    switch (widget.loadingType) {
      case LoadingType.shopping:
        return 'Adding to Cart...';
      case LoadingType.delivery:
        return 'Processing Delivery...';
      case LoadingType.payment:
        return 'Processing Payment...';
      case LoadingType.upload:
        return 'Uploading...';
      case LoadingType.download:
        return 'Downloading...';
      case LoadingType.search:
        return 'Searching...';
      case LoadingType.general:
        return 'Loading...';
      case LoadingType.custom:
        return 'Please Wait...';
    }
  }

  String _getDefaultSubtitle() {
    switch (widget.loadingType) {
      case LoadingType.shopping:
        return 'Adding item to your cart';
      case LoadingType.delivery:
        return 'Calculating delivery options';
      case LoadingType.payment:
        return 'Securing your transaction';
      case LoadingType.upload:
        return 'Uploading your files';
      case LoadingType.download:
        return 'Downloading content';
      case LoadingType.search:
        return 'Finding results for you';
      case LoadingType.general:
        return 'This won\'t take long';
      case LoadingType.custom:
        return 'Processing your request';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Container(
                width: widget.lottieSize ?? 200,
                height: widget.lottieSize ?? 200,
                child: Lottie.network(
                  _getLottieUrl(),
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to CircularProgressIndicator if Lottie fails
                    return Container(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.textColor ?? Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                widget.title ?? _getDefaultTitle(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor ?? Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  widget.subtitle ?? _getDefaultSubtitle(),
                  style: TextStyle(
                    fontSize: 16,
                    color: (widget.textColor ?? Colors.black87).withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Optional manual navigation button
              if (!widget.autoNavigate)
                ElevatedButton(
                  onPressed: _handleNavigation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage Examples Class
class LoadingScreenExamples {
  // Example 1: Shopping Cart Loading
  static Widget shoppingExample() {
    return ReusableLoadingScreen(
      loadingType: LoadingType.shopping,
      title: 'Adding to Cart',
      subtitle: 'Your item is being added to cart',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.white,
      textColor: Colors.purple,
      // routeName: '/home', // Navigate to home after loading
    );
  }

  // Example 2: Payment Processing
  static Widget paymentExample() {
    return ReusableLoadingScreen(
      loadingType: LoadingType.payment,
      title: 'Processing Payment',
      subtitle: 'Please wait while we process your payment securely',
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green.shade50,
      textColor: Colors.green.shade800,
      // navigateToScreen: PaymentSuccessScreen(),
    );
  }

  // Example 3: Custom Lottie
  static Widget customExample() {
    return ReusableLoadingScreen(
      loadingType: LoadingType.custom,
      customLottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_your_custom_animation.json',
      title: 'Custom Loading',
      subtitle: 'Using your own Lottie animation',
      duration: const Duration(seconds: 2),
      lottieSize: 250,
      onComplete: () {
        print('Custom loading completed!');
      },
    );
  }

  // Example 4: Manual Navigation
  static Widget manualExample() {
    return ReusableLoadingScreen(
      loadingType: LoadingType.general,
      title: 'Ready to Continue',
      subtitle: 'Tap the button when you\'re ready',
      autoNavigate: false,
      backgroundColor: Colors.blue.shade50,
      textColor: Colors.blue.shade800,
    );
  }
}