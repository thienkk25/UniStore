import 'package:flutter/material.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/custom/textFormField_view.dart';
import 'package:shop_fashion/screens/signup.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController emailController = TextEditingController();
  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: availableHeight / 6,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.chevron_left_outlined,
                          size: 30,
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: (availableHeight - (availableHeight / 6)) / 4,
            width: double.infinity,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Please enter your email and we will send you a link to reset your password",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: (availableHeight -
                      (availableHeight - (availableHeight / 6)) / 4) /
                  2,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _keyForm,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextformfieldView(
                          textEditingController: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          icon: const Icon(Icons.email),
                          validatorCallback: (value) {
                            if (value == "" || value!.isEmpty) {
                              return "Please enter email";
                            } else if (!emailRegExp.hasMatch(value)) {
                              return "Email is not in correct format";
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 40,
            width: 250,
            child: ButtonView(
                text: "Continue",
                voidCallback: () {
                  if (_keyForm.currentState!.validate()) {}
                }),
          ),
          SizedBox(
            height: ((availableHeight -
                        (availableHeight - (availableHeight / 6)) / 4) /
                    3) -
                40,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.orange),
                    ),
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
