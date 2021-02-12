import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import'package:besafe/contactdetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:besafe/authService.dart';
import 'package:besafe/loginscreen.dart';
import 'package:besafe/Map.dart';
void main() {
  runApp(LandingApp());
}
	
	
//fetch data from firebase and send sms to target users.
void _sendsms(String message) async{
  final _auth=FirebaseAuth.instance;
  final FirebaseUser user=await _auth.currentUser();
  var uid=user.uid;
  final databaseReference=FirebaseDatabase.instance.reference();
  final ref=databaseReference.child('$uid').once().then((DataSnapshot data){
  
  sendSMS(message:message,recipients:[data.value['familynumber1'],data.value['familynumber2']]).
	then((res){
		print(res);});
	});	
  
}

//fetch data from firebase and perform emergencycall to respective //users
_directphonecall() async{
  String emergencynumber;
  final _auth=FirebaseAuth.instance;
  final FirebaseUser user=await _auth.currentUser();
  var uid=user.uid;
  final databaseReference=FirebaseDatabase.instance.reference();
  final ref=databaseReference.child('$uid').once().then((DataSnapshot data){
  FlutterPhoneDirectCaller.callNumber(data.value['emergencynumber']).
	then((res){
		print(res);});
		});
	
}

//call police (100)
_callpolice() async{
	bool res= await FlutterPhoneDirectCaller.callNumber('100');
	print(res);
}


class LandingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Safe',
      theme: ThemeData(

        primarySwatch: Colors.lime,
              visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Be Safe')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget getWidget(path,text){
    return Expanded(
      child:Column(
        children: <Widget>[
		
		//get rounded icons
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 50.0,
            child: ClipOval(
             child:Image.asset(path),
            ),
          ),
         
          Text(text,style:TextStyle(
            fontSize: 20.0,
            color: Colors.red
          ))
    ],
    ),
    );
  }
 

  Widget build(BuildContext context) {
     return Scaffold(
       appBar: PreferredSize(
         preferredSize: Size.fromHeight(75.0),
      child: AppBar(
              centerTitle: true,
			  
              title: Text(widget.title),
              actions:<Widget>[
			  Padding(
			  padding:EdgeInsets.all(10.0),
			  child:IconButton(
			  
			  icon:Icon(Icons.power_settings_new,color:Colors.white,size:33),
			  onPressed:(){
			  AuthService().signOut();
			  Navigator.push(context,MaterialPageRoute(
			  builder:(context)=>LoginPage()));
			  }),
			  )
			  ],
			  
              leading: IconButton(icon: Image.asset('images/logo.png',height:50), onPressed: null),
      )),
      body:Container(
        decoration:BoxDecoration(
          gradient:LinearGradient(
            colors:[
          
              Colors.blue[400],
              Colors.green[200],
              Colors.purple[100]
              
            ],
            begin:Alignment.bottomLeft,
            end:Alignment.topRight
            ),
        ),
        child: Column(
          children: [
		 
			     
             SizedBox(height: 200,width: 70,),
            Column(
             
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
					
                 //SizedBox(height: 10,width: 10,),
				  
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    SizedBox(height: 20,width: 3),
                    InkWell(onTap: () => _callpolice(),
                    child:getWidget('images/call100.jpg','Call police'),
                    ),
					InkWell(onTap:()=>_directphonecall(),
                    child:getWidget('images/callemergency.png','Emergency Call'),
                    ),
                    
                    
                    
                          ],
                    ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    SizedBox(height: 250,width: 30),
                    InkWell(
					  onTap:(){
							_sendsms('I am in danger');
						Navigator.push(context,MaterialPageRoute(
						builder:(context)=>MyApp()));
						},
					
					
					//onTap: ()=>_sendsms('I am in danger'),
                    child:getWidget('images/messages.jpg','Mesage family'),
                    ), InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactdetailsApp())),
                    child:getWidget('images/contact.png','contact details'),
                    )
                            ],
                     ),
              ]
            )
            

        ],),
      ),
     
    );
  }
}
