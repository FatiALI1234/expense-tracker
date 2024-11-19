
import 'package:expense_tracker/Fpassword.dart';
import 'package:expense_tracker/Functions.dart';
import 'package:expense_tracker/Signup.dart';
import 'package:expense_tracker/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}
class _SignInState extends State<SignIn> {


  final TextEditingController _passwordController = TextEditingController();

  bool issecure = true;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isPasswordObscured = true;
  Future<void>_signin()async{
    if(formkey.currentState!.validate()){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text,
            password: passwordcontroller.text.trim());
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString())));
      }
    }
  }
  final formkey = GlobalKey<FormState>();
  String? _password;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
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
                          child: FadeInUp(
                              duration: Duration(seconds: 1), child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/light-1.png')
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
                                        image: AssetImage('assets/light-2.png')
                                    )
                                ),
                              )),
                        ),
                        //MediaQuery is used to obtain information about the size and orientation of the device's screen.
                        SingleChildScrollView(
                          child: Align(alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 140.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(
                                      "Hello",
                                      style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    const Text(
                                      "Sign in to your account",
                                      style: TextStyle(
                                        fontSize: 18,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: validateEmail,
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      prefixIcon: Icon(Icons.email),
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      obscureText: _isPasswordObscured,
                      controller: passwordcontroller,
                      validator: (value) =>
                      value != null && value.length < 6
                          ? "password must be at least 6 charcters"
                          : null,
                      onSaved: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(
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
                        labelText: "Enter Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        prefixIcon: Icon(Icons.lock),
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      )
                  ),

                ),

                // text button to navigate to forgetpassword screen
                Padding(
                  padding: const EdgeInsets.only(left: 230.0),
                  child: TextButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return Fpassword();
                        }));
                  },
                      child: Text("Forget password?",
                        style: TextStyle(color: Colors.purple,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.purple),)),
                ),

                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(child: Text("LOGIN",
                      style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .circular(10)),
                            fixedSize: Size(130, 40)),
                        onPressed: () {
                          signinn();
                          if (formkey.currentState!.validate()) {
                            // function calling for sign in
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //       return HomeScreen();
                            //     }));
                          }
                        })
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          signinn();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUp();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  // future function for signin
  Future signinn() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final result = await signin(
          email: emailcontroller.text, password: passwordcontroller.text);
      result.fold((failure) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)));
      }, (success) {
        setState(() {
          loading = false;
        });
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => HomeScreen()), (
            route) => false);
      });
    }
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return "Email is required";
    } else if (!email.contains("@")) {
      return "Invalid Email";
    }
    return null;
  }

}


