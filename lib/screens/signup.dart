import 'package:flutter/material.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/custom/text_form_field_view.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController repwController = TextEditingController();
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
                      "Sign Up",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: (availableHeight - (availableHeight / 6)) / 5,
            width: double.infinity,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Complete your details or continue with social media",
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
                      (availableHeight - (availableHeight / 6)) / 5) /
                  1.8,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _keyForm,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormFieldView(
                          textEditingController: pwController,
                          labelText: "Password",
                          hintText: "Enter your pasword",
                          icon: const Icon(Icons.lock),
                          validatorCallback: (value) {
                            if (value == "" || value!.isEmpty) {
                              return "Please enter pasword";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormFieldView(
                          textEditingController: repwController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter your pasword",
                          icon: const Icon(Icons.lock),
                          validatorCallback: (value) {
                            if (value == "" || value!.isEmpty) {
                              return "Please enter pasword";
                            } else if (value != pwController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          obscureText: true,
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
                        (availableHeight - (availableHeight / 6)) / 5) /
                    4) -
                20,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                              "assets/icons/icons8-google-logo-48.png"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                              "assets/icons/icons8-facebook-logo-48.png"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                              "assets/icons/icons8-apple-logo-50.png"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                    ),
                    child: const Expanded(
                      child: Text(
                        "By continuing your confirm that you agree with our Term and Condition",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
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
// RichText(
//                     text: const TextSpan(children: [
//                       TextSpan(
//                         text:
//                             "By continuing yourôcnfirm that you agree with our",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       TextSpan(
//                         text: "Term and Condition",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ]),
//                   ),