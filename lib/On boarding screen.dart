import 'package:expense_tracker/On%20boarding%20screen.dart';
import 'package:expense_tracker/signin.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController=PageController();
  int _currentPage=0;
  final List<OnboardingPage>_pages=[
    OnboardingPage(title: "Track Your Expenses",
        description: "Keep track of every peny with our intuitive expense tracking system",
        color: Color(0xFF4A90E2), icon: Icons.account_balance_wallet),
    OnboardingPage(title: "BE easier to manage your own money",
        description: "Just using your phone, you can manage all your payments more easily and faster",
        color: Color(0xFF50E3C2), icon: Icons.pie_chart),
    OnboardingPage(title: "Analyze Spending",
        description: "Get detailed insights about your spending habits with beautiful charts",
        color: Color(0xFFE3506F), icon: Icons.bar_chart),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
          PageView.builder(controller: _pageController,
          itemCount: _pages.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            return _buildPage(_pages[index]);
          },
        ),
        Positioned(bottom: 48.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            SizedBox(height: 32,),

            if(_currentPage==_pages.length-1)
        _buildGetStartedButton()
    else
    _buildNextButton(),
    ],
    )
    ),
    ]
    )
    ,
    );
  }
  Widget _buildPage(OnboardingPage page) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.color.withOpacity(0.1),
            ),
            child: Icon(
              page.icon,
              size: 100,
              color: page.color,
            ),
          ),
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              page.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
List<Widget>_buildPageIndicator() {
  List<Widget>indictors = [];
  for (int i = 0; i < _pages.length; i++) {
    indictors.add(AnimatedContainer(duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == i ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == i ? _pages[i].color : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),),
    );
  }
  return indictors;
}
Widget _buildNextButton(){
    return GestureDetector(
      onTap: (){
        _pageController.nextPage(duration: Duration(milliseconds: 500),
            curve: Curves.ease);
      },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 16),
          decoration: BoxDecoration(
          color:  _pages[_currentPage].color,
          borderRadius:BorderRadius.circular(30),
        ),
  child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text("Next",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
  SizedBox(width: 8,),
  Icon(Icons.arrow_forward,color: Colors.white,),
  ],
  ),
      ),
    );
}
  Widget _buildGetStartedButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),

        );
      },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: _pages[_currentPage].color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text("Get Started", style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
        ),
      );
  }
}

class OnboardingPage{
  final String title;
  final String description;
  final   Color color;
  final IconData icon;

  OnboardingPage({required this.title, required this.description, required this.color, required this.icon});
}