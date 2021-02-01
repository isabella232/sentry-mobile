import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../screens/login/login_screen.dart';
import '../../utils/sentry_colors.dart';
import 'onboarding_detail_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final _pageController = PageController();
  final _onboardingDetailScreens = <Widget>[
    OnboardingDetailScreen('Lorem Ipsum', 'At vero eos et accusam et justo duo dolores et ea rebum.'),
    OnboardingDetailScreen('Lorem Ipsum', 'At vero eos et accusam et justo duo dolores et ea rebum.'),
    OnboardingDetailScreen('Lorem Ipsum', 'At vero eos et accusam et justo duo dolores et ea rebum.'),
    LoginScreen()
  ];

  var _currentPage = 0;

  void updateCurrentPage(int page) {
    _currentPage = page;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: [
          Visibility(
            visible: _currentPage < _onboardingDetailScreens.length - 1,
            child: FlatButton(
                child: Text('Skip', style: TextStyle(color: SentryColors.rum)),
                onPressed: () {
                  final lastPageIndex = _onboardingDetailScreens.length - 1;
                  _pageController.animateToPage(
                      lastPageIndex,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut
                  );
                  updateCurrentPage(lastPageIndex);
                }
            ),
          )
        ],
      ),
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingDetailScreens.length,
              onPageChanged: (int page) {
                updateCurrentPage(page);
              },
              itemBuilder: (context, index) {
                return _onboardingDetailScreens[index];
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < _onboardingDetailScreens.length; i++)
                    i == _currentPage ? _circleIndicator(true) : _circleIndicator(false),
                ],
              ),
            )
          ]
      ),
    );
  }

  Widget _circleIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? SentryColors.rum : SentryColors.rum.withAlpha((256 * 0.2).toInt()),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}