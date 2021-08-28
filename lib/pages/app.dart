import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:carrot_market/pages/home.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<App> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();

      default:
        return Container();
    }
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_off.svg',
            width: 22,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_on.svg',
            width: 22,
          ),
        ),
        label: label);
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        items: [
          _bottomNavigationBarItem('home', '홈'),
          _bottomNavigationBarItem('notes', '동내생활'),
          _bottomNavigationBarItem('location', '내 근처'),
          _bottomNavigationBarItem('chat', '채팅'),
          _bottomNavigationBarItem('user', '나의 당근'),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
      // bottomNavigationBar: Container(),
    );
  }
}
