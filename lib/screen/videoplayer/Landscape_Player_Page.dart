import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:xol/screen/videoplayer/PControl.dart';

class LandscapePlayerPage extends StatefulWidget {
  const LandscapePlayerPage({super.key,required this.title,required this.video});
  final String title;
  final String video;
  @override
  State<LandscapePlayerPage> createState() => _LandscapePlayerPageState();
}

class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  bool fullscreen=false;
  bool screentime=true;

  Future _landscapeMode() async{
   if(fullscreen){
     await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
   }else{ await SystemChrome.setPreferredOrientations([]);}
  }

  Future _setAllOrientatio()async{
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
  late VideoPlayerController _controller;
  void _PlayeVideo({bool init=false}){

  if(!init){_controller.pause();}
  _controller = VideoPlayerController.network(widget.video)..addListener(() => setState(() {}))
  ..setLooping(true)
  ..initialize().then((value) => _controller.play());
  }
 
 String _videoDuration(Duration duration){
 String twoDigits(int n)=>n.toString().padLeft(2,'0');
 final hours = twoDigits(duration.inHours);
 final minutes = twoDigits(duration.inMinutes.remainder(60));
 final seconds = twoDigits(duration.inSeconds.remainder(60));

 return [
  if(duration.inHours>0)hours,minutes,seconds].join(':');
 }

  
  void screenT(){
    setState(() {screentime=!screentime;});
      // Timer(Duration(seconds: 5),(){setState(() {
      // if(screentime && _controller.value.isPlaying){ screentime=false;}
      // });});
      //  setState(() {
      //    if(screentime && _controller.value.isPlaying){ screentime=false;}
      //  });
  }
  
  Future re10sec()=>goTo((curenp) => curenp - Duration(seconds:10));
  Future fo10sec()=>goTo((curenp) => curenp + Duration(seconds:10));

  Future goTo(
    Duration Function(Duration curenp) builder,
  )async{ 
    final curenp =await _controller.position;
    final newp = builder(curenp!);
    await _controller.seekTo(newp);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _landscapeMode();
    _PlayeVideo(init:true);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays:[]);
  }
  int hvideo=9;//3-9
  int wvideo=16;//4-16-18-21
  @override
  void dispose() {
    _setAllOrientatio();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return InteractiveViewer(
      child: Stack(
        children: [
      Center(child: Container(child: AspectRatio(aspectRatio: wvideo/hvideo,child:VideoPlayer(_controller)))),
      Padding(padding: const EdgeInsets.only(left:50,right:50,top:20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('XOL',style:TextStyle(color:Colors.white,fontFamily:'kurdi',fontSize:20,inherit:false)),
            SizedBox(width:MediaQuery.of(context).size.width/6,height:MediaQuery.of(context).size.height/6,child:Image.asset('assets/img/xol_logo.PNG')),
          ])),
      
      GestureDetector(onTap:(){
       screenT();
      },child: Center(child: Container(color:screentime?Color.fromARGB(139, 0, 0, 0):Color.fromARGB(0, 0, 0, 0)))),
       
      Visibility(
        visible:screentime,
        maintainSize: true,
        maintainAnimation:true,
        maintainState:true,
        child: Stack(children: [
        //
        Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
          Container(height:50,child:Row(
            mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.center,
            children: [
            GestureDetector(onTap:(){setState(() {SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays:[SystemUiOverlay.bottom,SystemUiOverlay.top]);
              Navigator.pop(context);});},
             child: Padding(
               padding: const EdgeInsets.all(15.0),
                  child:Icon(Icons.arrow_back_ios_rounded,color:Colors.white,),)),
              Padding(
                padding: const EdgeInsets.only(top:15.0,bottom:15.0),
                child: Text(widget.title,style:TextStyle(color:Colors.white,fontWeight:FontWeight.w100,fontFamily:'kurdi',fontSize:13,inherit:false),),
              ),
            ]),),
      
          Container(height:90,child:Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            GestureDetector(onTap:() =>re10sec(),child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(Icons.replay_10_rounded,color:Colors.white,size:40,),)),
            GestureDetector(onTap:()=>_controller.value.isPlaying?_controller.pause():_controller.play(),child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow_rounded,color:Colors.white,size:70,),)),
            GestureDetector(onTap:()=>fo10sec(),child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(Icons.forward_10_rounded,color:Colors.white,size:40,),)),
          ],),),
      
          Container(height:50,child:Row(children: [
            GestureDetector(onTap:()=>_controller.value.isPlaying?_controller.pause():_controller.play(),child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow_rounded,color:Colors.white,size:30,),)),
            //
            ValueListenableBuilder(valueListenable: _controller,
              builder:(context,VideoPlayerValue value, child) {
                return Text(_videoDuration(value.position), style:TextStyle(color:Colors.white,fontSize:13,inherit:false),);},),
            //
            Expanded(child:SizedBox(height:4,child:VideoProgressIndicator(_controller,allowScrubbing:true,colors:VideoProgressColors(playedColor:Colors.white,backgroundColor:Color.fromARGB(255, 33, 33, 33),bufferedColor:Colors.grey),padding:EdgeInsets.symmetric(vertical:0,horizontal:12),) ,)),
            //
             Text(_videoDuration(_controller.value.duration),style:TextStyle(color:Colors.white,fontSize:13,inherit: false),),
            //
            GestureDetector(
              onTap:(){setState(() {
              fullscreen?fullscreen=false:fullscreen=true;_landscapeMode();
            });}
             ,child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(fullscreen?Icons.fullscreen_exit_rounded:Icons.fullscreen_rounded,color:Colors.white,size:30,),)),
            GestureDetector(
              onTap:(){setState(() {
              setState(() {
                wvideo==21?wvideo=16:wvideo=21;
              });
            });}
             ,child: Padding(padding: const EdgeInsets.only(right:10,left:10),child: Icon(wvideo!=21?Icons.screenshot_monitor:Icons.screenshot,color:Colors.white,size:30,),)),
          ],),),
        ],)
        ],),
      ),
      ],),
    );
  }}