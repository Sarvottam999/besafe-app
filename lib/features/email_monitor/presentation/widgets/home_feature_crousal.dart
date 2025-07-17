import 'package:flutter/material.dart';

class ModernCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final Duration autoPlayDuration;
  final bool autoPlay;

  const ModernCarousel({
    Key? key,
    required this.items,
    this.height = 200,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.autoPlay = true,
  }) : super(key: key);

  @override
  State<ModernCarousel> createState() => _ModernCarouselState();
}

class _ModernCarouselState extends State<ModernCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayDuration, () {
      if (mounted) {
        _nextPage();
        _startAutoPlay();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < widget.items.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPage(int index) {
    setState(() {
      _currentPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return CarouselSlide(item: widget.items[index]);
              },
            ),
            // _buildTopNavigation(),
            _buildBottomContent(),
            _buildPageIndicator(),
            // _buildSocialIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BrandLogo(),
          Row(
            children: [
              _buildNavItem('WORK'),
              const SizedBox(width: 24),
              _buildNavItem('ABOUT'),
              const SizedBox(width: 24),
              _buildNavItem('CONTACT'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBottomContent() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.items[_currentPage].category,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.items[_currentPage].title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          const CTAButton(text: "BUT PRO"),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        children: [
          Text(
            '${(_currentPage + 1).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '/',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          Text(
            widget.items.length.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        children: [
          _buildSocialIcon(Icons.facebook),
          const SizedBox(height: 12),
          _buildSocialIcon(Icons.camera_alt),
          const SizedBox(height: 12),
          _buildSocialIcon(Icons.language),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 12,
      ),
    );
  }
}

class CarouselSlide extends StatelessWidget {
  final CarouselItem item;

  const CarouselSlide({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHOW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        Container(
          width: 20,
          height: 2,
          color: Colors.white,
        ),
        const Text(
          '1336',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class CTAButton extends StatelessWidget {
  final String text;

  const CTAButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String category;
  final String imageUrl;

  CarouselItem({
    required this.title,
    required this.category,
    required this.imageUrl,
  });
}

