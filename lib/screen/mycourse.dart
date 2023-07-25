import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xol/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './listvideo.dart';
class mycourse extends StatefulWidget {
  const mycourse({super.key});

  @override
  State<mycourse> createState() => _mycourseState();
}

class _mycourseState extends State<mycourse> {
 
 
  late List<Map<String,dynamic>>itemscourse;
  bool isloadedcourse = false;

  getdatacourse()async{
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  var collectioncourse=FirebaseFirestore.instance.collection("users").doc(sharedPref.getString("uid")).collection("mycourse");
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


  saveimg(String url)async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("img",url);
  }
  savecoursid(String id)async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("coursid",id);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getdatacourse();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:isloadedcourse==false?Center(child:CircularProgressIndicator(color:Colors.indigo,),) :ListView(children: [
         
        //card   
        SizedBox(height:itemscourse.length*150,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount:itemscourse.length,
            itemBuilder:(context, index) {
            return GestureDetector(
              onTap:(){setState(() {
                // Navigator.pushNamed(context,'listvideo');
                Navigator.of(context).push(MaterialPageRoute(builder:(context){
                 return listvideo(img: itemscourse[index]['img'],id:itemscourse[index]['idcourse'].toString());
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
                      child: Container(width:80,height:100,child:Image.network(itemscourse[index]["img"],fit:BoxFit.cover,),),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(width:MediaQuery.of(context).size.width-120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(maxLines:1,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[index]['title'],style:TextStyle(fontFamily:'kurdi',color:Colors.white,fontSize:18))),
                          RichText(maxLines:2,overflow:TextOverflow.ellipsis,text:TextSpan(text:itemscourse[index]['description'],style:TextStyle(fontFamily:'kurdi',color:Colors.white70,fontSize:12))),
                          //money
                          Padding(
                           padding: const EdgeInsets.only(bottom:1.0,top:5.0),
                           child: Row( 
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [ Row(children: [
                           Text(itemscourse[index]['h'].toString()+AppLocalizations.of(context).h+' '+itemscourse[index]['m'].toString()+AppLocalizations.of(context).m+' ',style:TextStyle(color:Colors.white38,fontSize:10,fontFamily:'kurdi',fontWeight:FontWeight.w600,letterSpacing:0.5)),
                           SizedBox(width:5,height:5,child:Container(decoration:BoxDecoration(color:Colors.indigoAccent,borderRadius:BorderRadius.circular(10)),),),
                           Text(' '+itemscourse[index]['lesson'].toString()+' '+AppLocalizations.of(context).lesson,style:TextStyle(color:Colors.white38,fontSize:10,fontFamily:'kurdi',fontWeight:FontWeight.w600,letterSpacing:0.5))]),
                           //Text('IQD'+' '+'200,000',style:TextStyle(color:Colors.redAccent,fontSize:12,fontWeight:FontWeight.bold,decoration:TextDecoration.lineThrough,decorationColor:Color.fromARGB(255, 12,12, 12),decorationThickness:3),),
                           Text(NumberFormat.decimalPattern('en_us').format(itemscourse[index]['price'].toString()==null?0:int.parse(itemscourse[index]['price'].toString()))+' '+AppLocalizations.of(context).iqd,style:TextStyle(color:Colors.indigoAccent,fontSize:12,fontFamily:'kurdi',fontWeight:FontWeight.bold))
                          ])),
                          //end money
                        ],
                      ),
                    ),
                  ),
                ],),
              ),
            ));
          }),
        ),
      
        //end card
      ]),
    );
  }
}