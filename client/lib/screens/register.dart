import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../variables.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var userName;
  var passWord;
  var confirmPassword;
  var email;
  final Variables access = new Variables();

  void updateUsername(val){
    setState(() {
      userName = val;
    });
  }

  void updateEmail(val){
    setState(() {
      email = val;
    });
  }

  void updatePassword(val){
    setState(() {
      passWord = val;
    });
  }

  void updateConfirmPassword(val){
    setState(() {
      confirmPassword = val;
    });
  }

  bool checkPasswordStrength(String password,String confirmPassword){

    String passWordRegex = "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*";
    RegExp regex = RegExp(passWordRegex);
    if (regex.hasMatch(password) && passWord == confirmPassword) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor:Theme.of(context).primaryColor
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter username',
                              prefixIcon: Icon(Icons.person),
                              border:OutlineInputBorder()
                          ),
                          onChanged: (value){
                            updateUsername(value);
                          },
                          validator: (value){
                            return value!.isEmpty ? 'Please enter username' : 'usr';
                          },
                        ),
                      ),
                      const SizedBox(height:30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter password',
                              prefixIcon: Icon(Icons.lock),
                              border:OutlineInputBorder()
                          ),
                          onChanged: (value){
                            updatePassword(value);
                          },
                          validator: (value){
                            return value!.isEmpty ? 'Please enter email' : 'b';
                          },
                        ),
                      ),
                      const SizedBox(height:30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Enter password',
                              prefixIcon: Icon(Icons.lock),
                              border:OutlineInputBorder()
                          ),
                          onChanged: (value){
                            updateConfirmPassword(value);
                          },
                          validator: (value){
                            return value!.isEmpty ? 'Please enter email' : 'b';
                          },
                        ),
                      ),
                      const SizedBox(height:30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter email',
                              prefixIcon: Icon(Icons.email),
                              border:OutlineInputBorder()
                          ),
                          onChanged: (value){
                            updateEmail(value);
                          },
                          validator: (value){
                            return value!.isEmpty ? 'Please enter username' : 'usr';
                          },
                        ),
                      ),
                      const SizedBox(height:30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: MaterialButton(onPressed: () async {
                          if (userName != null && passWord != null && confirmPassword != null){
                            if(checkPasswordStrength(passWord,confirmPassword)){
                              String route = 'http://' + access.access+ ':8000/register/';
                              var url = Uri.parse(route);
                              var resp = await http.post(url,body:{'username' : userName , 'password' : passWord, 'email' : email});
                              Map data = json.decode(resp.body);
                              print(data);
                              if(data['success']){
                                showDialog(context: context,barrierDismissible: false,  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Welcome ' + userName),
                                  content: Text('We sent an activation email to: ' + email),
                                  actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                    Navigator.pushReplacementNamed(context, '/');
                                  } )],
                                ),
                                );
                              }else{
                                showDialog(context: context,barrierDismissible: false,  builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Alert'),
                                  content: const Text('An account with the same username already exists, please choose a new one!'),
                                  actions:<Widget> [TextButton(child: const Text('Ok'),
                                      onPressed: () {Navigator.of(context).pop();
                                  } )],
                                ),
                                );
                              }
                            }else{
                              showDialog(context: context,builder: (BuildContext context) => AlertDialog(
                                title: const Text('Your password needs to:'),
                                content: const Text('\n-include both lower and upper case characters \n\n-include at least one number and symbol \n\n-be at least 8 characters long'),
                                actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                  Navigator.of(context).pop();
                                } )],
                              ),
                              );
                            }
                          }else{
                            showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('All fields must pe completed'),
                              actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                Navigator.of(context).pop();
                              } )],
                            ),
                            );
                          }
                        },
                          minWidth: double.infinity,
                          child: const Text('Register'),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(child: const Text("Sign in here"),onPressed: (){
                            Navigator.pushReplacementNamed(context, '/');

                          },),
                        ],
                      )
                    ],
                  ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
