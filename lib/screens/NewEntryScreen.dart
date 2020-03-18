import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import './../models/entry.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'dart:math';

class PostForm extends StatefulWidget{
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final formKey = GlobalKey<FormState>();
  Entry wastePost = Entry(null, null, null, null, null);
  File image;
  LocationData locationData;

  @override 
  void initState(){
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async{
    var locationService = Location();
    locationData = await locationService.getLocation();
    print(locationData);
    wastePost.latitude = locationData.latitude.toString();
    wastePost.longitude = locationData.longitude.toString();
    setState((){});
  }

  void getImage() async{
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState( (){});
  }

   void runSave() async{
     if(formKey.currentState.validate()){
       formKey.currentState.save();
       wastePost.now = new DateFormat.yMMMd().format(new DateTime.now());
       StorageReference storageReference = FirebaseStorage.instance.ref().child(randomString(9));
       StorageUploadTask uploadTask = storageReference.putFile(image);
       await uploadTask.onComplete;
       final url = await storageReference.getDownloadURL();
       Firestore.instance.collection('posts').add({
         'number_items': wastePost.number_submissions,
         'Date' : wastePost.now,
         'latitude': wastePost.latitude,
         'longitude': wastePost.longitude,
         'url': url
       });
       Navigator.of(context).pop();
     }
   }

   @override
   Widget build(BuildContext context) {
     if (image == null){
       return Center(
         child: RaisedButton(
           child: Text("Select Photo"),
           onPressed: (){
             getImage();
           }
          )
        );
     } else {
       return SingleChildScrollView(
         child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.file(image),
                height: 350 ,
                width:500),
                SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter valid input";
                      }
                    },
                    onSaved: (value){
                      wastePost.number_submissions = int.parse(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                Semantics(
                  child: RaisedButton(
                    child: Text('Upload it!'),
                    onPressed: (){
                      runSave();
                    },
                  ),
                  label: "Post for the day"
                )
            ],
            ) ,
          ),
       );
     }
   }
}

class NewEntryScreen extends StatelessWidget{
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wasteagram"),
        centerTitle: true
      ),
      body: PostForm()
    );
  }
}

//source citation: https://siongui.github.io/2017/01/22/dartlang-generate-random-string/
String randomString(int strlen) {
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}