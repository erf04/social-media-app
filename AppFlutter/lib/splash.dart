import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/home.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/onBoarding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

enum verifyToken {
  expired,
  loggedOut,
  verified;
}

class SplashScreenState extends State<SplashScreen> {
  static Future<verifyToken?> verifyAccess(BuildContext context) async {
    String? myAccess = await LoginState.getAccessToken();
    //print(myAccess);
    if (myAccess == null) {
      if (LoginState.getHasAccount() == null) {
        //print("ajab");
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (context) {
            return OnBoarding();
          }));
        });
      } else {
        if (LoginState.getHasAccount() == null) {
          //print("NEMIDOONAM CHITO SHODE");
          Future.delayed(const Duration(seconds: 3)).then((value) {
            Navigator.of(context)
                .pushReplacement(CupertinoPageRoute(builder: (context) {
              return AuthScreen();
            }));
          });
        }
        return verifyToken.loggedOut;
      }
    }
    return await HttpClient.instance
        .post('auth/jwt/verify/', data: {"token": myAccess}).then((response) {
      //print(';aha');
      return verifyToken.verified;
    }).catchError((error) async {
      final response2 = await HttpClient.instance.post('auth/jwt/refresh/',
          data: {
            "refresh": await LoginState.getRefreshToken()
          }).then((response2) {
        LoginState.setAccessToken(response2.data["access"]);
        //print("TRUE");
        return verifyToken.verified;
      }).catchError((onError) {
        //print("LETS SEE");
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (context) {
            return AuthScreen();
          }));
        });
        //print("SHADIDAN RIDIN");
        return verifyToken.expired;
      });
      return response2;
    });
  }

  Future<void> verfyCompare() async {
    verifyToken? myVerification = await verifyAccess(context);
    if (myVerification == verifyToken.verified) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return MainPage();
        }));
      });
    }
  }

  @override
  void initState() {
    verfyCompare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Assets.img.background.splash.image(fit: BoxFit.cover)),
        Center(
          child: Assets.img.icons.logo.svg(width: 200),
        )
      ]),
    );
  }
}
