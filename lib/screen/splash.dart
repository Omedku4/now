import 'dart:async';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/service/ad_mob_service.dart';
import 'notifications/checkinternet.dart';
import 'notifications/n1.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}
 
class _splashState extends State<splash> {

  AppOpenAd? appOpenAd;
  loadAppOpenAd(){
    AppOpenAd.load(
      adUnitId:AdMobService.appOpendAdUnitId!,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded:(ad) {
        appOpenAd=ad;
        appOpenAd!.show();
      },
       onAdFailedToLoad:(error) {
         print('$error =============');
       },),
      orientation: AppOpenAd.orientationPortrait
    );
  }

  getuser(){
  var user = FirebaseAuth.instance.currentUser;
   return user?.uid;
  }

  var res;
  intialdata()async{
  res=await checkInternet();
  if(res==true){
  Timer(Duration(seconds: 3),()=>loadAppOpenAd());
  Timer(Duration(seconds: 5),()=>Navigator.pushNamed(context,
  getuser()==null?'login':'screen'));
  }else{
  showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).th_no_internet,subtitle:AppLocalizations.of(context).internet,description:AppLocalizations.of(context).pvyicra,icon:'error');});
  }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intialdata();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          SizedBox(width:300,height:300,child:Image.asset(
            'assets/img/xol_logo.PNG'
          )),
          Text('v0.1.2\nomedku4',textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),)
        ],),
      )
        // AppLocalizations.of(context).wtxfl
    );
  }
}