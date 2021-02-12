

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:besafe/landingscreen.dart';
import 'package:besafe/authService.dart';
import 'package:besafe/loginscreen.dart';
class ContactdetailsApp extends StatefulWidget{
   
    @override
    _ContactdetailsAppState createState()=>_ContactdetailsAppState();
}
class _ContactdetailsAppState extends State<ContactdetailsApp>{
  String emergencynumber;
  String familynumber1;
  String familynumber2;
  
  
  //function to save contact details of family or friends
  //to firebase.
  void _savedatabase(
		String emergencynumber,
		String familynumber1,
		String familynumber2) async{
		
	//get current login user
   final _auth=FirebaseAuth.instance;
   final FirebaseUser user=await _auth.currentUser();
   var uid=user.uid;
   
   //save data to firebase
	
    final databaseReference=FirebaseDatabase.instance.reference();
    databaseReference.child('$uid').set({ 'emergencynumber':emergencynumber,'familynumber1':familynumber1,'familynumber2':familynumber2
   });

  }
  @override
  void _initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){

     return Scaffold(
       appBar: PreferredSize(
         preferredSize: Size.fromHeight(100.0),
      child: AppBar(
              centerTitle: true,
              title: Text('Be Safe'),
               actions:<Widget>[
			  Padding(
			  padding:EdgeInsets.all(10.0),
			  child:IconButton(
			  icon:Icon(Icons.power_settings_new,color:Colors.white,size:33),
			  //signout
			  onPressed:(){
			  AuthService().signOut();
			  Navigator.push(context,MaterialPageRoute(
			  builder:(context)=>LoginPage()));
			  }),
			  )
			  ],
			  //logo button
              leading: IconButton(icon: Image.asset('images/logo.png'), onPressed:()=>Navigator.push(context,MaterialPageRoute(
			  builder:(context)=>LandingApp()))),
      )),
      body:Container(
	   
        padding: const EdgeInsets.all(16),
		 constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage('images/logo.png'),
                 colorFilter: new ColorFilter.mode(Colors.green.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover),),
        child:Column(children: <Widget>[
		SizedBox(height:75),
          TextField(
		  textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      autocorrect: true,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        labelText: 'Emergencynumber',
                        hintText: 'Enter phone number to contact in emergency',

                      ),
            onChanged: (text){
              emergencynumber=text;
            }
          ),
		  SizedBox(height:25),
		  TextField(
		  textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      autocorrect: true,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        labelText: 'Family or friend number',
                        hintText: 'Phone number for messaging them in danger',
                      ),
            onChanged: (text1){
              familynumber1=text1;
            }
          ),
		  SizedBox(height:25),
		  TextField(
		  textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      autocorrect: true,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
						labelText: 'Family or friend number',
                        hintText: 'Phone number for messaging them in danger',
                                              ),
            onChanged: (text2){
               familynumber2=text2;
            }
          ),
		  SizedBox(height:25),
          RaisedButton(
		  onPressed:(){
			  _savedatabase(emergencynumber,familynumber1,familynumber2);
			  Navigator.push(context,MaterialPageRoute(
			  builder:(context)=>LandingApp()));
			  },
		  
		  
		
          child:Text('Save')
          )
        ],)
      )
     );
    
}
}