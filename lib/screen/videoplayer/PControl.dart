import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PControl extends StatefulWidget {
  PControl({super.key,required this.fullscreen,required this.url});
  bool fullscreen=false;
  String url;
  @override
  State<PControl> createState() => _PControlState();
}

class _PControlState extends State<PControl> {

  //bool fullscreen=false;
  bool screentime=true;
  
  Future _setAllOrientatio()async{
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
  late VideoPlayerController _controller;
  void _PlayeVideo({bool init=false}){

  if(!init){_controller.pause();}
  _controller = VideoPlayerController.network(widget.url)..addListener(() => setState(() {}))
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

  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _PlayeVideo(init:true);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    // overlays:[]);
  }

  @override
  void dispose() {
    _setAllOrientatio();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}