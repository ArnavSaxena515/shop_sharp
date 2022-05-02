import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/utilities/error_dialogue.dart';

import '../providers/auth.dart';

// ignore: constant_identifier_names
enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const String routeName = "/auth-screen";

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false;
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 1])),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: mediaQueryData.size.height,
              width: mediaQueryData.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Shop Sharp',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 50,
                                fontFamily: 'Anton',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.shopping_cart,
                              size: 100,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: mediaQueryData.size.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _authFormKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    "email": '',
    "password": '',
  };
  bool _isLoading = false;

  // ? _controller;
  // ? _heightAnimation;
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(milliseconds: _animationDurationInMilliseconds));
  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(00, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  late final Animation<double> _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  final int _animationDurationInMilliseconds = 300;

  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _opacityAnimation.addListener(() {
      setState(() {});
    });
    // _controller =
    // _heightAnimation =

    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });

    //_scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);

    // _scrollController.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailFieldFocusNode.dispose();
    _passwordFieldFocusNode.dispose();
    _confirmPasswordFieldFocusNode.dispose();
    super.dispose();
  }

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submit() async {
    //if validation fails, return
    if (!_authFormKey.currentState!.validate()) {
      return;
    }
    _authFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).signIn(email: _authData["email"], password: _authData["password"]);
      } else {
        //sign user up

        await Provider.of<Auth>(context, listen: false).signUp(email: _authData["email"], password: _authData["password"]);
      }
    } on HttpException catch (error) {
      String errorMessage = "Authentication failed";
      final List<Widget> actions = [];
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "User Already exists";
        actions.add(TextButton(
          child: const Text("Login Instead"),
          onPressed: () {
            _switchAuthMode();
            Navigator.of(context).pop();
          },
        ));
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is not a valid email address";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not find a user associated with provided email address";
        actions.add(TextButton(
          child: const Text("Sign Up Instead"),
          onPressed: () {
            _switchAuthMode();
            Navigator.of(context).pop();
          },
        ));
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password";
      }
      // showDialog(
      //     context: context,
      //     builder: (_) => AlertDialog(
      //           title: Text("ERROR"),
      //         ));
      await showError(errorMessage, context, actions);
    } catch (error) {
      await showError("Could not authenticate credentials. Please try again later", context, []);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });

      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  final FocusNode _emailFieldFocusNode = FocusNode();
  final FocusNode _passwordFieldFocusNode = FocusNode();
  final FocusNode _confirmPasswordFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child:
          // AnimatedBuilder(
          //   animation: _heightAnimation,
          //   builder: (ctx, animationChild) =>
          AnimatedContainer(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
          //minHeight: _heightAnimation.value.height,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        duration: Duration(milliseconds: _animationDurationInMilliseconds),
        child: Form(
          key: _authFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: _emailFieldFocusNode,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFieldFocusNode);
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(value!))
                    //  if (value!.isEmpty || !value.contains('@'))
                    {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  focusNode: _passwordFieldFocusNode,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  //if login, show done. if signup, go next
                  textInputAction: _authMode == AuthMode.Login ? TextInputAction.done : TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _authMode == AuthMode.Login ? _submit() : FocusScope.of(context).requestFocus(_confirmPasswordFieldFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        focusNode: _confirmPasswordFieldFocusNode,
                        enabled: _authMode == AuthMode.Signup,
                        decoration: const InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _submit();
                        },
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                            primary: Theme.of(context).primaryColor,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                      ),
                TextButton(
                  child: Text('${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(color: Theme.of(context).primaryTextTheme.button!.color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
