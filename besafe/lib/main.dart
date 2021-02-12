import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:besafe/authService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main()=>runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
 
    return new MaterialApp(
      title:'Be Safe',
      theme: ThemeData(
        primarySwatch:Colors.lime,
      ),
     // home: WelcomePage(),
     home:AuthService().handleAuth(),
    );
  }
}
