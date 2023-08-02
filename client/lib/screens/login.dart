import 'dart:convert';
import '../variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../changeUsername.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String userName;
  late String passWord;
  Variables access = Variables();

  void updateUsername(val){
    setState(() {
      userName = val;
    });
  }

  void updatePassword(val){
    setState(() {
      passWord = val;
    });
  }

  bool checkLogin(String password,String username){
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stock market risk management"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height:50),
              Image.asset("images/stockLogo2.jpg",height: 200,),
              const SizedBox(height:30),
              Form(
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15),
                      child: TextFormField(
                        autofocus: false,
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
                          return value!.isEmpty ? 'Please enter username' : null;
                        },
                      ),
                    ),
                    const SizedBox(height:30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15),
                      child: TextFormField(
                        autofocus: false,
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
                    const SizedBox(height:50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: MaterialButton(onPressed: () async {
                      if (userName != null && passWord != null){
                        if(checkLogin(passWord, userName)){
                          var route = 'http://' +access.access+ ':8000/login/';
                          var url = Uri.parse(route);
                          var resp = await http.post(url,body:{'username' : userName , 'password' : passWord});
                          Map data = json.decode(resp.body);
                          if(data['success']){
                            try {
                              const storage = FlutterSecureStorage();
                              await storage.write(key: 'token', value: data['token']);
                              Provider.of<ChangeUsername>(context,listen: false).changeUsername(userName);
                              Navigator.pushReplacementNamed(context, '/home');
                            }catch (error) {
                              showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                title: const Text('Alert'),
                                content: const Text('Server error!'),
                                actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                  Navigator.of(context).pop();
                                } )],
                              ),
                              );
                            }

                          }else{
                            showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Invalid credentials!'),
                              actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                Navigator.of(context).pop();
                              } )],
                            ),
                            );
                          }
                        }else{
                          showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                            title: const Text('Alert'),
                            content: const Text('Username or password is incorrect!'),
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
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: const Text('Login'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(child: const Text("Sign up here"),onPressed: (){
                          Navigator.pushReplacementNamed(context, '/register');

                        },),
                      ],
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      );
  }
}