// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup_email/homepage.dart';
import 'package:signup_email/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  bool _loading=false;
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
                //Image.asset(AppAssets.splashScreenImage),
                Text('Login',style: TextStyle(color: Colors.white,fontSize: 50),),
                Text('Please enter the following details for login',
                  style: TextStyle(color: Colors.grey,fontSize: 13),),
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
                            suffixIcon: Icon(Icons.email_rounded,color: Color(0xFFebd197),),
                            hintText: 'Enter Email id',
                            hintStyle: TextStyle(color: Colors.white),
                            counter: Offstage(),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),

                            contentPadding:EdgeInsets.only(left: 15),
                          ),


                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }else
                              return null;
                          },
                          controller: _userPassword,
                          obscureText: showhide,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value){
                            passward = value;
                          },
                          decoration: InputDecoration(
                            suffixIcon: toggleswitch(),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(color: Colors.white),
                            counter: Offstage(),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Color(0xFFF65054)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xffd2b086), Color(0xff594f43)]),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2,color: Colors.white),
                  ),

                  child: OutlinedButton(
                      onPressed: () async {
                        if (globalkey.currentState!.validate()) {
                          _registerUser(_userEmail.text,_userPassword.text);
                        }
                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailid,
                              password: passward
                          );
                          Fluttertoast.showToast(
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.green,
                              msg: 'Login Successfull');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.red,
                                msg: 'No user found please register.');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Register_Page())           );
                          } else if (e.code == 'wrong-password') {
                            Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.red,
                                msg: 'Wrong password provided for that user.');
                          }
                        }
                        },
                      child: setUpButtonChild()
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have you already Account ?  ",style: TextStyle(color: Colors.white),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Register_Page()));
                    },
                        child:Text('Register',
                            style: TextStyle(
                                color: Colors.red,
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
    if (_loading==false) {
      return  Text("Login",textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,fontSize: 22,
          ));
    } else {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }
  }
  _registerUser(
      String _userEmail,
      String _userPassword,
      ){}
}

