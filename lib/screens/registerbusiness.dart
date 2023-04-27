import 'package:flutter/material.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/welcome.dart';
import 'confirmbusiness.dart';
import 'package:inven/code/loginapi.dart';
import 'package:inven/code/registerbusinessapi.dart';

class RegisterBusinessWidget extends StatefulWidget {
  @override
  _RegisterBusinessWidgetState createState() => _RegisterBusinessWidgetState();
}

class _RegisterBusinessWidgetState extends State<RegisterBusinessWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _businessAddressController = TextEditingController();
  TextEditingController _businessCityController = TextEditingController();
  TextEditingController _businessStateController = TextEditingController();
  TextEditingController _businessCountryController = TextEditingController();
  TextEditingController _businessPhoneController = TextEditingController();
  TextEditingController _businessEmailController = TextEditingController();
  String _selectedBusinessType = 'Medicine';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
    child: Stack(
    children: [
    Align(
    alignment: Alignment.topCenter,
    child: Padding(
    padding: EdgeInsets.only(top: 30.0),
    child: Text(
    'REGISTER YOUR BUSINESS',
    style: TextStyle(
    fontSize: 25,
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
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.min,
    children: [
    TextFormField(
    controller: _businessNameController,
    decoration: InputDecoration(
    labelText: 'Business Name',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business Name cannot be empty';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    DropdownButtonFormField<String>(
    value: _selectedBusinessType,
    items: ['Medicine', 'Stationary', 'Grocery', 'Restaurant']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _selectedBusinessType = newValue!;
    });
    },
    decoration: InputDecoration(
    labelText: 'Business Type',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 10),
    TextFormField(
    controller: _businessAddressController,
    decoration: InputDecoration(
    labelText: 'Business Address',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business Address cannot be empty';
    }
    return null;
    },
    ),
    SizedBox(height: 10),
    TextFormField(
    controller: _businessCityController,
    decoration: InputDecoration(
    labelText: 'Business City',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business City cannot be empty';
    }
    return null;
    },
    onSaved: (value) {
    _businessCityController.text = value!;
    },
    ),
    SizedBox(height: 10),
    TextFormField(
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business State cannot be empty';
    }
    return null;
    },
    onSaved: (value) {
    _businessStateController.text = value!;
    },
    decoration: InputDecoration(
    labelText: 'Business State',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 10),
    TextFormField(
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business Country cannot be empty';
    }
    return null;
    },
    onSaved: (value) {
    _businessCountryController.text = value!;
    },
    decoration: InputDecoration(
    labelText: 'Business Country',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 10),
    TextFormField(
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business Phone cannot be empty';
    }
    return null;
    },
    onSaved: (value) {
    _businessPhoneController.text = value!;
    },
    decoration: InputDecoration(
    labelText: 'Business Phone',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 10),
    TextFormField(
    validator: (value) {
    if (value!.isEmpty) {
    return 'Business Email cannot be empty';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
    return 'Please enter a valid email address';
    }
    return null;
    },
    onSaved: (value) {
    _businessEmailController.text = value!;
    },
    decoration: InputDecoration(
    labelText: 'Business Email',
    border: OutlineInputBorder(),
    ),
    ),
    SizedBox(height: 20),
    MyButton(
    text: 'REGISTER',
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    AuthStorage.getToken().then((authToken) {
    if (authToken == null) {
    Navigator.pushNamed(context, '/');
    } else {
    BusinessRegistration registrationData = BusinessRegistration(
    businessName: _businessNameController.text,
    businessType: _selectedBusinessType,
    businessAddress: _businessAddressController.text,
    businessCity: _businessCityController.text,
    businessState: _businessStateController.text,
    businessCountry: _businessCountryController.text,
    businessPhone: _businessPhoneController.text,
    businessEmail: _businessEmailController.text,
    );
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ConfirmWidget(
    businessName: _businessNameController.text,
    businessType: _selectedBusinessType,
    businessAddress: _businessAddressController.text,
    businessCity: _businessCityController.text,
    businessState: _businessStateController.text,
    businessCountry: _businessCountryController.text,
    businessPhone: _businessPhoneController.text,
    businessEmail: _businessEmailController.text,
    ),
    ),
    );
    }
    });
    }
    },
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
    ),
    );
  }
}
