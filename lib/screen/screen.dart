import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xol/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:xol/screen/home.dart';
import 'package:xol/screen/profile.dart';
import 'package:xol/screen/search.dart';
import 'package:xol/screen/mycourse.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../service/ad_mob_service.dart';

class screen extends StatefulWidget {
  const screen({super.key});

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {

  // late InterstitialAd _interstitialAd;
  // bool _isloadInterstitialAd=false;
  // void _initAd(){
  //   InterstitialAd.load(
  //     adUnitId: AdMobService.interstitialAdUnitId!,
  //     request: AdRequest(), 
  //     adLoadCallback:InterstitialAdLoadCallback(
  //       onAdLoaded:(ad) {
  //         _interstitialAd=ad;
  //         _interstitialAd.show();
  //       },
  //       onAdFailedToLoad:(error) {
  //         print('=====================eerrpr');
  //       },)
  //   );
  // }
  lang_font(){return'kurdi';}
  int screen_index=0;
  screenapp(int s){
  if(s==0){
    return home();
  }else if(s==1){
    return search();
  }else if(s==2){
    return mycourse();
  }else if(s==3){
    return profile();
  }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
      //buttom nav bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left:20,right:20,bottom:20),
        padding: EdgeInsets.only(top: 5,bottom:5,left:10,right: 10),
        decoration:BoxDecoration(
       
        color: Colors.black.withOpacity(1),borderRadius:BorderRadius.circular(20)),
        child: GNav(gap: 8,backgroundColor: Colors.black,color: Colors.grey[800],
        activeColor: Colors.white,
        selectedIndex: screen_index,
        onTabChange: (i){
         setState(() {
        //  _initAd();
         if(i==0){
          screen_index=0;
         }else if(i==1){
          screen_index=1;
         }else if(i==2){
          screen_index=2;
         }else if(i==3){
          screen_index=3;
         }
         });
        }
        ,tabBackgroundColor: Color.fromARGB(255, 33, 33, 33),padding: EdgeInsets.all(10),tabs: [
          GButton(icon: Icons.home,iconSize:30,text:AppLocalizations.of(context).main,textStyle:TextStyle(fontFamily:lang_font(),color:Colors.white),),
          GButton(icon: Icons.search_rounded,iconSize:30,text:AppLocalizations.of(context).search,textStyle:TextStyle(fontFamily:lang_font(),color:Colors.white)),
          GButton(icon: Icons.video_collection,iconSize:30,text: AppLocalizations.of(context).my_courses,textStyle:TextStyle(fontFamily:lang_font(),color:Colors.white)),
          GButton(icon: Icons.person,iconSize:30,text: AppLocalizations.of(context).profile,textStyle:TextStyle(fontFamily:lang_font(),color:Colors.white)),
        ]),),
      //end nav bar
      body:screenapp(screen_index)==null?Text('omed',style:TextStyle(color:Colors.white),):screenapp(screen_index),
    );
  }
}