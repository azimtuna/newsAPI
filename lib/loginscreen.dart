import 'package:deneme/Widgets.dart';
import 'package:deneme/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> handleSignIn() async {
    try {
      setState(() => loading = true);
      await AuthService().signIn(
        context,
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 230,
            width: 230,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.purple.shade500),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red.shade900)),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.purple.shade500),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red.shade900)),
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: Text("Sign in"),
                        onPressed: handleSignIn,
                      ),
                      SizedBox(width: 6,),
                      ElevatedButton(
                        child: Text("Register"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Register extends StatelessWidget{
  final emailController = TextEditingController();
  final passwordController=TextEditingController();
  final repasswordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body:Center(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child:Container(
                height: 300,
                width: 210,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                child: Column(

                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(onPressed: (){
                        Navigator.pushNamed(context, "/login");
                      },
                          icon: Icon(Icons.arrow_back_ios)),
                    )
                    ,
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(fontSize: 14 , color: Colors.grey.shade600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.purple.shade500
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14 , color: Colors.grey.shade600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.purple.shade500
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: repasswordController,
                      decoration: InputDecoration(
                        labelText: "Re-Enter",
                        labelStyle: TextStyle(fontSize: 14 , color: Colors.grey.shade600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.purple.shade500
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900
                            )
                        ),
                      ),

                    ),

                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Center(
                          child:ElevatedButton(
                            child: Text("Register"),
                            onPressed: () {
                              if(passwordController.text==repasswordController.text) {
                                AuthService().signUp(context,
                                    email: emailController.text,
                                    password: passwordController.text);
                              }else{
                                Widgets().RegisterDialogBuilder(context);
                              }
                            },
                          ),
                       )
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }

}