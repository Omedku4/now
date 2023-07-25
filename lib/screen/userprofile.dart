import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xol/screen/showcourse.dart';

class userprofile extends StatefulWidget {
  userprofile({super.key,required this.username,required this.id});
  String  id;
  String username;
  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  
  late List<Map<String,dynamic>>itemsuser;
  bool isloadeduser = false;

  getdatauser()async{
  var collectionuser=FirebaseFirestore.instance.collection("instructor").where('id',isEqualTo:widget.id);
  List<Map<String,dynamic>>tempList=[];
  var data = await collectionuser.get();
  
  data.docs.forEach((element) {
  tempList.add(element.data());
  });
   setState(() {
     itemsuser=tempList;
     isloadeduser=true;
   });
  }
  //end userinfo
  late List<Map<String,dynamic>>itemscard;
  bool isloadedcard = false;

  getdatacard()async{
  var collectioncard=FirebaseFirestore.instance.collection("courses").where('createid',isEqualTo:widget.id);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatauser();
    getdatacard();
  }
  @override
  Widget build(BuildContext context) {
   
    return isloadeduser==false?Scaffold( backgroundColor: Colors.black,body:Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),)):Scaffold(
     appBar:AppBar(title:Text(itemsuser[0]['fullname'],
     style:TextStyle(fontFamily:'kurdi',color:Color.fromARGB(225, 255, 255, 255)),),
     leading:GestureDetector(onTap:(){
        setState(() {
          Navigator.pop(context);
        });
      },child: Icon(Icons.arrow_back_ios_new)),
      backgroundColor:Colors.black,),
     backgroundColor: Colors.black,
     body:Padding(
       padding: const EdgeInsets.all(10.0),
       child: ListView(children: [
        Container(padding:EdgeInsets.all(30.0),child:Column(children: [
          Container(height:120,width:120,
          decoration:BoxDecoration(color:Colors.grey[900],borderRadius:BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(borderRadius:BorderRadius.circular(100),child:Image.network(itemsuser[0]['img'],fit:BoxFit.cover,),),
          )),
          Row(mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text(itemsuser[0]['fullname'],
              style:TextStyle(fontSize:28,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
              Icon(Icons.verified,color:Colors.indigoAccent,)
            ]),
         SizedBox(height:20,child:RichText(maxLines:1,overflow:TextOverflow.ellipsis,text:TextSpan(
          style:TextStyle(fontSize:14,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.grey),
          text:itemsuser[0]['aboutme'])),)
        ],),),
        Container(child:Column(children: [
        Row(children: [Text(AppLocalizations.of(context).total_students,style:TextStyle(fontFamily:'kurdi',color:Colors.grey),),Text(':'+itemsuser[0]['totalstudent'].toString(),style:TextStyle(fontFamily:'kurdi',color:Colors.grey),)],),
        ],),),
        GestureDetector(
          child: Container(height:40,alignment:Alignment.center,decoration:BoxDecoration(color:Color.fromARGB(255, 25,25, 25),borderRadius:BorderRadius.circular(10)),
          child:Text('CV',textAlign:TextAlign.center,
          style:TextStyle(fontSize:15,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white))),
          onTap:()=>setState(() {
              launchUrl(Uri.parse(itemsuser[0]['cv']),mode:LaunchMode.externalApplication);
             }),
        ),
        SizedBox(height:10,),
        Container(child:Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [
          Text(AppLocalizations.of(context).all_course,
          style:TextStyle(fontSize:20,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
          SizedBox(height:220,width:double.infinity,
          child:isloadedcard?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount:itemscard.length,//15>10?10:15,
            itemBuilder:(context, index) {
            return GestureDetector(
            onTap:() {
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
                     TextSpan(text:itemscard[index]['title'],style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontSize:15,fontWeight:FontWeight.w500))])),
                ),
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0,bottom:8.0),
                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [ Row(children: [
                          Text(itemscard[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscard[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:'kurdi',fontWeight:FontWeight.w600,letterSpacing:0.5)),
                          SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                          Text(' '+itemscard[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white54,fontSize:10,fontFamily:'kurdi',fontWeight:FontWeight.w600,letterSpacing:0.5)),
                        ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                            Text(NumberFormat.decimalPattern('en_us').format(itemscard[index]['price'].toString()==null?0:int.parse(itemscard[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontFamily:'kurdi',fontSize:12,fontWeight:FontWeight.bold),),
                          ],)
                       ],),
               ),
              ],),
            ),);
          }):Center(child:Text('no data',style:TextStyle(color:Colors.white),),),
        ),
        
        ],),)
       ],),
     )
    );
  }
}


