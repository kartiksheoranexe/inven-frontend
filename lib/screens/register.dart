import 'package:flutter/material.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/welcome.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/code/registerapi.dart';


class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = 'Male';

  void _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String dob = '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    bool success = await registerUser(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      dob: dob,
      gender: _selectedGender.substring(0, 1),
      phoneNo: _phoneNumberController.text,
    );

    if (success) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertDialog(
                title: 'Registration Successful',
                content: 'Registered Successfully',
                buttonText: 'OK',
              onButtonPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
              },
            );
          },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
      child: Stack(
      children: [
      Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          'INVEN©',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontFamily: 'Sans Serif',
          ),
        ),
      ),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SingleChildScrollView(
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
    child: CustomCard(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: GestureDetector(
    onTap: () {
    FocusScope.of(context).unfocus();
    },
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.min,
    children: [
    Form(
    key: _formKey,
    child: Column(
    children: [
    TextFormField(
    controller: _usernameController,
    decoration: InputDecoration(
    labelText: 'Username',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Username cannot be empty';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value!.isEmpty || !value.contains('@')) {
    return 'Please enter a valid email';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    TextFormField(
    controller: _passwordController,
    decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    ),
    obscureText: true,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Password cannot be empty';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    TextFormField(
    controller: _confirmPasswordController,
    decoration: InputDecoration(
    labelText: 'Confirm Password',
    border: OutlineInputBorder(),
    ),
    obscureText: true,
    validator: (value) {
    if (value != _passwordController.text) {
    return 'Passwords do not match';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    GestureDetector(
    onTap: () async {
    final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
    },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          _selectedDate == null
              ? 'Date of Birth'
              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
      SizedBox(height: 10),
      DropdownButtonFormField<String>(
        value: _selectedGender,
        items: ['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
        maxLength: 10,
        validator: (value) {
          if (value!.isEmpty || value.length != 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
      ),
      SizedBox(height: 20),
      MyButton(
        text: 'REGISTER',
        onPressed: () {
          _handleRegistration();
        },
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already a user? '),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
    ),
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


