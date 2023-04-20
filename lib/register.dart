// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, camel_case_types, prefer_final_fields

import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup_email/login.dart';

class Register_Page extends StatefulWidget {
  const Register_Page({Key? key}) : super(key: key);

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  bool _loading = false;

  var emailid = ""; var passward = "";

  bool showhide = true;
  toggleswitch(){
    return IconButton(onPressed: (){
      setState(() {
        showhide =!showhide;
      });
    },
        icon: showhide? Icon(Icons.visibility,color: Color(0xFFebd197),):Icon(Icons.visibility_off,color: Color(0xFFebd197),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(AppAssets.splashScreenImage),
                Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                Text(
                  'Please enter the following details for registration',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(height: 10),
                Form(
                    key: globalkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email id';
                            }
                            return null;
                          },
                          controller: _userEmail,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value){
                            emailid = value;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.email_rounded,
                              color: Color(0xFFebd197),
                            ),
                            hintText: 'Enter Email id',
                            hintStyle: TextStyle(color: Colors.white),
                            counter: Offstage(),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else
                              return null;
                          },
                          onChanged: (value){
                            passward = value;
                          },
                          controller: _userPassword,
                          obscureText: showhide,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: toggleswitch(),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(color: Colors.white),
                            counter: Offstage(),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 30),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffd2b086), Color(0xff594f43)]),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: OutlinedButton(
                      onPressed: () async {
                        if (globalkey.currentState!.validate()) {
                          _registerUser(_userEmail.text, _userPassword.text);
                        }
                        try {
                          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailid,
                            password: passward,
                          );
                          Fluttertoast.showToast(
                            backgroundColor: Colors.green,
                              gravity: ToastGravity.TOP,
                              msg: 'Account Created Successfully');
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                msg: 'The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                msg: 'The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: setUpButtonChild()),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have you already Account ?  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text('Login',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_loading == false) {
      return Text("Create Account",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ));
    } else {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }
  }

  _registerUser(
    String _userEmail,
    String _userPassword,
  ) {}

  // if(){
  //   setState(() {
  //     _loading==false;
  //   });
  //   Fluttertoast.showToast(
  //       msg: "Register successfull",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       textColor: Colors.white,
  //       backgroundColor: Colors.green,
  //       fontSize: 16.0
  //   );
  //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Page()));
  //
  // }else{
  //   setState(() {
  //     _loading==false;
  //   });
  //   Fluttertoast.showToast(
  //       msg: "This number is already exist",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       textColor: Colors.white,
  //       backgroundColor: Colors.red,
  //       fontSize: 16.0
  //   );
  //   print("Error");
  // }
}
