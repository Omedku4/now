import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xol/screen/userprofile.dart';
import 'package:xol/screen/videoplayer/Landscape_Player_Page.dart';

import 'notifications/n1.dart';

class showcourse extends StatefulWidget {
  const showcourse({super.key,required this.img,required this.id});
  final String img;
  final String id;
  @override
  State<showcourse> createState() => _showcourseState();
}

class _showcourseState extends State<showcourse> {

  
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

  
  lang_font(){return'kurdi';}
 final CollectionReference course=FirebaseFirestore.instance.collection("courses");
 final CollectionReference user=FirebaseFirestore.instance.collection("users");
 String? uid;
 getiduser()async{
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  uid=sharedPref.getString("uid");
 }

 
  Future<void> buyCourse(String category,String cc,String create,String description,String h,String idcourse,String img,String language,String lesson,String m,String price,String students,String title,String update,String createid,String video)async{
  return await user.doc(uid).collection("mycourse").doc(idcourse).set({
  "category":category,
  "cc":cc,
  "create":create,
  "description":description,
  "h":h,
  "idcourse":idcourse,
  "img":img,
  "language":language,
  "lesson":lesson,
  "m":m,
  "price":price,
  "students":students,
  "title":title,
  "update":update,
  "createid":createid,
  "video":video,
  "uID":uid
});
}
//end set course buy
 bool isCousre=false;
 Future<void> getcours()async{
  String? id;
  String? _date;
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  var infouserr = FirebaseFirestore.instance.collection('users').doc(sharedPref.getString("uid")).collection("mycourse");
  var querySnapshot = await infouserr.get();
  for(var queryDocSnapshot in querySnapshot.docs){
  Map<String,dynamic>data=queryDocSnapshot.data();
  id=data['idcourse'].toString();
  _date=data['update'].toString();
  }  
  if(id!=null || _date==itemscourse[0]['update'].toString()){
   setState(() {
     isCousre=true;
   });
  }else{isCousre=false;}
 } 
   bool bd=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatacourse();
    getdatawyl();
    getiduser();
    getcours();
  }

  @override
  Widget build(BuildContext context) {
    return isloadedcourse==false ? Scaffold( backgroundColor: Colors.black,body:Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),)):Scaffold(
      bottomNavigationBar:Container(color:Colors.black,height:80,
      padding: EdgeInsets.only(bottom:20,right:15,left:10),
      child:isCousre==true?Center(child: Text(AppLocalizations.of(context).yhtc,style:TextStyle(color:Colors.white70,fontFamily:'kurdi'),)):Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
        //b
         Container(alignment: Alignment.center,
          child: CupertinoButton(padding: EdgeInsets.only(left: 80,right: 80),
           child: Text(itemscourse[0]['price']!=0?AppLocalizations.of(context).buy_now:AppLocalizations.of(context).free,
            style:TextStyle(fontFamily:lang_font(),fontSize: 20,color:Colors.white,fontWeight: FontWeight.w500)),
            color: Colors.indigo,borderRadius: BorderRadius.circular(20),
            onPressed:()async{
             String? money;
             var usermoney = FirebaseFirestore.instance.collection('instructor');//cid
             var infouser = FirebaseFirestore.instance.collection('users').where('uID',isEqualTo:uid.toString());
             var querySnapshot = await infouser.get();
             for(var queryDocSnapshot in querySnapshot.docs){
             Map<String,dynamic>data=queryDocSnapshot.data();
             money=data['Money'].toString();
             }

             if(int.parse(money.toString())>=int.parse(itemscourse[0]['price'].toString()) && bd==false){
             bd=true;
             int a=int.parse(money.toString())-int.parse(itemscourse[0]['price'].toString());
             await user.doc(uid).update({"Money":FieldValue.increment(a)});
             await usermoney.doc(itemscourse[0]['createid'].toString()).update({"money":FieldValue.increment(int.parse(itemscourse[0]['price'].toString())),"totalstudent":FieldValue.increment(1)});
             await course.doc(widget.id).update({"students":FieldValue.increment(1)});
             buyCourse(itemscourse[0]['category'].toString(),itemscourse[0]['cc'].toString(),itemscourse[0]['create'].toString(),itemscourse[0]['description'].toString(),itemscourse[0]['h'].toString(),itemscourse[0]['idcourse'].toString(),itemscourse[0]['img'].toString(),
             itemscourse[0]['language'].toString(),itemscourse[0]['lesson'].toString(),itemscourse[0]['m'].toString(),itemscourse[0]['price'].toString(),itemscourse[0]['students'].toString(),itemscourse[0]['title'].toString(),itemscourse[0]['update'].toString(),itemscourse[0]['createid'].toString(),itemscourse[0]['video'].toString());
             setState(() {
              showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).pwsu,subtitle:AppLocalizations.of(context).buy_now,description:AppLocalizations.of(context).cycnbftc,icon:'sucsseful');});
              getcours();
             });
             }else{
              showDialog(context: context, builder:(context){ return n1(title:AppLocalizations.of(context).pwunsu,subtitle:AppLocalizations.of(context).buy_balance,description:AppLocalizations.of(context).ydnhabtptc,icon:'error');});
             }
            
              
              //buyCourse(itemscourse[0]['category'].toString(),itemscourse[0]['cc'].toString(),itemscourse[0]['create'].toString(),itemscourse[0]['description'].toString(),itemscourse[0]['h'].toString(),itemscourse[0]['idcourse'].toString(),itemscourse[0]['img'].toString(),
              //itemscourse[0]['language'].toString(),itemscourse[0]['lesson'].toString(),itemscourse[0]['m'].toString(),itemscourse[0]['price'].toString(),itemscourse[0]['students'].toString(),itemscourse[0]['title'].toString(),itemscourse[0]['update'].toString(),itemscourse[0]['createid'].toString(),itemscourse[0]['video'].toString());
            })), 
        //end b
        Text(NumberFormat.decimalPattern('en_us').format(itemscourse[0]['price'].toString()==null?0:int.parse(itemscourse[0]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(fontSize: 23,color:Colors.indigoAccent,fontFamily:'kurdi',fontWeight: FontWeight.bold))
      ])),
      backgroundColor: Colors.black,
      appBar:AppBar(title:Text(itemscourse[0]['title'],
      style:TextStyle(fontFamily:lang_font(),color:Color.fromARGB(225, 255, 255, 255)),),
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
          GestureDetector(
            onTap:(){
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return LandscapePlayerPage(title:itemscourse[0]['title'],video:itemscourse[0]['video']);
                }));
              });
            },
            child: Icon(Icons.play_arrow_rounded,color:Colors.white,size:55,))
        ])),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RichText(maxLines:5,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[0]['title']+'\n',
            style:TextStyle(color: Colors.white,fontFamily:lang_font(),fontSize: 30) ,
            children:<InlineSpan>[
            TextSpan(text: itemscourse[0]['description'],
            style: TextStyle(color: Colors.grey,fontWeight:FontWeight.w100,fontFamily:lang_font(),fontSize: 15)),
          ]))),

      Padding(padding: const EdgeInsets.all(10.0),
        child:Column(children: [
          Row(children:[Text(AppLocalizations.of(context).create_by+' ',style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:20,color:Colors.white)),GestureDetector(child: Text(itemscourse[0]['create'],style:TextStyle(fontFamily:lang_font(),fontSize:20,color:Colors.indigoAccent),),onTap:(){Navigator.push(context,MaterialPageRoute(builder:(context)=>userprofile(username:itemscourse[0]['create'],id:itemscourse[0]['createid'],)));},)]),
          Row(children:[Icon(Icons.new_releases,size:18,color:Colors.white70,),Text(' '+AppLocalizations.of(context).last_updated+' '+itemscourse[0]['update'],style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.language,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['language'],style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.closed_caption,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['cc'],style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          Row(children:[Icon(Icons.smart_display,size:18,color:Colors.white70,),Text(' '+AppLocalizations.of(context).lesson+' '+itemscourse[0]['lesson'].toString()+' , '+itemscourse[0]['h'].toString()+' '+AppLocalizations.of(context).h+' '+itemscourse[0]['m'].toString()+' '+AppLocalizations.of(context).m,style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:12,color:Colors.white70),)]),
          Row(children:[Icon(Icons.groups,size:18,color:Colors.white70,),Text(' '+itemscourse[0]['students'].toString(),style:TextStyle(fontFamily:lang_font(),fontWeight:FontWeight.w100,fontSize:15,color:Colors.white70),)]),
          ])),
      
      
      Container(margin:EdgeInsets.all(10),padding:EdgeInsets.all(10) ,
       decoration:BoxDecoration(color:Color.fromARGB(255, 25,25, 25),borderRadius:BorderRadius.circular(10)),
        child: Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Text(AppLocalizations.of(context).wyl,style:TextStyle(fontFamily:lang_font(),fontSize:20,color:Colors.white)),
            ),
            isloadedwyl==true?SizedBox(height:itemswyl.length*60,
              child: ListView.builder(
                itemCount:itemswyl.length,
                itemBuilder:(context, index) {
                return ListTile(dense:true,leading:Icon(Icons.done,color:Colors.white70,size:20,),
                  title:Text(itemswyl[index]['title'],maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(color: Colors.white70,fontFamily:lang_font(),fontSize: 15)),) ;
              }),
            ):Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),),
          ])),
      ],),
    );
  }
}



