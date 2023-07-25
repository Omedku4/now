import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:xol/screen/showcourse.dart';

class listitem extends StatefulWidget {
  listitem({super.key,required this.catg});
  String catg;
  @override
  State<listitem> createState() => _listitemState();
}

class _listitemState extends State<listitem> {
  lang_font(){return'kurdi';}
  late List<Map<String,dynamic>>itemscourse;
  bool isloadedcourse = false;

  getdatacourse()async{
  var collectioncourse=widget.catg=="free"?FirebaseFirestore.instance.collection("courses").where('price',isLessThanOrEqualTo:0):widget.catg!="All Course"?FirebaseFirestore.instance.collection("courses").where('category',isEqualTo:widget.catg):FirebaseFirestore.instance.collection("courses");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatacourse();
  }
  @override
  Widget build(BuildContext context) {
     return isloadedcourse==false?Scaffold( backgroundColor: Colors.black,body:Center(child:CircularProgressIndicator(color:Colors.indigoAccent,),)):Scaffold(
        backgroundColor: Colors.black,
      appBar:AppBar(title:Text(widget.catg=='All Course'?AppLocalizations.of(context).all_course:widget.catg=='free'?AppLocalizations.of(context).free:widget.catg,
      style:TextStyle(fontFamily:lang_font(),color:Color.fromARGB(225, 255, 255, 255)),),
      leading:GestureDetector(onTap:(){
        setState(() {
          Navigator.pop(context);
        });
      },child: Icon(Icons.arrow_back_ios_new)),
      backgroundColor:Colors.black,),
      body:ListView(children: [
        
        //card   
        SizedBox(height:itemscourse.length*150,
          child:isloadedcourse?ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount:itemscourse.length,
            itemBuilder:(context, index) {
            return GestureDetector(
              onTap:(){setState(() {
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