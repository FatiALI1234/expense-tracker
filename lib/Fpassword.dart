
import 'package:expense_tracker/Functions.dart';
import 'package:expense_tracker/signin.dart';
import 'package:expense_tracker/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Fpassword extends StatefulWidget {
  const Fpassword({super.key});

  @override
  State<Fpassword> createState() => _FpasswordState();
}

class _FpasswordState extends State<Fpassword> {
  final searchcontroller=TextEditingController();
  final emailcontroller=TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formkey ,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.13,
                        ),
                        Align(alignment: Alignment.topLeft,
                            child: Text("Reset Password", style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Enter the email associated with your account"
                                  " and we will send an email with instructions"
                                  "to reset your password"),
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
                          child: CupertinoButton(color: Colors.deepPurple,
                              child: Text("Send mail",
                                style: TextStyle(color: Colors.white),),
                              onPressed: () {
                            Forgetpasswordd();
                            if(formkey.currentState!.validate())
                        Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) =>SignIn()));
                              }),
                        ),
                      ]
                  ),
                ),
          ),

        ),
      );
  }
  Future Forgetpasswordd() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    final result = await resetpassword(emailcontroller.text);
    result.fold((failure) {
      setState(() {
        isLoading = false;
      });
      //  snackbar is used to display error msg on bottom of the screen e.g:the account is already exist
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)));
    }, (success) {
      setState(() {
        isLoading = false;
      });
      // controllers to clear register screen whenever we do logout
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
}


