import 'package:flutter/material.dart';

class cv extends StatefulWidget {
  cv({super.key,});
  //String username;
  @override
  State<cv> createState() => _cvState();
}

class _cvState extends State<cv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(children: [

        Container(child:Row(
          children: [
          SizedBox(height:100,width:100,child: ClipRRect(borderRadius:BorderRadius.circular(10),child:Image.asset('assets/img/krd.png',fit:BoxFit.cover,),)),
          Column(children: [
            Text('Omed Hussin',style:TextStyle(fontFamily:'kurdi',),)
          ],)
        ]),),

      ],),
    );
  }
}


// RewardedAd? _rewardedAd;
//   bool _isrewardReady=false;
//   void _createRewardedAd(){
//     RewardedAd.load(
//       adUnitId:AdMobService.rewardedAdUnitId!,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad){setState(()=>_rewardedAd=ad);
//         ad.fullScreenContentCallback=FullScreenContentCallback(
//           onAdDismissedFullScreenContent: (ad){
//           setState(()=> _isrewardReady=false);
//           _createRewardedAd();
//         });
//         setState(()=>_isrewardReady=true);
//         },
//         onAdFailedToLoad: (error){print('errrrrorrrrrr');})
//     );
//   }

//   void _showRewardedAd(){
//     _rewardedAd!.show(onUserEarnedReward:(ad, reward){setState((){print('ok===========');});});

//   }
