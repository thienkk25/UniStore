import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_store/controllers/user_controller.dart';
import 'package:uni_store/custom/button_view.dart';
import 'package:uni_store/custom/text_form_field_view.dart';
import 'package:uni_store/screens/signup.dart';

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
                      child: Lottie.asset("assets/lotties/arrow_left.json",
                          width: 30, height: 30, fit: BoxFit.contain),
                    ),
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
                        TextFormFieldView(
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
                  forgot();
                }),
          ),
          Padding(
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
          )
        ],
      ),
    );
  }

  void forgot() async {
    if (_keyForm.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(
          child: Lottie.asset("assets/lotties/loading.json",
              height: 100, width: 100, fit: BoxFit.contain),
        ),
      );
      final UserController userController = UserController();
      String result =
          await userController.forgotController(emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      Navigator.of(context).pop();
      emailController.clear();
    }
  }
}
