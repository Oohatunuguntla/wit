import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:besafe/authservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(
        centerTitle: true,
        title: new Text('Login'),
        backgroundColor: Colors.lime,

      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage('images/logo.png'),
                 colorFilter: new ColorFilter.mode(Colors.green.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover),),

        child:Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    
                    decoration: InputDecoration(
                    hintText: 'Enter phone number',
                      prefixText: "+91 ",
                  prefixStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                      ),
                      validator: (value){
                  if(value.length != 10){
                    return "Enter valid Phone Number";
                  }
                  return null;
                },
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = "+91"+val;
                      });
                    },
                  )),
                  codeSent ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter OTP'),
                    onChanged: (val) {
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  )) : Container(),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                       child:       ButtonTheme(
    splashColor: Colors.red[300],
    //padding: EdgeInsets.fromLTRB(35.0, 12.0, 35.0, 12.0),
    minWidth: 100,
    buttonColor: Colors.red[700],
    child: new RaisedButton(
      elevation: 10.0,
      textColor: Colors.white,
      onPressed: ()async{
        codeSent ? AuthService().signInWithOTP(smsCode, verificationId):verifyPhone(phoneNo);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),
      child: Center(child:codeSent?new Text("Login",
        style: TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.0,
        ),
      ):new Text("Verify",
        style: TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.0,
        ),
      )),
      color: Colors.lime,
    ),
  ),)
            ],
          ))),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}