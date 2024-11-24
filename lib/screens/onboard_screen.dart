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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // Onboarding Screen 1
          buildOnBoardPage(
            imagePath: 'images/pngs/image-onboard-1.png',
            imagePathArrow: 'images/pngs/image-arc.png',
            title: 'Life is short and the world is ',
            highlightedWord: 'wide',
            description:
            'As Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world.',
            buttonText: 'Get Started',
          ),
          // Onboarding Screen 2
          buildOnBoardPage(
            imagePath: 'images/pngs/image-onboard-2.png',
            imagePathArrow: 'images/pngs/image-arc.png',
            title: 'It’s a big world out there go ',
            highlightedWord: 'explore',
            description:
            'To get the best of your adventure, you just need to leave and go where you like. We are waiting for you.',
            buttonText: 'Next',
          ),
          // Onboarding Screen 3
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
    );
  }

  Widget buildOnBoardPage({
    required String imagePath,
    required String imagePathArrow ,
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

        // Title Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onBoardTextBlack,
                    fontFamily: 'Abel',
                  ),
                ),
                TextSpan(
                  text: highlightedWord,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onBoardTextOrange,
                    fontFamily: 'Abel',
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),


        Image.asset(
          imagePathArrow,
          alignment: Alignment.centerRight,
          fit: BoxFit.contain,
        ),
         const SizedBox(height: 10),

        // Description Section
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
          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 25),
          child: ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onBoardButtonBlue, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 18),
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
