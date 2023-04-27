import 'package:flutter/material.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/register.dart';
import 'package:inven/screens/listofbusiness.dart';
import 'package:inven/code/loginapi.dart';
import 'package:inven/code/getbusinessapi.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final responseReceiver = ResponseReceiverlogin();

    final authToken = await login(
      username: _usernameController.text,
      password: _passwordController.text,
      responseReceiver: responseReceiver,
    );

    if (authToken != null) {
      final businesses = await getBusinessList();
      print(businesses);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListBusinessWidget(businesses: businesses, username: _usernameController.text)),
      );
    } else {
      // Show an error message or handle the login failure.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong Username or Password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      //   Image.asset(
      //     'assets/images/welcomeimg.png',
      //     width: 250,
      //     height: 250,
      //   ),
      Text(
      'INVEN©',
      style: TextStyle(
        fontSize: 35,
        color: Colors.black,
        fontFamily: 'Sans Serif',
      ),
    ),
    SizedBox(height: 30),
        CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              MyButton(
                text: 'LOGIN',
                onPressed: _login,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ForgotPasswordWidget()),
                      // );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterWidget()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      ),
      ),
    );


  }
}


