import 'dart:io';
import 'package:chatapp/widget/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthonticationScreen extends StatefulWidget {
  const AuthonticationScreen({super.key});

  @override
  State<AuthonticationScreen> createState() {
    return _AuthenticationScreen();
  }
}

class _AuthenticationScreen extends State<AuthonticationScreen> {
  var _isLogin = true;
  final _formkey = GlobalKey<FormState>();
  var _enterdEmail = '';
  var _enteredPassword = '';
  var _enterdUsername = '';
  File? _userImage;
  var _isAuthenticating = false;

  void _saveInput() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid || !_isLogin && _userImage == null) {
      if (_userImage == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture is required')));
      }
    }

    _formkey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCred = await _firebase.signInWithEmailAndPassword(
            email: _enterdEmail, password: _enteredPassword);
      } else {
        final userCred = await _firebase.createUserWithEmailAndPassword(
            email: _enterdEmail, password: _enteredPassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCred.user!.uid}.jpg');
        await storageRef.putFile(_userImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'username': _enterdUsername,
          'email': _enterdEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                                onSelectedImage: (File pickedImage) {
                              _userImage = pickedImage;
                            }),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email address should not be empty';
                              } else if (!value.endsWith('@gmail.com')) {
                                return 'Should ends with @gmail.com';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _enterdEmail = newValue!,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              onTap: () {},
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Enter a valid Username at least with 4 characters';
                                }
                                return null;
                              },
                              onSaved: (newvalue) =>
                                  _enterdUsername = newvalue!,
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid password';
                              } else if (value.length < 8) {
                                return 'Password should contain atleast 8 characters';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _enteredPassword = newValue!,
                          ),
                          const SizedBox(height: 12),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _saveInput,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an Account'
                                  : 'I already have an account'),
                            )
                        ],
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
