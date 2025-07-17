import 'package:besafe/core/constants/app_constants.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
 

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late AnimationController _textController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Fade animation for the entire screen
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Slide animation for text elements
    _slideController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    // Button animation
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.bounceOut),
    );

    // Text animation
    _textController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );
  }
void _startAnimations() {
  _fadeController.forward();
  Future.delayed(Duration(milliseconds: 300), () {
    if (mounted) _slideController.forward(); // Add mounted check
  });
  Future.delayed(Duration(milliseconds: 800), () {
    if (mounted) _textController.forward(); // Add mounted check
  });
  Future.delayed(Duration(milliseconds: 1200), () {
    if (mounted) _buttonController.forward(); // Add mounted check
  });
}

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
  Provider.of<SubscriptionService>(context, listen: false).completeOnboarding();
  // Navigation will happen automatically due to Consumer in MyApp
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.8,
              colors: [
                Color(0xFF2D1B69).withOpacity(0.8),
                Color.fromARGB(255, 72, 61, 155).withOpacity(0.5),
                Color.fromARGB(255, 47, 39, 106).withOpacity(0.5),
                Color(0xFF0A0A0F),
                Color(0xFF0A0A0F),
              ],
              stops: [0.0, 0.25, 0.50, 0.99, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Animated Background Image
              AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                child: Image.asset(
                  "assets/onboard-bg.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              
              // Animated Main Content
              SlideTransition(
                position: _slideAnimation,
                child: AnimatedTextSection(
                  animation: _textOpacityAnimation,
                ),
              ),
              
              SizedBox(height: 40),
              
              // Animated Subtitle
              FadeTransition(
                opacity: _textOpacityAnimation,
                child: AnimatedSubtitle(),
              ),
              
              Spacer(flex: 3),
              
              // Animated Buttons
              ScaleTransition(
                scale: _buttonScaleAnimation,
                child: AnimatedButtonSection(
                  onRegistPressed: () {
                    _finishOnboarding();
                    // Navigate to registration page
                    Navigator.pushNamed(context, '/login');
                  },
                  onGetPressed: () {
                    _finishOnboarding();
                    // Navigate to home page
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                   
                ),
              ),
              
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Components

class AnimatedTextSection extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedTextSection({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedText(
            text: 'Easy for',
            delay: Duration(milliseconds: 0),
          ),
          AnimatedText(
            text: 'Beginners,',
            delay: Duration(milliseconds: 200),
          ),
          AnimatedText(
            text: 'Powerful for All',
            delay: Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final Duration delay;

  const AnimatedText({Key? key, required this.text, required this.delay}) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w300,
                height: 1.1,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedSubtitle extends StatefulWidget {
  @override
  _AnimatedSubtitleState createState() => _AnimatedSubtitleState();
}

class _AnimatedSubtitleState extends State<AnimatedSubtitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        'Effortless Investing for Everyone:\nDiscover How Simple Steps\nCan Make Financial Growth Easy',
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }
}

class AnimatedButtonSection extends StatelessWidget {
  final VoidCallback onRegistPressed;
  final VoidCallback onGetPressed;

  const AnimatedButtonSection({Key? key,
    required this.onRegistPressed,
    required this.onGetPressed,
   }) : super(key: key);
   @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedButton(
          text: 'REGISTER',
          isOutlined: false,
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle login
            onRegistPressed();
          },
          delay: Duration(milliseconds: 0),
        ),
        AnimatedButton(
          text: 'GET STARTED',
          isOutlined: true,
          onPressed:  () {
            HapticFeedback.lightImpact();
            // Handle get started
            onGetPressed();
          },
          delay: Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final bool isOutlined;
  final VoidCallback onPressed;
  final Duration delay;

  const AnimatedButton({
    Key? key,
    required this.text,
    required this.isOutlined,
    required this.onPressed,
    required this.delay,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              height: 50,
              child: widget.isOutlined
                  ? OutlinedButton(
                      onPressed: widget.onPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: ButtonText(text: widget.text, isOutlined: true),
                    )
                  : ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF0A0A0F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: ButtonText(text: widget.text, isOutlined: false),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class ButtonText extends StatelessWidget {
  final String text;
  final bool isOutlined;

  const ButtonText({Key? key, required this.text, required this.isOutlined}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isOutlined ? Colors.white : Color(0xFF0A0A0F),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
 