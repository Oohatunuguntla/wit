import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:besafe/Setup/Signin.dart';
class SignupPage extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignupPage>{
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
                onPressed:signUp,
                child:Text('Sign up'),
                )
          ],
        ),
      ),
    );
  }
 Future<void> signUp() async{
    final formState=_formkey.currentState;
    if(formState.validate()){
      formState.save(); 
      try{
       await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email, password: _password);
       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
      }
      catch(e){
        print(e.message);
      }
    }
  }
}
 
