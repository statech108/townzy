import 'dart:async';
import 'package:flutter/material.dart';

class AdCard {
  final String imageUrl;
  final String? link;

  AdCard({
    required this.imageUrl,
    this.link,
  });
}

// Simulated ads list
Future<List<AdCard>> fetchMockAds() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    AdCard(
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/4/45/A_small_cup_of_coffee.JPG",
    ),
    AdCard(
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
    ),
    AdCard(
      imageUrl: "https://www.pngkey.com/png/detail/217-2175021_get-any-groceries-you-want-in-your-city.png",
    ),
  ];
}

class Ads extends StatefulWidget {
  const Ads({super.key});

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  List<AdCard> _ads = [];

  @override
  void initState() {
    super.initState();
    fetchMockAds().then((ads) {
      setState(() => _ads = ads);
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_ads.isEmpty || !_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % _ads.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: _ads.length,
        itemBuilder: (context, index) {
          final ad = _ads[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ad.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          );
        },
      ),
    );
  }
}