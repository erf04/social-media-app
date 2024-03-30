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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool signup = false;
  Color myColor = Colors.white.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                  child: Assets.img.icons.logo.svg(width: 150, height: 75)),
            ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                signup = false;
                              });
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: signup ? myColor : Colors.white),
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                signup = true;
                              });
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: signup ? Colors.white : myColor),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
                        child: signup ? const _Signup() : const _Login(),
                      ),
                    ),
                  ))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _Login extends StatelessWidget {
  const _Login({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(
          height: 16,
        ),
        Text('Sign in with your account!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black)),
        const SizedBox(
          height: 16,
        ),
        const TextField(
          decoration: InputDecoration(label: Text('Username')),
        ),
        const PassField(),
        const SizedBox(
          height: 18,
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: Text('login',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Forgot your password?',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black)),
            TextButton(
                onPressed: () {},
                child: Text('Reset here',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue)))
          ],
        ),
        Center(
            child: Text('Sign in with:',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black))),
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Assets.img.icons.google.image(width: 40, height: 40),
            Assets.img.icons.facebook.image(width: 40, height: 40),
            Assets.img.icons.twitter.image(width: 40, height: 40)
          ],
        )
      ],
    );
  }
}

class PassField extends StatefulWidget {
  const PassField({super.key});

  @override
  State<PassField> createState() => _PassFieldState();
}

class _PassFieldState extends State<PassField> {
  bool obscurity = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscurity,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  obscurity = !obscurity;
                });
              },
              child: Text('show',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue))),
          label: const Text('Password')),
    );
  }
}

class PassField2 extends StatefulWidget {
  const PassField2({super.key});

  @override
  _PassFieldState2 createState() => _PassFieldState2();
}

class _PassFieldState2 extends State<PassField2> {
  bool obscurity = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscurity,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          suffixIcon: TextButton(
              onPressed: () {
                setState(() {
                  obscurity = !obscurity;
                });
              },
              child: Text('show',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue))),
          label: const Text('confirm Password')),
    );
  }
}

class _Signup extends StatelessWidget {
  const _Signup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(
          height: 16,
        ),
        Text('Create a new account!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black)),
        const SizedBox(
          height: 16,
        ),
        const TextField(
          decoration: InputDecoration(label: Text('Username')),
        ),
        const PassField(),
        const PassField2(),
        const SizedBox(
          height: 18,
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: Text('sign up',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(
          height: 16,
        ),
        Center(
            child: Text('Sign up with:',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black))),
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Assets.img.icons.google.image(width: 40, height: 40),
            Assets.img.icons.facebook.image(width: 40, height: 40),
            Assets.img.icons.twitter.image(width: 40, height: 40)
          ],
        )
      ],
    );
  }
}
