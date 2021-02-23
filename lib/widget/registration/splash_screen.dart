import 'dart:async';

import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  _SplashScreenState() {
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Utils.setColorStatusBar();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 200, bottom: 0, left: 0, right: 0),
                    child: SvgPicture.asset(
                      R.ic_logo,
                      height: 122,
                    ),
                  ),

                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0,top:149, left: 48, right: 48),
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'THE BEANS\n ',
                          style: Styles.headerSplashStyle,
                        ),
                        TextSpan(
                          text: 'Hộp Đậu Xét Mình',
                          style: Styles.bodyPurple,
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 33, left: 48, right: 48),
                  child: Text(
                    'Skip',
                    style: Styles.bodyGreyUnderline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
