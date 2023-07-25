// import 'package:flutter/material.dart';
// import 'package:pod_player/pod_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player_platform_interface/video_player_platform_interface.dart';



// class playervideo extends StatefulWidget {
//   playervideo({super.key});

  

//   @override
//   State<playervideo> createState() => _playervideoState();
// }

// class _playervideoState extends State<playervideo> {

//   late VideoPlayerController _videoPlayerController;
//   late ChewieController _chewieController;



//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//      _videoPlayerController= VideoPlayerController.network('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4');
   

//     _chewieController=ChewieController(
//       videoPlayerController: _videoPlayerController,
//       aspectRatio: 16/9,
//       );
//   }


//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _videoPlayerController.dispose();
//     _chewieController.dispose();
//     super.dispose();

//   }

//   //  final FlickManager flickManager= FlickManager(
//   //   videoPlayerController:VideoPlayerController.network('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
//   //   );

    
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:Column(
//         children:<Widget>[
//          Expanded(child: Center(
//           child:_chewieController!=null &&
//           _chewieController!=
//           _videoPlayerController.value.isInitialized?
//            Chewie(controller: _chewieController):
//            Center( child:CircularProgressIndicator())))
//         ],
//       )
//     );
//   }
// }
// //_activeManager!.flickControlManager!.enterFullscreen();
// //  AspectRatio(aspectRatio: 16/9,
// //               child: _chewieController!=null?Chewie(controller: _chewieController):Center(
// //                 child:CircularProgressIndicator() ,),),