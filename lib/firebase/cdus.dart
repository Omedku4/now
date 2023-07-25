import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Cdus{

final CollectionReference user=FirebaseFirestore.instance.collection("users");

Future<void> newUser(String fullname,String email,String password,String phone,String bday,String bio,String cv,int money,String uid)async{
return await user.doc(uid).set({
"FullName":fullname,
"Email":email,
"Password":password,
"Phone":phone,
"BirthDay":bday,
"Bio":bio,
"cv":cv,
"Money":FieldValue.increment(money),
"uID":uid
});
}
//end user


// Future<void> buyCourse(String category,String cc,String create,String description,String h,String idcourse,String img,String language,String lesson,String m,String price,String students,String title,String update,String userid,String video,String uid)async{
// return await user.doc(uid).collection("mycourse").doc(idcourse).set({
//   "category":category,
//   "cc":cc,
//   "create":create,
//   "description":description,
//   "h":h,
//   "idcourse":idcourse,
//   "img":img,
//   "language":language,
//   "lesson":lesson,
//   "m":m,
//   "price":price,
//   "students":students,
//   "title":title,
//   "update":update,
//   "userid":userid,
//   "video":video,
//   "uID":uid
// });
// }

// //end set course buy
 


getuserinfo(String where)async{
  var infouser = FirebaseFirestore.instance.collection('users').where('Email',isEqualTo:where);
  var querySnapshot = await infouser.get();
  for(var queryDocSnapshot in querySnapshot.docs){
  Map<String,dynamic>data=queryDocSnapshot.data();
  sharedPref.setString("uid",data['uID']);
  sharedPref.setString("fullname",data['FullName']);
  }
  }
}


