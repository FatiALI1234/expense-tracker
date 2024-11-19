import 'package:expense_tracker/Functions.dart';
import 'package:expense_tracker/Profile.dart';
import 'package:expense_tracker/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  bool _isPasswordObscured = true;

  Future<void> _signup() async {
    if (formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailcontroller.text,
            password: passwordcontroller.text.trim());
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())));
      }
    }
  }

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool issecure = false;
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/new 2.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeInUp(duration: Duration(seconds: 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/light-1.png')
                                      )
                                  ),
                                )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1200),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/light-2.png')
                                      )
                                  ),
                                )),
                          ),
                          //MediaQuery is used to obtain information about the size and orientation of the device's screen.
                          SingleChildScrollView(
                            child: Align(alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 170.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 60),
                                        child: const Text(
                                          "Create account",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(image: AssetImage("assets/background1.png"),fit: BoxFit.cover)
                  // ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: validateEmail,
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(12)
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.grey,),
                        labelText: "Enter Email",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _isPasswordObscured,
                      validator: (value) =>
                      value != null && value.length < 6
                          ? "password must be at least 6 charcters"
                          : null,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(12)


                        ),
                        prefix: Icon(
                            Icons.lock,
                            color: Colors.grey),
                        labelText: "Enter Password",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(icon: Icon(
                          _isPasswordObscured ? Icons.visibility : Icons
                              .visibility_off,
                        ),
                          onPressed: () {
                            // here we are using vraiable so use r password will be hide when user click on eye icon
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _isPasswordObscured,
                      controller: confirmpasswordcontroller,
                      validator: (val) {
                        return validateConfirmpassword(
                            passwordcontroller.text, val);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(12)
                        ),
                        prefix: Icon(
                            Icons.lock,
                            color: Colors.grey),
                        labelText: "Confirm Password",

                        suffixIcon: IconButton(icon: Icon(
                          _isPasswordObscured ? Icons.visibility : Icons
                              .visibility_off,
                        ),
                          onPressed: () {
                            // here we are using vraiable so use r password will be hide when user click on eye icon
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton
                          .styleFrom(
                          backgroundColor: Colors
                              .deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .circular(
                                  10)),
                          fixedSize: Size(130, 40)),
                      onPressed: () {
                        signupp();
                        if (formkey.currentState!
                            .validate()) {
                          // signup is function that we call here for user creation in firebase and this function is making below

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //       return SignIn();
                          //     }));
                        }
                      },
                      child: Text("Register",
                        style: TextStyle(
                            color: Colors.white),),
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }

  Future signupp() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    final result = await signup(
        email: emailcontroller.text, password: passwordcontroller.text);
    result.fold((failure) {
      setState(() {
        isLoading = false;
      });
      //  snackbar is used to display error msg on bottom of the screen e.g:the account is alrready exist
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)));
    }, (success) {
      setState(() {
        isLoading = false;
      });
      // controllers to clear register screen whenever we do logout
      emailcontroller.clear();
      passwordcontroller.clear();
      confirmpasswordcontroller.clear();
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => SignIn()), (
          route) => false);
    });
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return "Email is required";
    } else if (!email.contains("@")) {
      return "Invalid Email";
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmpassword) {
    if (confirmpassword!.isEmpty) {
      return "confirm Password is required";
    } else if (confirmpassword.length < 6) {
      return 'Password must be at least 6 characters ';
    }
    return null;
  }

  String? validateConfirmpassword(String? password,
      String? confirmpassword) {
    if (confirmpassword == null || confirmpassword.isEmpty) {
      return "Please enter your  password";
    }
    if (confirmpassword != password) {
      return "password does not match";
    }
    return null;
  }
}



