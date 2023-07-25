import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xol/screen/listitem.dart';
import 'package:xol/screen/showcourse.dart';

import '../service/ad_mob_service.dart';


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  var collection=FirebaseFirestore.instance.collection("reklam");
  late List<Map<String,dynamic>>itemS;
  bool isloaded = false;

  getdata()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collection.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemS=tempList;
     isloaded=true;
   });
  }
  //end reklam
  var collectioncard=FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:'programing');
  late List<Map<String,dynamic>>itemscard;
  bool isloadedcard = false;

  getdatacard()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard=tempList;
     isloadedcard=true;
   });
  }
  //end card

  var collectioncard_free=FirebaseFirestore.instance.collection("courses").where('price',isEqualTo:0);
  late List<Map<String,dynamic>>itemscard_free;
  bool isloadedcard_free = false;

  getdatacard_free()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard_free.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard_free=tempList;
     isloadedcard_free=true;
   });
  }
  //end card-free

  var collectioncard_it=FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:'it');
  late List<Map<String,dynamic>>itemscard_it;
  bool isloadedcard_it = false;

  getdatacard_it()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard_it.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard_it=tempList;
     isloadedcard_it=true;
   });
  }
  //end card-it

  var collectioncard_design=FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:'design');
  late List<Map<String,dynamic>>itemscard_design;
  bool isloadedcard_design = false;

  getdatacard_design()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard_design.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard_design=tempList;
     isloadedcard_design=true;
   });
  }
  //end card-design

  
  var collectioncard_language=FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:'language');
  late List<Map<String,dynamic>>itemscard_language;
  bool isloadedcard_language = false;

  getdatacard_language()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard_language.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard_language=tempList;
     isloadedcard_language=true;
   });
  }
  //end card-language
    
  var collectioncard_pola12=FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:'pola12');
  late List<Map<String,dynamic>>itemscard_pola12;
  bool isloadedcard_pola12 = false;

  getdatacard_pola12()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncard_pola12.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscard_pola12=tempList;
     isloadedcard_pola12=true;
   });
  }
  //end card-pola12

  var collectioncategory=FirebaseFirestore.instance.collection("category");
  late List<Map<String,dynamic>>itemscategory;
  bool isloadedcategory = false;

  getdatacategory()async{
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncategory.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscategory=tempList;
     isloadedcategory=true;
   });
  }
  //end category
  lang_font(){return'kurdi';}

  int current=0;
  String? fullname;
  bool fuser=false;
  getuser()async{
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  if(fuser==false){
  setState(() {
  fullname=sharedPref.getString("fullname");
  fuser=true;
  });
  }
  }

  late InterstitialAd _interstitialAd;
  bool _isloadInterstitialAd=false;
  void _initAd(){
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: AdRequest(), 
      adLoadCallback:InterstitialAdLoadCallback(
        onAdLoaded:(ad) {
          _interstitialAd=ad;
          _interstitialAd.show();
        },
        onAdFailedToLoad:(error) {
          print('=====================eerrpr');
        },)
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    getdatacard();
    getdatacard_free();
    getdatacard_it();
    getdatacard_design();
    getdatacard_language();
    getdatacard_pola12();
    getuser();
    getdatacategory();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ListView(
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom:5.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(AppLocalizations.of(context).welcome,style: TextStyle(color:Colors.grey[500],fontFamily:lang_font(),fontSize:18)),
          Text('${fullname}',style: TextStyle(color:Colors.grey[200],fontFamily:lang_font(),fontSize:24)),],),
        ),
        SizedBox(height:395,width:double.maxFinite,
        child:AnotherCarousel(
        dotBgColor: Colors.transparent,
        dotColor: Color.fromARGB(255, 33, 33, 33),
        dotIncreasedColor:Colors.indigoAccent,
        dotIncreaseSize:1.2,
        dotSize:8.0,
        animationDuration: Duration(milliseconds:800),
        autoplayDuration:Duration(milliseconds:9000),
        images:[
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[0]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[0]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[0]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[0]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[0]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[0]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end1
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[1]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[1]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[1]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[1]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[1]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[1]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end2
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[2]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[2]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[2]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[2]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[2]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[2]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end3
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[3]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[3]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[3]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[3]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[3]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[3]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end4
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[4]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[4]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[4]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[4]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[4]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[4]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end5
        isloaded?Column(children:[
        SizedBox(width:double.infinity,height:160,child:Container(color: Colors.indigoAccent,child:Image(image:NetworkImage(itemS[5]['img']),fit:BoxFit.cover),),),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(maxLines:3,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemS[5]['title']+'\n',
              style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 40) ,
              children:<InlineSpan>[
                TextSpan(text:itemS[5]['description'],
                style: TextStyle(color: Colors.grey,fontFamily:lang_font(),fontSize: 15)),
              ])),
              SizedBox(height: 10,),
              GestureDetector(child:Container(
                decoration: BoxDecoration(color:Colors.indigo,borderRadius: BorderRadius.circular(5)),
                width:double.infinity,height:50,child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text(itemS[5]['bdescription'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:12,fontWeight:FontWeight.w400)),
                Text(itemS[5]['btitle'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontWeight:FontWeight.bold))
              ])),
              onTap:(){
                setState(() {
                Uri pdf=Uri.parse(itemS[5]['url']);
                launchUrl(pdf,mode:LaunchMode.externalApplication);
                });
              })
            ])),
        ]):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        //end6
       
        ]),),
        
        Padding(
          padding: const EdgeInsets.only(left:15.0,right:15.0,top:5.0,bottom:10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).category,style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),
        ])),

        SizedBox(height:40,width:double.infinity,
          child:isloadedcategory?ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: itemscategory.length,
          scrollDirection: Axis.horizontal,
          itemBuilder:(context, index) {
         return GestureDetector(
          onTap: () {
            setState(() {
              current =index;
              String a =itemscategory[index]['name'];
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:a);}));

            });
          },
           child: AnimatedContainer(duration:Duration(milliseconds:300),width: 90,margin:EdgeInsets.all(5),
           decoration:BoxDecoration(color:current==index?Colors.indigo:Colors.transparent,
           borderRadius:BorderRadius.circular(15),border:Border.all(color:current==index?Colors.transparent:Colors.grey,width:current==index?0.0:1.5)),
           child:Center(child:Text(itemscategory[index]['name']=='All Course'?AppLocalizations.of(context).all_course:itemscategory[index]['name']=='free'?AppLocalizations.of(context).free:itemscategory[index]['name'],style:TextStyle(color:current==index?Colors.white:Colors.grey,fontFamily:lang_font(),),))),
         );
        }):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text('Programing',style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'programing');}));

              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard[index]['idcourse'].toString();
                String img=itemscard[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard[index]['price'].toString()==null?0:int.parse(itemscard[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
        //card
        
        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text(AppLocalizations.of(context).free,style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'free');}));

              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard_free?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard_free.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard_free[index]['idcourse'].toString();
                String img=itemscard_free[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard_free[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard_free[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard_free[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard_free[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard_free[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard_free[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard_free[index]['price']==null?0:int.parse(itemscard_free[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
      
              
        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text('IT',style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'it');}));

              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard_it?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard_it.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard_it[index]['idcourse'].toString();
                String img=itemscard_it[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard_it[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard_it[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard_it[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard_it[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard_it[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard_it[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard_it[index]['price']==null?0:int.parse(itemscard_it[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
      
              
        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text('Design',style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'design');}));

              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard_design?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard_design.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard_design[index]['idcourse'].toString();
                String img=itemscard_design[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard_design[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard_design[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard_design[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard_design[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard_design[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard_design[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard_design[index]['price']==null?0:int.parse(itemscard_design[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
      

      
              
        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text('Language',style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'language');}));

              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard_language?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard_language.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard_language[index]['idcourse'].toString();
                String img=itemscard_language[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard_language[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard_language[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard_language[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard_language[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard_language[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard_language[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard_language[index]['price']==null?0:int.parse(itemscard_language[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
      
      
              
        Padding(
          padding: const EdgeInsets.only(bottom:15.0,left:15.0,right:15.0,top:20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ Text(AppLocalizations.of(context).best_course_in+' ',style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:22,)),Text('Pola12',style:TextStyle(color:Colors.indigoAccent,fontFamily:lang_font(),fontWeight:FontWeight.bold,fontSize:22,))]),
              GestureDetector(
              onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return listitem(catg:'pola12');}));
              },child: Text(AppLocalizations.of(context).see_all,style:TextStyle(color:Colors.white54,fontFamily:lang_font(),fontSize:12,))),
            ])),
      
        SizedBox(height:220,width:double.infinity,
          child:isloadedcard_pola12?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard_pola12.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
              _initAd();
              setState(() {
                String id =itemscard_pola12[index]['idcourse'].toString();
                String img=itemscard_pola12[index]['img'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img:img,id:id,);
                }));
              });
            },
            child:Container(width:210,margin:EdgeInsets.all(5),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:Color.fromARGB(255, 25,25, 25),),
            child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Padding(
                 padding: EdgeInsets.only(top:5),
                 child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(width:200,height:110,child:Image.network(itemscard_pola12[index]['img'],fit:BoxFit.cover),)),
               ),
               Padding(
                  padding: const EdgeInsets.only(left:8.0,right:8.0),
                  child: RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:'',children:<InlineSpan>[
                     TextSpan(text:itemscard_pola12[index]['title'],style:TextStyle(color:Colors.white,fontFamily:lang_font(),fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard_pola12[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard_pola12[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard_pola12[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(itemscard_pola12[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscard_pola12[index]['price']==null?0:int.parse(itemscard_pola12[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
      



        
        SizedBox(height: 100,)
      ],)
    );
  }
}