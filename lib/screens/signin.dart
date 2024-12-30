import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/controllers/user_controller.dart';
import 'package:shop_fashion/custom/button_view.dart';
import 'package:shop_fashion/custom/text_form_field_view.dart';
import 'package:shop_fashion/screens/forgot.dart';
import 'package:shop_fashion/screens/home.dart';
import 'package:shop_fashion/screens/signup.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  ConsumerState<Signin> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  bool checkboxValue = false;

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
                      "Sign In",
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
                    "Welcome Back",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Signin with your email and password or continue with social media",
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
                  2,
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: checkboxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      checkboxValue = value!;
                                    });
                                  },
                                  activeColor: Colors.orange,
                                ),
                                const Text(
                                  "Remember me",
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Forgot()));
                              },
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.orange),
                              ),
                            )
                          ],
                        )
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
                  signIn();
                }),
          ),
          Padding(
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
                Row(
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
              ],
            ),
          )
        ],
      ),
    );
  }

  void signIn() async {
    if (_keyForm.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
      final UserController userController = UserController();
      String result = await userController.signInController(
          emailController.text, pwController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      Navigator.of(context).pop();
      if (result == "Login success") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      }
    }
  }
}
