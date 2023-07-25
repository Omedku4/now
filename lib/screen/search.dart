import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../service/ad_mob_service.dart';
import './showcourse.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  lang_font(){return'kurdi';}
  TextEditingController search_f = new TextEditingController();
  
  String? Scategory="All Course";
  
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

  late List<Map<String,dynamic>>itemscourse;
  bool isloadedcourse = false;

  getdatacourse()async{
  var collectioncourse=search_f.text!=""?FirebaseFirestore.instance.collection("courses").where('title',isGreaterThanOrEqualTo:search_f.text.toLowerCase()):Scategory=="free"?FirebaseFirestore.instance.collection("courses").where('price',isLessThanOrEqualTo:0):Scategory!="All Course"?FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:Scategory):FirebaseFirestore.instance.collection("courses");
  List<Map<String,dynamic>>tempList=[];
  var data = await collectioncourse.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemscourse=tempList;
     isloadedcourse=true;
   });
  }
  //end course

  int current=0;


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
    getdatacategory();
    getdatacourse();
  }
  @override
  Widget build(BuildContext context) {
    return isloadedcourse==false?Scaffold( backgroundColor: Colors.black,body:Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),)):Scaffold(
        backgroundColor: Colors.black,
      body:ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left:12.0,right:12.0,top:0.0,bottom:20),
          child: SizedBox(height:40,
            child: CupertinoTextField(
              placeholderStyle:TextStyle(color:Colors.grey),
              cursorColor: Colors.indigo,cursorWidth: 2,
              placeholder:AppLocalizations.of(context).search+' ... ',
              controller:search_f,
              style: TextStyle(color: Colors.white,fontSize:15,fontWeight:FontWeight.w100,fontFamily:lang_font()),
              prefix:Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.search,color:Colors.white,weight:10)),
                suffix:Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(onTap:() {
                  setState(() {
                  search_f.text="";
                  getdatacourse();
                  });
                  },child:Icon(Icons.clear_rounded,color:Colors.grey,))),
                  suffixMode:OverlayVisibilityMode.editing,
                  decoration: BoxDecoration(
                  color:Colors.grey[900],
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged:(value) {
                  setState(() {
                  getdatacourse();
                  });
                },))),
         
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
              Scategory=itemscategory[index]['name'];
              getdatacourse();
            });
          },
           child: AnimatedContainer(duration:Duration(milliseconds:300),width: 90,margin:EdgeInsets.all(5),
           decoration:BoxDecoration(color:current==index?Colors.indigo:Colors.transparent,
           borderRadius:BorderRadius.circular(15),border:Border.all(color:current==index?Colors.transparent:Colors.white30,width:current==index?0.0:1.5)),
           child:Center(child:Text(itemscategory[index]['name']=='All Course'?AppLocalizations.of(context).all_course:itemscategory[index]['name']=='free'?AppLocalizations.of(context).free:itemscategory[index]['name'],style:TextStyle(color:current==index?Colors.white:Colors.grey,fontFamily:lang_font(),),))),
         );
        }):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        ),
        
        //card   
        SizedBox(height:itemscourse.length*150,
          child:isloadedcourse?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount:itemscourse.length,
            itemBuilder:(context, index) {
            return GestureDetector(
              onTap:(){
                _initAd();
                setState(() {
                // Navigator.pushNamed(context,'showcourse');
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return showcourse(img: itemscourse[index]['img'],id:itemscourse[index]['idcourse'].toString());
                }));
              });},
              child:Padding(
              padding: const EdgeInsets.only(left:10.0,right:10.0,top:10,bottom:0.0),
              child: Container(
                height:110,
                decoration:BoxDecoration(
                  color:Color.fromARGB(255, 25, 25, 25),
                  borderRadius:BorderRadius.circular(10)
                ),
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(borderRadius:BorderRadius.circular(8),
                      child: Container(width:80,height:100,child:Image.network(itemscourse[index]['img'],fit:BoxFit.cover,),),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(width:MediaQuery.of(context).size.width-120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(maxLines:1,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[index]['title'],style:TextStyle(fontFamily:lang_font(),color:Colors.white,fontSize:18))),
                          RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[index]['description'],style:TextStyle(fontFamily:lang_font(),color:Colors.white70,fontSize:12))),
                          //money
                          Padding(
                           padding: const EdgeInsets.only(bottom:1.0,top:5.0),
                           child: Row( 
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [ Row(children: [
                           Text(itemscourse[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscourse[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white38,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5)),
                           SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                           Text(' '+itemscourse[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white38,fontSize:10,fontFamily:lang_font(),fontWeight:FontWeight.w600,letterSpacing:0.5))]),
                           //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                           Text(itemscourse[index]['price']==0?AppLocalizations.of(context).free:NumberFormat.decimalPattern('en_us').format(itemscourse[index]['price']==null?0:int.parse(itemscourse[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold))
                          ])),
                          //end money
                        ],
                      ),
                    ),
                  ),
                ],),
              ),
            ));
          }):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
        ),
      
        //end card
      ]),
    );
  }
}