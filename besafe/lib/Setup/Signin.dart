import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:besafe/Setup/Pages/home.dart';
class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState()=> new _LoginPageState();
  }
  
class _LoginPageState extends State<LoginPage> {
  String _email,_password;
  final GlobalKey<FormState> _formkey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:Text('Sign in'),
      ),
      body: Form(
        key: _formkey,
        child:Column(
          children: <Widget>[
              TextFormField(
                validator: (input){
                  if(input.isEmpty){
                    return 'Please type an email';
                  }
                },
                onSaved:(input)=>_email=input,
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              ),
              TextFormField(
                validator: (input){
                  if(input.length < 6){
                    return 'password needs atleast 6 characters';
                  }
                },
                onSaved:(input)=>_password=input,
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
                obscureText: true,
              ),
              RaisedButton(
                onPressed:signIn,
                child:Text('Sign in'),
                )
          ],
        ),
      ),
    );
  }
 Future<void> signIn() async{
    final formState=_formkey.currentState;
    if(formState.validate()){
      formState.save();
      try{
       FirebaseUser user =(await FirebaseAuth.instance.signInWithEmailAndPassword(email:_email, password: _password)).user;
       Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(user:user)));
      }
      catch(e){
        print(e.message);
      }
    }
  }
}
 
