// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:proactiv/screens/home/home_navigation_screen.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideright_toleft.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:hackitall_singleton/my_utilities/widget/custom_textfield.dart';
import 'package:hackitall_singleton/screens/bottom_nav.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController forgotController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  void signUserIn(BuildContext context) async {

    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: 'Loading...',
    );

    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );

      bool userFoundInCollection = false;
      final userCollection = FirebaseFirestore.instance.collection('users');
      final snapshot = await userCollection.get();
      for (var result in snapshot.docs) {
        if (result.data()['Email'].toString() == loginEmailController.text) {
          userFoundInCollection = true;
        }
      }

      if (userFoundInCollection == true) {
        
        Navigator.of(context).pushAndRemoveUntil(
          SlideRightToLeft(page: const BottomNav()),
          (Route<dynamic> route) => false,
        );

      } else {
        errorMessage(context, 'Contul nu e in Firestore Database.');
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage(context, 'Adresă de email greșită!');
      }

      else if (e.code == 'wrong-password') {
        errorMessage(context, 'Parolă greșită!');
      }
    }
  }

  void errorMessage(BuildContext context, String message) {
    Navigator.pop(context);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      backgroundColor: Colors.redAccent.withOpacity(0.1),
      confirmBtnColor: Colors.redAccent,
      confirmBtnText: 'OK',
      title: message,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      )
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {

    Navigator.pop(context);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: 'Se încarcă...',
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // You can show a success message to the user
      Navigator.pop(context);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        confirmBtnColor: const Color.fromARGB(255, 73, 186, 143),
        confirmBtnText: 'OK',
        title: 'Email de resetare a parolei trimis.',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        )
      );
    } catch (e) {
      Navigator.pop(context);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        confirmBtnColor: Colors.redAccent,
        confirmBtnText: 'OK',
        title: e.toString(),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        )
      );
      // Handle error as needed, e.g., show an error message to the user
    }
}

  double containerHeight = 180;
  double buttonMargin = 160;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: SizedBox(
                    width: 300.0,
                    height: containerHeight,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: Icon(
                                // FontAwesomeIcons.envelope,
                                Icons.mail_outline_outlined,
                                color: Colors.black,
                                // size: 22.0,
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              focusNodePassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodePassword,
                            controller: loginPasswordController,
                            obscureText: _obscureTextPassword,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: const Icon(
                                // FontAwesomeIcons.lock,
                                Icons.lock_outlined,
                                // size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              if (_formKey.currentState!.validate()) {
                                signUserIn(context);
                              } else {
                                setState(() {
                                  containerHeight = 190;
                                  buttonMargin = 170;
                                });
                              }
                            },
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 230.0,
                  margin: EdgeInsets.only(top: buttonMargin),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Color.fromARGB(255, 0, 10, 75),
                  ),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: const Color.fromARGB(255, 38, 40, 110),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUserIn(context);
                      } else {
                        setState(() {
                          containerHeight = 190;
                          buttonMargin = 170;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: 205,
                          child: Column(
                            children: [
                              Container(
                                height: 55,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: Color.fromARGB(255, 3, 0, 167),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Ai uitat parola?',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                              
                              Container(
                                height: 75,
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                                child: CustomTextField(
                                  controller: forgotController,
                                  contentPaddingTop: 12,
                                  contentPaddingBottom: 12,
                                  hintTextColor: kBlackColor.withOpacity(0.5),
                                  hintFontSize: 16,
                                  textColor: kBlackColor,
                                  textFontSize: 16,
                                  cursorColor: kBlackColor,
                                  hintText: "Email",
                                  isOutlineInputBorderColor: kBlackColor,
                                  onFieldSubmitted: (_) {
                                    sendPasswordResetEmail(forgotController.text);
                                  },
                                ),
                              ),
          
                              GestureDetector(
                                onTap: () {
                                  sendPasswordResetEmail(forgotController.text);
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 45.0,
                                    width: 45.0,
                                    margin: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 38, 40, 110),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.navigate_next,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
        ],
      ),
    );
  }


  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}
