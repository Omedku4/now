import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../firebase/cdus.dart';
import 'notifications/n1.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  bool _peye=true;
  String dateTime="";
  late TextEditingController _dateTime;
  
  late TextEditingController fullname = new TextEditingController();
  late TextEditingController email= new TextEditingController();
  late TextEditingController password= new TextEditingController();
  late TextEditingController phone= new TextEditingController();

  String errormessage="";
  //web
  Future<User?> signInWithGooglE() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    // The `GoogleAuthProvider` can only be 
    // used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();
  
    try {
      final UserCredential userCredential =
      await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  
    if (user != null) {
      var emil;
      if(user.email!=null){
      var infouser = FirebaseFirestore.instance.collection('users')..where("Email",isEqualTo: user.email);
      var querySnapshot = await infouser.get();
      for(var queryDocSnapshot in querySnapshot.docs){
      Map<String,dynamic>data=queryDocSnapshot.data();
      setState(() {
      emil=data['Email'];
      });
      }
      
      if(emil==null){
      String dt=DateFormat('yyyy-MM-dd').format(DateTime.now());
      String? name =user.displayName;String? emailg=user.email;String? uid=user.uid;
      Cdus().newUser(name!, emailg!,"","",dt,"","",0,uid);
      }
      Cdus().getuserinfo(user.email.toString());           
      Navigator.pushNamed(context,'screen');
      }
    }
    return user;
  }
  //end web google signin


  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  UserCredential? usercredential;
  login()async{
    try {
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email.text,
    password: password.text
  );
  var o=userCredential;
    if(o!=null){
      //sharedPref.setString("uid",_userid!);
      // sharedPref.setString("fullname",fullname.text);
      Cdus().getuserinfo(email.text);
      Navigator.pushNamed(context,'screen');
    }
  } on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
   showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).taaexftemail,icon:'error');});
  } else if (e.code == 'wrong-password') {
   showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).wppfte,icon:'error');});
  }
 }
  }

  signUp()async{
   try {
    UserCredential usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email.text,
    password: password.text
    );

    var _userid=usercredential.user?.uid;
    var d=usercredential;
    if(d!=null){
      Cdus().newUser(fullname.text, email.text, password.text, phone.text,_dateTime.text,"","",0,_userid!);
      Cdus().getuserinfo(email.text);
      Navigator.pushNamed(context,'screen');
    }
    } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
    showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).tppit_weak,icon:'error');});
    } else if (e.code == 'email-already-in-use') {
    showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).taaexftemail,icon:'error');});
    }
    } catch (e) {
    print(e);
    }
    if (usercredential?.user?.emailVerified==false) {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    }
   
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime=DateFormat('yyyy-MM-dd').format(DateTime.now());
    _dateTime=TextEditingController(text:dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:15.0,right:15.0,top:90.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).login,
                style:TextStyle(fontSize:25,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                SizedBox(height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(AppLocalizations.of(context).email,
                  style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500),),
                ),
                CupertinoTextField(
                  controller:email,
                  cursorColor: Colors.indigo,cursorWidth: 5,
                  style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                  decoration: BoxDecoration(
                  border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                  borderRadius: BorderRadius.circular(6),
                  ),
                  
                ),
                 Padding(
                  padding: const EdgeInsets.only(bottom: 5,top: 10),
                  child: Text(AppLocalizations.of(context).password,
                  style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500),),
                ),
                
                CupertinoTextField(
                  controller:password,
                  cursorColor: Colors.indigo,cursorWidth: 5,
                  style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                  decoration: BoxDecoration(
                  border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                  borderRadius: BorderRadius.circular(6),
                  ),
                  obscureText:_peye,obscuringCharacter:'•',
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 5,left:5),
                    child: GestureDetector(
                              child:Icon(_peye?Icons.visibility:Icons.visibility_off,
                              color: Colors.grey[800],),
                              onTap: (){setState(() {
                                _peye=!_peye;
                              });} 
                              ),
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0,top:16.0),
                  child: GestureDetector(
                  child:Container(height:45,width:MediaQuery.of(context).size.width-25,decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(20)),
                  child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                  Text(AppLocalizations.of(context).login,style:TextStyle(fontSize:15,fontFamily:'kurdi',color:Colors.white,),)
                  ],)
                  ),
                  onTap:()async{
                    if(email.text.length <8){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).peyea_correctly,icon:'error');});}
                    else if(email.text.length >30){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).peyea_correctly,icon:'error');});}
                    else if(password.text.length <7){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).peyp_correctly,icon:'error');});}
                    else if(password.text.length >50){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).login_page,description:AppLocalizations.of(context).peyp_correctly,icon:'error');});}
                    else{
                    await login();
                    }
                  },),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: GestureDetector(
                  child:Container(height:45,width:MediaQuery.of(context).size.width-25,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),
                  child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: SvgPicture.asset('assets/img/google.svg'),
                    ),
                    Text(AppLocalizations.of(context).continue_w_g,style:TextStyle(fontSize:15,fontFamily:'kurdi',color:Colors.black,),)
                  ],)), 
                  onTap:()async{
                  // if(kIsWeb){
                  // signInWithGooglE();
                  // }else{
                  var emil;
                  UserCredential sg= await signInWithGoogle();
                  if(sg.user?.email!=null){
                  var infouser = FirebaseFirestore.instance.collection('users').where("Email",isEqualTo: sg.user?.email);
                  var querySnapshot = await infouser.get();
                  for(var queryDocSnapshot in querySnapshot.docs){
                  Map<String,dynamic>data=queryDocSnapshot.data();
                  setState(() {
                    emil=data['Email'];
                  });
                  }
      
                  if(emil==null){
                  String dt=DateFormat('yyyy-MM-dd').format(DateTime.now());
                  String? name =sg.user?.displayName;String? emailg=sg.user?.email;String? uid=sg.user?.uid;
                  Cdus().newUser(name!, emailg!,"","",dt,"","",0,uid!);
                  }
                  Cdus().getuserinfo(sg.user!.email.toString());
                  //}
                  
                  Navigator.pushNamed(context,'screen');
                  }},),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(AppLocalizations.of(context).dha,
              style: TextStyle(color: Colors.grey,fontFamily:'kurdi'),),
              GestureDetector(
                child: Text(AppLocalizations.of(context).sign_up,
                style: TextStyle(color: Colors.indigo,fontFamily:'kurdi'),),
                onTap: () {
                  showModalBottomSheet(
                   isScrollControlled: true,
                   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                   context: context,
                   builder:(context)=>Container(
                    padding: const EdgeInsets.only(left:15.0,right:15.0,top:90.0,bottom:20),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(AppLocalizations.of(context).sign_up,
                      style:TextStyle(fontSize:25,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                     SizedBox(height: 35.0),
                     Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).username,
                      style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500))),
                    
                     CupertinoTextField(
                       controller:fullname,
                       cursorColor: Colors.indigo,cursorWidth: 5,
                       style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                       decoration: BoxDecoration(
                       border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                       borderRadius: BorderRadius.circular(6),
                      )),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).email,
                      style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500))),
                    
                     CupertinoTextField(
                       controller:email,
                       cursorColor: Colors.indigo,cursorWidth: 5,
                       style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                       decoration: BoxDecoration(
                       border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                       borderRadius: BorderRadius.circular(6),
                      )),
                    

                     Padding(
                       padding: const EdgeInsets.only(bottom: 5,top: 10),
                       child: Text(AppLocalizations.of(context).password,
                       style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500),),
                     ),

                     CupertinoTextField(
                      controller:password,
                       cursorColor: Colors.indigo,cursorWidth: 5,
                       style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                       decoration: BoxDecoration(
                       border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                       borderRadius: BorderRadius.circular(6),
                       ),
                       obscureText:true,obscuringCharacter:'•',
                      ),
                     Padding(
                       padding: const EdgeInsets.only(bottom: 5,top: 10),
                       child: Text(AppLocalizations.of(context).phone_number,
                       style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500),),
                     ),
                     CupertinoTextField(
                      controller:phone,
                       cursorColor: Colors.indigo,cursorWidth: 5,
                       style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                       decoration: BoxDecoration(
                       border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                       borderRadius: BorderRadius.circular(6),
                      ),
                      keyboardType: TextInputType.phone,
                      prefix: Text(' +964 ',style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100)),
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      ),

                     Padding(
                       padding: const EdgeInsets.only(bottom: 5,top: 10),
                       child: Text(AppLocalizations.of(context).birthdate,
                       style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontWeight: FontWeight.w500),),
                     ),

                      CupertinoTextField(
                       cursorColor: Colors.indigo,cursorWidth: 5,
                       style: TextStyle(color: Colors.grey[300],fontFamily:'kurdi',fontSize:13,fontWeight: FontWeight.w100),
                       decoration: BoxDecoration(
                       border:Border.all(width:1.5,color:Color.fromARGB(255, 51, 51, 51) ),
                       borderRadius: BorderRadius.circular(6),
                      ),
                      readOnly: true,controller:_dateTime,
                      suffix: Padding(
                        padding: const EdgeInsets.only(left: 5,right:5),
                        child: GestureDetector(child: Icon(Icons.date_range_rounded,color: Colors.grey[800],),
                        onTap: (){
                          showModalBottomSheet(context: context,
                          backgroundColor: Colors.white,
                           builder: (context) => Container(
                            child: CupertinoDatePicker(
                              initialDateTime:DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                              dateOrder:DatePickerDateOrder.ymd,
                              onDateTimeChanged: (date) {
                                setState(() {
                                  _dateTime.text=DateFormat('yyyy-MM-dd').format(date);
                                });
                              },
                            ),
                           ));
                        },),
                      )
                      ),

                     Container(margin: EdgeInsets.all(15),alignment: Alignment.center,
                      child: CupertinoButton(padding: EdgeInsets.only(left: 120,right: 120),
                       child: Text(AppLocalizations.of(context).register,
                       style:TextStyle(fontSize: 15,fontFamily:'kurdi',color:Colors.white,fontWeight: FontWeight.w500)),
                        color: Color.fromARGB(255, 19, 20, 24),borderRadius: BorderRadius.circular(20),
                        onPressed:()async{
                          if(fullname.text.length <4){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_username_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyusername_correctly,icon:'error');});}
                          else if(fullname.text.length >30){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_username_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyusername_correctly,icon:'error');});}
                          else if(email.text.length <4){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyea_correctly,icon:'error');});}
                          else if(email.text.length >30){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_email_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyea_correctly,icon:'error');});}
                          else if(password.text.length <7){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyp_correctly,icon:'error');});}
                          else if(password.text.length >50){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_password_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peyp_correctly,icon:'error');});}
                          else if(phone.text.length <10){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_phone_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peypn_correctly,icon:'error');});}
                          else if(phone.text.length >11){showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).type_phone_correctly,subtitle:AppLocalizations.of(context).register_page,description:AppLocalizations.of(context).peypn_correctly,icon:'error');});}
                          else{
                             await signUp();
                          }
                        }),
                      ), 
                    ],)));
                },
              )
            ],),)
        ],
      ),
    );
  }
}