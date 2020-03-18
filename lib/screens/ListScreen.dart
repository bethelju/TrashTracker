import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './DetailScreen.dart';
import 'package:path/path.dart' as Path;
import './NewEntryScreen.dart';

class ListScreen extends StatefulWidget{
    @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int postSum;
  void initState(){
    super.initState();
    postSum = 0;
    print("State");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wasteagram"),
            StreamBuilder(
              stream: Firestore.instance.collection('posts').snapshots(),
              builder: (content, snapshot) {
                if(snapshot.hasData){
                  int total = 0;
                  for(int i = 0; i < snapshot.data.documents.length; i++){
                    total += snapshot.data.documents[i]['number_items'];
                  }
                  return CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text("${total}"),
                  );
                }
                else{
                  return Text("");
                }
              }
            )
        ]),
      ),
      body: StreamBuilder(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (content, snapshot) {
        print(snapshot.data.documents);
        if(snapshot.hasData && snapshot.data.documents.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              var post = snapshot.data.documents[snapshot.data.documents.length - index - 1];
              print(post.runtimeType);

              return ListTile(
                trailing: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(post['number_items'].toString()),
                ),
                title: Text(post['Date']),
                onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(data: post)
                  )
                );}
              );
            },
          );
        }
        else{
          return Center(child: CircularProgressIndicator());
        }
      }),
      floatingActionButton: 
        Semantics(
          child: FloatingActionButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewEntryScreen()
                )
              );
            },
            child: Icon(Icons.add)
         ),
         label: "Add waste for a new day!",
         enabled: true
      )
    );
  }
}