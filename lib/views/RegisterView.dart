import 'package:chat_app/constants.dart';
import 'package:chat_app/views/ChatView.dart';
import 'package:chat_app/widget/CustomButton.dart';
import 'package:chat_app/widget/customeTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterWidget extends StatefulWidget {
  RegisterWidget({super.key});

  static const String id = 'registerView';

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  String password = '';
  String email = '';
  String userName = '';

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Image.asset(
                  'assets/images/scholar.png',
                  scale: 0.7,
                  height: 150,
                ),

                //Chat App
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chat App',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                //Register
                Row(
                  children: [
                    const Text(
                      'Register ',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                CustomeTextFormField(
                  onChange: (data) {
                    email = data;
                  },
                  labelText: 'Email',
                  secure: false,
                ),

                const SizedBox(height: 10),

                CustomeTextFormField(
                  onChange: (data) {
                    password = data;
                  },
                  labelText: 'Password',
                  secure: true,
                ),

                const SizedBox(height: 10),

                CustomeTextFormField(
                  onChange: (data) {
                    userName = data;
                  },
                  labelText: 'User Name',
                  secure: false,
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      String message = '';
                      try {
                        await userRegister();
                        Navigator.pushNamed(
                          context,
                          ChatView.id,
                          arguments: {'email': email, 'userName': userName},
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        message = messageIndecator(message, e);
                        setState(() {
                          isLoading = false;
                        });
                        showMassege(context, message);
                      }
                    }
                  },
                  child: CustomeButton(title: 'Register'),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already have an account !  ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'login',
                        style: TextStyle(color: Color(0xffc6ebe5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMassege(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String messageIndecator(String message, FirebaseAuthException e) {
    message = 'There is an error, please try again';
    if (e.code == 'weak-password') {
      message = 'Password is too weak';
    } else if (e.code == 'email-already-in-use') {
      message = 'Email already in use';
    } else if (e.code == 'invalid-email') {
      message = 'Invalid email';
    }
    return message;
  }

  Future<void> userRegister() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
