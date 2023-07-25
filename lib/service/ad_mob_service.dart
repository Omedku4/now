import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdMobService{

  static String? rewarded_ID,Interstitial_ID,app_open_ID,rewarded_interstitial_ID;
  static void adAndroid()async{
  var android = FirebaseFirestore.instance.collection('ads').where('os',isEqualTo:'android');
  var querySnapshot = await android.get();
  for(var queryDocSnapshot in querySnapshot.docs){
  Map<String,dynamic>data=queryDocSnapshot.data();
  rewarded_ID = data['rewarded_ID'].toString();
  Interstitial_ID = data['Interstitial_ID'].toString();
  app_open_ID = data['app_open_ID'].toString();
  rewarded_interstitial_ID = data['rewarded_interstitial_ID'].toString();
  }
  }

  //ios
  static String? rewarded_ID_ios,Interstitial_ID_ios,app_open_ID_ios,rewarded_interstitial_ID_ios;
  static void adios()async{
  var ios = FirebaseFirestore.instance.collection('ads').where('os',isEqualTo:'ios');
  var querySnapshot = await ios.get();
  for(var queryDocSnapshot in querySnapshot.docs){
  Map<String,dynamic>data=queryDocSnapshot.data();
  rewarded_ID_ios = data['rewarded_ID'].toString();
  Interstitial_ID_ios = data['Interstitial_ID'].toString();
  app_open_ID_ios = data['app_open_ID'].toString();
  rewarded_interstitial_ID_ios = data['rewarded_interstitial_ID'].toString();
  }
  }
  
  static String? get rewardedInterstitialAdUnitId{
    if(Platform.isAndroid){return '$rewarded_interstitial_ID';}
    else if(Platform.isIOS){return '$rewarded_interstitial_ID_ios';}
    else{return null;}
  }

  static String? get rewardedAdUnitId{
    if(Platform.isAndroid){return '$rewarded_ID';}
    else if(Platform.isIOS){return '$rewarded_ID_ios';}
    else{return null;}
  }

  static String? get appOpendAdUnitId{
    if(Platform.isAndroid){return '$app_open_ID';}
    else if(Platform.isIOS){return '$app_open_ID_ios';}
    else{return null;}
  }

  static String? get interstitialAdUnitId{
    if(Platform.isAndroid){return '$Interstitial_ID';}
    else if(Platform.isIOS){return '$Interstitial_ID_ios';}
    else{return null;}
  }
}