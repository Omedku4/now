import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xol/service/ad_mob_service.dart';

import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/mycourse.dart';
import 'screen/profile.dart';
import 'screen/screen.dart';
import 'screen/search.dart';
import 'screen/splash.dart';
//this sourse code not suport web this only ios and android
late SharedPreferences sharedPref;
Future main()async{

  WidgetsFlutterBinding.ensureInitialized();
  
  sharedPref = await SharedPreferences.getInstance();
  if(kIsWeb){
   await Firebase.initializeApp(
    options:FirebaseOptions(
    apiKey: "AIzaSyA8U2qF0jV-Bc_KlMBc30sY1Gzov5Qb6eE",
    authDomain: "xol-omed.firebaseapp.com",
    projectId: "xol-omed",
    storageBucket: "xol-omed.appspot.com",
    messagingSenderId: "798590984504",
    appId: "1:798590984504:web:33b415f406365c4c7221cd"
     ),
     );
  }else{
   await Firebase.initializeApp();
  }
  MobileAds.instance.initialize();
  Platform.isAndroid?AdMobService.adAndroid():AdMobService.adios();
  savepref(String lang, String zarav)async{
    sharedPref.setString("lang",lang);
    sharedPref.setString("zarav",zarav);
  }
  //savepref('en', 'IQ');
  lang(){return sharedPref.getString("lang")=='ar'?'ar':'en';}
  zarav(){
    if(sharedPref.getString("zarav")=='IQ'){return 'IQ';}
    else if(sharedPref.getString("zarav")=='SY'){return 'SY';}
    else{return '';}
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
    AppLocalizations.delegate, // Add this line
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    ],

    supportedLocales: [
    Locale('en'), // English
    Locale('ar'),
    Locale('ar','SY'),//sorani
    Locale('ar','IQ'), //kurdi-badini
    ],

    locale: Locale(lang(),zarav()),
    theme: ThemeData(primaryColor: Colors.black,),
    
    
    //initialRoute:sharedPref.getString("id") == null?'/':'dashbord',
    initialRoute:'/',
    routes: {
      '/':(context) => splash(),
        'login':(context) => login(),
        'home':(context) => home(),
        'search':(context) => search(),
        'screen':(context) => screen(),
        // 'showcourse':(context) => showcourse(),
        // 'videop':(context) => videop(),
        'mycourse':(context) => mycourse(),
        // 'listvideo':(context) => listvideo(),
        'profile':(context) => profile(),
    }
  ));
}
