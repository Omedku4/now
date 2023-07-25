import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xol/main.dart';

import '../service/ad_mob_service.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}
List<String>options=['KRD-Badini','KRD-Sorani','Arabic','English'];
List<String>icon=['assets/img/krd.png','assets/img/krd.png','assets/img/ar.png','assets/img/en.png'];

class _profileState extends State<profile> {
  TextEditingController send_money = new TextEditingController();
  TextEditingController send_email = new TextEditingController();
  String currentoption="";
  String lang="";
  String zarav="";

  
  String? uid;
  bool uib=false;
  getuid()async{
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  setState(() {
  uid=sharedPref.getString("uid");
  uib=true;
  });
  }
  
  String? fullname;
  bool fuser=false;
  getuser()async{
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  if(fuser==false){
  setState(() {
  fullname=sharedPref.getString("fullname");
  fuser=true;
  });
  }}
  
   savepref(String lang, String zarav)async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("lang",lang);
    sharedPref.setString("zarav",zarav);
  }
  Future<String> Lang()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("lang")=='ar'?'ar':'en';}
  Future<String> Zarav()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if(sharedPref.getString("zarav")=='IQ'){return 'IQ';}
    else if(sharedPref.getString("zarav")=='SY'){return 'SY';}
    else{return '';}
  }
   selectlang()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    Lang().then((value){lang=value;});Zarav().then((value){zarav=value;
    if(lang=='en'){currentoption=options[3];}
    else{
      if(zarav=='IQ'){currentoption=options[0];}else if(zarav==' SY'){currentoption=options[1];}else if(zarav==''){currentoption=options[2];}
    }});
    
  }
  
  
  
  var money;
  getuserinfo()async{
  getuid();
  var infouser = FirebaseFirestore.instance.collection('users').where('uID',isEqualTo:uid);
  var querySnapshot = await infouser.get();
  for(var queryDocSnapshot in querySnapshot.docs){
  Map<String,dynamic>data=queryDocSnapshot.data();
  setState(() {
    if(uid==data['uID'].toString()){money =data['Money'].toString();}
  });
  }
  }

  RewardedInterstitialAd? _rewardedAd;
  void _interstitialAd(){
  //start ad
  RewardedInterstitialAd.load(
  adUnitId:AdMobService.rewardedInterstitialAdUnitId!,
  rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
  onAdLoaded: (RewardedInterstitialAd ad){
  print('$ad loead.===============');
  setState(() {
  this._rewardedAd=ad;
  _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
  var infouser = FirebaseFirestore.instance.collection('users');
  infouser.doc(uid).update({"Money":FieldValue.increment(250)});
  getuserinfo();
  },);});},
  onAdFailedToLoad: (LoadAdError error){print('filde==================$error');}),
  request: AdRequest(),);
  //end ad
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectlang();
    getuserinfo();
    getuser();
    
    
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
     backgroundColor: Colors.black,
     body:Padding(
       padding: const EdgeInsets.all(10.0),
       child: ListView(children: [
        Container(padding:EdgeInsets.all(10.0),child:Column(children: [
          Container(height:MediaQuery.of(context).size.width*0.6,
          decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(20),
          gradient:LinearGradient(
          begin:Alignment.topLeft,
          end:Alignment.bottomRight,
          colors:[Color.fromARGB(255, 54, 74, 184),Colors.indigoAccent])),
          child:Stack(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text('$fullname',
                    style:TextStyle(fontSize:18,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                    Text(AppLocalizations.of(context).ybixol,
                    style:TextStyle(fontSize:12,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white60),),
                  ],
                ),
                GestureDetector(child: SizedBox(height:45,width:45,child: ClipRRect(borderRadius:BorderRadius.circular(100),child: Container(color:Colors.white.withOpacity(0.1),child:Icon(Icons.wallet,color:Colors.white,)))),
                onTap:(){
                
        
                },)
              ]),
                Text(NumberFormat.decimalPattern('en_us').format(money==null?0:int.parse(money))+'.00'+' '+AppLocalizations.of(context).iqd,
                style:TextStyle(fontSize:30,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                GestureDetector(
                  child: Container(decoration:BoxDecoration(color:Colors.white.withOpacity(0.1),
                  borderRadius:BorderRadius.circular(20),boxShadow:[BoxShadow(color:Colors.white.withOpacity(0.1),blurRadius:10,spreadRadius:5)]),height:MediaQuery.of(context).size.height*0.05,width:MediaQuery.of(context).size.width*1,
                  child:Center(
                    child: Text(AppLocalizations.of(context).buy_balance,
                    style:TextStyle(fontSize:18,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                  ),),
                  onTap:(){
                    showModalBottomSheet(context: context,
                    backgroundColor:Color.fromARGB(255, 20,20, 20),
                    shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.only(
                    topRight:Radius.circular(20),topLeft:Radius.circular(20),
                    )
                    ),
                    builder: (context){
                      return Container(height:MediaQuery.of(context).size.height/2.5,
                      child:Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context).buy_balance,
                        style:TextStyle(fontSize:23,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(dense: true,isThreeLine: true,
                        leading:Icon(Icons.payment,color:Colors.white,),
                        title:Text(AppLocalizations.of(context).buy_balance,
                        style:TextStyle(fontSize:16,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                        subtitle:Text('fastpay - FIB - korek - zain cash',
                        style:TextStyle(fontSize:12,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.grey),),
                        onTap:()=>setState(() {
                        launchUrl(Uri.parse('https://t.me/xolkrd/4'),mode:LaunchMode.externalApplication);
                        }),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(dense: true,isThreeLine: true,
                        leading:Icon(Icons.ads_click_rounded,color:Colors.white,),
                        title:Text(AppLocalizations.of(context).get_money_free,
                        style:TextStyle(fontSize:16,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                        subtitle:Text(AppLocalizations.of(context).view_ads_for_get_free,
                        style:TextStyle(fontSize:12,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.grey),),
                        onTap:(){
                        _interstitialAd();
                      }),)
                      ],),
                      );
                    });
                  },
                )
              ],),
            )
          ]),
          ),
          
        ],),),
        
        
            
        // GestureDetector(
        //   child: Container(height:40,alignment:Alignment.center,decoration:BoxDecoration(color:Color.fromARGB(255, 25,25, 25),borderRadius:BorderRadius.circular(10)),
        //   child:Text('CV information',textAlign:TextAlign.center,
        //   style:TextStyle(fontSize:15,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white))),
        // ),
        
        ListTile(title:Text(AppLocalizations.of(context).language,maxLines:1,overflow:TextOverflow.ellipsis,
          style:TextStyle(color: Colors.white,fontFamily:'kurdi',fontSize: 15)),
          leading:Icon(Icons.language_rounded,color:Colors.white,),
          onTap:(){
          showModalBottomSheet(
           isScrollControlled: true,
           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
           context: context,
           builder:(context)=>Container(
           padding: const EdgeInsets.only(top:20.0,bottom:30),
           color: Colors.black,
           child:Column(crossAxisAlignment: CrossAxisAlignment.start,
             children: [
        Padding(
          padding: const EdgeInsets.only(top:50,right:10,left:10,bottom:0),
          child: Text(AppLocalizations.of(context).cthel,
          style:TextStyle(fontSize:28,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
        ),
        SizedBox(height:options.length*80,
           child: ListView.builder(
            itemCount:options.length,
            itemBuilder: (context, index) {
              return GestureDetector(
              child: SizedBox(height:70,
              child:Container(decoration:BoxDecoration(
              border:Border(top:BorderSide(color:currentoption==options[index]?Colors.indigo:Color.fromARGB(255, 20, 20, 20),width:1.5),
              bottom:BorderSide(color:currentoption==options[index]?Colors.indigo:Color.fromARGB(255, 20, 20, 20),width:1.5))) ,
                child:SizedBox(height:80,child:Container(color:Color.fromARGB(255, 20, 20, 20),
                child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right:10,left:10),
                    child: SizedBox(width:40,height:30,
                      child: ClipRRect(
                        borderRadius:BorderRadius.circular(8),
                        child:Image.asset(icon[index],fit:BoxFit.fill,),
                      ),
                    ),
                  ),
                  Text(options[index],style:TextStyle(
                    color:Colors.white,fontFamily:'kurdi',fontSize:15
                  ),)
                  ],),
                  Padding(
                    padding:  EdgeInsets.only(right:10,left:10),
                    child: Icon(currentoption==options[index]?Icons.check_circle_outline_rounded:null,color:Colors.indigo,),
                  )
                ],),),) )),
              onTap:(){
                setState(() {
                  int i=index;
                  if(i==0){ savepref('ar','IQ');}
                  else if(i==1){ savepref('ar','SY');}
                  else if(i==2){ savepref('ar','');}
                  else{ savepref('en','');}
                
                 selectlang();
                  main();
                });
              },
            );
            },),
         ),
             ],
           ) ));
        },),
        
        ListTile(title:Text(AppLocalizations.of(context).about_us,maxLines:1,overflow:TextOverflow.ellipsis,
          style:TextStyle(color: Colors.white,fontFamily:'kurdi',fontSize: 15)),
          leading:Icon(Icons.info_outline,color:Colors.white,),
          onTap:(){
            showModalBottomSheet(
           isScrollControlled: true,
           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
           context: context,
           builder:(context)=>Container(
           padding: const EdgeInsets.only(top:20.0,bottom:30),
           color: Colors.black,
           child:Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
            padding: const EdgeInsets.only(top:50,right:10,left:10,bottom:0),
            child: Text(AppLocalizations.of(context).about_us,
            style:TextStyle(fontSize:28,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(text:TextSpan(text:"خول پروژێ تایبەت بو بەلاف کرنا خولێن فێربونێ د بوارێن جوداجودا دا ، خول هاتیە دروست کرن بو کوم ڤەکرنا خولێن فێربونێ دگەل چەندین کار ئاسانیا بو هەمی بکارهێنەرێن خولێ ژوان ژی چەندین خولێن بێبەرامبەر بو قوتابیێن زانکو و پەیمانگەها ، ئێك ژ خالێن دی ئەوە خولێن ب پارە دشێن بێبەرامبەر ب دەست خوڤە بینێن ب کوم ڤەکرنا پارەی بو جزدانا بکارهێنەری ب دیتنا رێکلاما ، چەندین بەشێن دی ل دەمێن داهاتی دا دێ گوهورینێن زێدەتر د خول دا هێنەکرن ، چەندین هزرێن تایبەت مە یێن هەین خول روژ ب روژ د هەولا بەرەف پێشڤەبرنا پلاتفورما خو دابیت پێخەمەت بەرف پێشڤەبرنا ئاسێ زانستی و ب دیجیتال کرن و بلەز ئێخستنا کارێ وە .",style:TextStyle(color: Colors.grey,fontWeight:FontWeight.w100,fontFamily:'kurdi',fontSize: 15))),
            )
            ],
            )));
          }
          ),


        ListTile(title:Text(AppLocalizations.of(context).log_out,maxLines:1,overflow:TextOverflow.ellipsis,
          style:TextStyle(color: Colors.white,fontFamily:'kurdi',fontSize: 15)),
          leading:Icon(Icons.logout_rounded,color:Colors.white,),
          onTap:()async{
            SharedPreferences sharedPref = await SharedPreferences.getInstance();
            sharedPref.clear();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('login');
        }),
         
      ],),
     )
    );
  }
}
