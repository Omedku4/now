import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xol/screen/userprofile.dart';
import 'package:xol/screen/videoplayer/Landscape_Player_Page.dart';

import '../service/ad_mob_service.dart';

class listvideo extends StatefulWidget {
  const listvideo({super.key,required this.img,required this.id});
  final String img;
  final String id;
  @override
  State<listvideo> createState() => _listvideoState();
}

class _listvideoState extends State<listvideo> {
  
  late List<Map<String,dynamic>>itemscourse;
  bool isloadedcourse = false;

  getdatacourse()async{
  var collectioncourse=FirebaseFirestore.instance.collection("courses").where('idcourse',isEqualTo:widget.id);
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
  //end getdata
  
  late List<Map<String,dynamic>>itemswyl;
  bool isloadedwyl = false;

  getdatawyl()async{
  var collectionwyl=FirebaseFirestore.instance.collection("courses").doc(widget.id).collection("whatlearn");
  List<Map<String,dynamic>>tempList=[];
  var data = await collectionwyl.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  
  });
   setState(() {
     itemswyl=tempList;
     isloadedwyl=true;
   });
  }
  //end what is learn
  
  late List<Map<String,dynamic>>itemslesson;
  bool isloadedlesson = false;

  getdatalesson()async{
  var collectionlesson=FirebaseFirestore.instance.collection("courses").doc(widget.id).collection("lesson");
  List<Map<String,dynamic>>tempList=[];
  var data = await collectionlesson.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  
  });
   setState(() {
     itemslesson=tempList;
     isloadedlesson=true;
   });
  }
  //end get lesson
 
  RewardedAd? _rewardedAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatacourse();
    getdatalesson();
    getdatawyl();
  }

  
  @override
  Widget build(BuildContext context) {
    return isloadedcourse==false?Scaffold(backgroundColor:Colors.black,body:Center(child:CircularProgressIndicator(color:Colors.indigo,)),):Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(title:Text(itemscourse[0]['title'],
      style:TextStyle(fontFamily:'kurdi',color:Color.fromARGB(225, 255, 255, 255)),),
      leading:GestureDetector(onTap:(){
        setState(() {
          Navigator.pop(context);
        });
      },child: Icon(Icons.arrow_back_ios_new)),
      backgroundColor:Colors.black,),
      body:ListView(children: [
        SizedBox(height:200,
        child:Stack(
          alignment:Alignment.center,
          children: [
          SizedBox(height:200,width:double.infinity,child:Container(child:Image.network(widget.img.toString(),fit:BoxFit.cover,),)),
          Container(color:Colors.black26,),
        ])),
        //

          isloadedlesson==false?Center(child:CircularProgressIndicator(color:Colors.indigo,)):SizedBox(height:itemslesson.length*80,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount:itemslesson.length,
            itemBuilder:(context, index) {
            return ListTile(
            title:Text(itemslesson[index]['title'],maxLines:1,overflow:TextOverflow.ellipsis,
            style:TextStyle(color: Colors.white,fontFamily:'kurdi',fontSize: 15)),
            subtitle:Text(itemslesson[index]['description'],
            maxLines:1,overflow:TextOverflow.ellipsis,
            style:TextStyle(color: Colors.grey,fontFamily:'kurdi',fontSize: 12)),
            leading:Text((index+1).toString(),
            style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontSize: 30)),
            trailing:itemslesson[index]['link']!=""?GestureDetector(child: Icon(Icons.link,color:Color.fromRGBO(158, 158, 158, 1)),
             onTap:()=>setState(() {
              launchUrl(Uri.parse(itemslesson[index]['link']),mode:LaunchMode.externalApplication);
             }),):Text(''),
            
            onTap:(){
              
                        //start ad
              RewardedAd.load(
              adUnitId:AdMobService.rewardedAdUnitId!,
              rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (RewardedAd ad){
              print('$ad loead.===============');
              setState(() {
              this._rewardedAd=ad;
              _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
              },);});},
              onAdFailedToLoad: (LoadAdError error){print('filde==================$error');}),
              request: AdRequest(),);
              //end ad
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return LandscapePlayerPage(title:itemslesson[index]['title'],video:itemslesson[index]['video']);
                }));
              });
            },
            );
          }),
        ),
      
        //end card
        
        //
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RichText(maxLines:5,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[0]['title']+'\n',
            style:TextStyle(color: Colors.white,fontFamily:'kurdi',fontSize: 30) ,
            children:<InlineSpan>[
            TextSpan(text: itemscourse[0]['description'],
            style: TextStyle(color: Colors.grey,fontWeight:FontWeight.w100,fontFamily:'kurdi',fontSize: 15)),
          ]))),

      Padding(padding: const EdgeInsets.all(10.0),
        child:Column(children: [
          Row(children:[Text(AppLocalizations.of(context).create_by+' ',style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:20,color:Colors.white)),GestureDetector(child: Text(itemscourse[0]['create'],style:TextStyle(fontFamily:'kurdi',fontSize:20,color:Colors.indigoAccent),),onTap:(){Navigator.push(context,MaterialPageRoute(builder:(context)=>userprofile(username:itemscourse[0]['create'],id:itemscourse[0]['createid'],)));},)]),
          Row(children:[Icon(Icons.new_releases,size:18,color:Colors.white70,),Text(' '+AppLocalizations.of(context).last_updated+' '+itemscourse[0]['update'],style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.language,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['language'],style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.closed_caption,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['cc'],style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.smart_display,size:18,color:Colors.white70,),Text(' '+AppLocalizations.of(context).lesson+' '+itemscourse[0]['lesson'].toString()+' , '+itemscourse[0]['h'].toString()+' '+AppLocalizations.of(context).h+' '+itemscourse[0]['m'].toString()+' '+AppLocalizations.of(context).m,style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:12,color:Colors.white70),)]),
          Row(children:[Icon(Icons.groups,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['students'].toString(),style:TextStyle(fontFamily:'kurdi',fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          ])),

      Container(margin:EdgeInsets.all(10),padding:EdgeInsets.all(10) ,
       decoration:BoxDecoration(color:Color.fromARGB(255, 20, 20, 20),borderRadius:BorderRadius.circular(10)),
        child: Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Text(AppLocalizations.of(context).wyl,style:TextStyle(fontFamily:'kurdi',fontSize:20,color:Colors.white)),
            ),
            isloadedwyl==true?SizedBox(height:itemswyl.length*60,
              child: ListView.builder(
                itemCount:itemswyl.length,
                itemBuilder:(context, index) {
                return ListTile(dense:true,leading:Icon(Icons.done,color:Colors.white70,size:20,),
                  title:Text(itemswyl[index]['title'],maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(color: Colors.white70,fontFamily:'kurdi',fontSize: 15)),) ;
              }),
            ):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
          ])),
      ],),
    );
  }
  // savevideo()async{
  //    SharedPreferences sharedPref = await SharedPreferences.getInstance();
  //   selectvideo = sharedPref.getInt("videoid")==null?0:sharedPref.getInt("videoid");
  // }
}