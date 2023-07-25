import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class n1 extends StatefulWidget {
  n1({super.key,required this.title,required this.subtitle,required this.description,required this.icon});
  String title;
  String subtitle;
  String description;
  String icon;
  @override
  State<n1> createState() => _n1State();
}

class _n1State extends State<n1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent,
      body:GestureDetector(//onTap:()=>Navigator.pop(context),
      child: Container(padding:EdgeInsets.all(10),color:Colors.transparent,
      child:Column(children: [
        AnimatedContainer(duration:Duration(seconds:1),height:250,decoration:BoxDecoration(color:Colors.black,border:Border.all(color:Colors.grey.withOpacity(0.3)),borderRadius:BorderRadius.circular(50),
        boxShadow:[BoxShadow(color:Colors.grey.withOpacity(0.2),blurRadius:15,spreadRadius:5)]),
        child:Stack(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                    style:TextStyle(fontSize:18,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                    Text(widget.subtitle,
                    style:TextStyle(fontSize:12,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white60),),
                  ],
                ),
                SizedBox(height:45,width:45,child: ClipRRect(borderRadius:BorderRadius.circular(100),child: Container(color:Colors.white.withOpacity(0.1),child:Icon(widget.icon=="error"?Icons.error_outline:Icons.done,color:widget.icon=="error"?Color.fromARGB(255, 244, 102, 92):Colors.green,))))
              ]),
                Text(widget.description,
                style:TextStyle(fontSize:20,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                GestureDetector(
                  child: Container(decoration:BoxDecoration(color:Colors.grey.withOpacity(0.1),
                  borderRadius:BorderRadius.circular(20),boxShadow:[BoxShadow(color:Colors.grey.withOpacity(0.1),blurRadius:5,spreadRadius:3)]),height:MediaQuery.of(context).size.height*0.05,width:MediaQuery.of(context).size.width*1,
                  child:Center(
                    child: Text(AppLocalizations.of(context).ok,
                    style:TextStyle(fontSize:18,fontFamily:'kurdi',fontWeight:FontWeight.w700,color: Colors.white),),
                  ),),
                  onTap:()=>Navigator.pop(context),
                )
              ],),
            )
          ]),
        )
      ],),),
    ));
  }
}