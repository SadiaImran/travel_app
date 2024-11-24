import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_app/colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Automatically switch pages every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              buildOnBoardPage(
                imagePath: 'images/pngs/image-onboard-1.png',
                imagePathArrow: 'images/pngs/image-arc.png',
                title: 'Life is short and the world is ',
                highlightedWord: 'wide',
                description:
                'As Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world.',
                buttonText: 'Get Started',
              ),
              buildOnBoardPage(
                imagePath: 'images/pngs/image-onboard-2.png',
                imagePathArrow: 'images/pngs/image-arc.png',
                title: 'It’s a big world out there go ',
                highlightedWord: 'explore',
                description:
                'To get the best of your adventure, you just need to leave and go where you like. We are waiting for you.',
                buttonText: 'Next',
              ),
              buildOnBoardPage(
                imagePath: 'images/pngs/image-onboard-3.png',
                imagePathArrow: 'images/pngs/image-arc.png',
                title: 'People don’t take trips, trips take ',
                highlightedWord: 'people',
                description:
                'To get the best of your adventure, you just need to leave and go where you like. We are waiting for you.',
                buttonText: 'Next',
              ),
            ],
          ),
          // Carousel Bars
          Positioned(
            bottom: 114,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) {
                  return InkWell(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: buildCarouselBar(index == _currentPage),
                  );
                },
              ),
            )

          ),
        ],
      ),
    );
  }

  Widget buildCarouselBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.onBoardButtonBlue
            : AppColors.onBoardCarouselInActiveBlue,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget buildOnBoardPage({
    required String imagePath,
    required String imagePathArrow,
    required String title,
    required String highlightedWord,
    required String description,
    required String buttonText,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image Section
        Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.fill,
        ),

        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: RichText(
            textAlign: TextAlign.center,
            text : TextSpan(
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: 'Abel'
              ),
              children: <TextSpan> [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: AppColors.onBoardTextBlack,
                  ),
                ),
                TextSpan(
                  text: highlightedWord,
                  style: const TextStyle(
                    color: AppColors.onBoardTextOrange,
                  ),
                ),
              ],
            ),
          ),
        ),

        Image.asset(
          imagePathArrow,
          alignment: Alignment.centerRight,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.onBoardTextGray,
              fontFamily: 'GillSansMT',
            ),
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: ElevatedButton(
            onPressed: () {
              print("Button pressed !");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onBoardButtonBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 120, vertical: 18),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontFamily: 'SFUIDisplay',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
