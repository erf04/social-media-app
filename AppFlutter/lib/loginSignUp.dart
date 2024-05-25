
import 'package:flutter/material.dart';
import 'package:flutter_application_2/SharedPreferencesFile.dart';
import 'package:flutter_application_2/data.dart';

import 'package:flutter_application_2/gen/assets.gen.dart';
import 'package:flutter_application_2/home.dart';


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
                        child: signup ? _Signup() : const _Login(),
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

class _Login extends StatefulWidget {
  const _Login({
    super.key,
  });

  @override
  State<_Login> createState() => LoginState();
}

class LoginState extends State<_Login> {
  final myControllerUserName = TextEditingController();
  final myPassField = PassField();
  static Future<void> getAuthLogin(
      String myUser, String myPass, context) async {
    final response = await HttpClient.instance.post('auth/jwt/create/',
        data: {'username': myUser, 'password': myPass});
    if (response.statusCode == 200) {
      saveTokens(response.data["access"], response.data["refresh"]);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()));
    } else {}
  }

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await SharedPreferencesManager.instance.setBool('hasAccount', true);
    await SharedPreferencesManager.instance
        .setString('accessToken', accessToken);
    await SharedPreferencesManager.instance
        .setString('refreshToken', refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await SharedPreferencesManager.instance.getString('accessToken');
  }

  static Future<bool?> getHasAccount() async {
    return await SharedPreferencesManager.instance.getBool('hasAccount');
  }

  static Future<String?> getRefreshToken() async {
    return await SharedPreferencesManager.instance.getString('refreshToken');
  }

  static Future<void> setAccessToken(String token) async {
    await SharedPreferencesManager.instance.setString('accessToken', token);
    return;
  }

  static Future<void> setRefreshToken(String token) async {
    SharedPreferencesManager.instance.setString('refreshToken', token);
  }

  static Future<void> clearTokens() async {
    await SharedPreferencesManager.instance.remove('accessToken');
    await SharedPreferencesManager.instance.remove('refreshToken');
  }

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
        TextField(
          controller: myControllerUserName,
          decoration:const InputDecoration(label: Text('Username')),
        ),
        myPassField,
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
            onPressed: () {
              getAuthLogin(
                  myControllerUserName.text, myPassField.getPass(), context);
            },
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
  PassField({super.key});

  final myPassField = _PassFieldState();
  @override
  State<PassField> createState() => myPassField;
  String getPass() => myPassField.myControllerPassWord.text;
}

class _PassFieldState extends State<PassField> {
  bool obscurity = true;
  final myControllerPassWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myControllerPassWord,
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
  PassField2({super.key});
  final myPassField = _PassFieldState2();
  @override
  _PassFieldState2 createState() => myPassField;
  String getEmail() => myPassField.myControllerPassWord.text;
}

class _PassFieldState2 extends State<PassField2> {
  bool obscurity = true;

  final myControllerPassWord = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myControllerPassWord,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(label: const Text('email')),
    );
  }
}

class _Signup extends StatelessWidget {
  _Signup({
    super.key,
  });

  final myControllerUserName = TextEditingController();
  final myPassField1 = PassField();
  final myEmail = PassField2();

  Future<void> getAuthSignUp(
      String myUser, String myPass, String email, BuildContext context) async {
    final response;
    response = await HttpClient.instance.post('auth/users/',
        data: {"email": email, 'username': myUser, 'password': myPass});
    if (response.statusCode == 201) {
      LoginState.getAuthLogin(myUser, myPass, context);
    } else {
      print("NOT APPROVED");
    }
  }

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
        TextField(
          controller: myControllerUserName,
          decoration: const InputDecoration(label: Text('Username')),
        ),
        myEmail,
        myPassField1,
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
            onPressed: () {
              getAuthSignUp(myControllerUserName.text, myPassField1.getPass(),
                  myEmail.getEmail(), context);
            },
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
