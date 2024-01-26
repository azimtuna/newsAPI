import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Widgets.dart';
import 'flutterService.dart';
import 'model.dart';


class myApi extends StatefulWidget{
  @override
  State<myApi> createState() => _myApiState();
}

class _myApiState extends State<myApi> {
  bool success=false;
  List result=[];

  Future<void> fetchData() async{
    try {
      final response = await http.get(Uri.parse(
          'https://api.collectapi.com/news/getNews?country=tr&tag=general'),
          headers: {
            HttpHeaders
                .authorizationHeader: 'apikey 3e4WBd0eSGM6my8OPIenCN:0XS0XnalDORhh5Enpmexrh',
          });
      if (response.statusCode == 200) {
          success = jsonDecode(response.body)['success'];
          result=jsonDecode(response.body)['result'];

      } else {
        throw Exception("failed to load data");
      }
    }catch(e){
      setState(() {
        success=false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    String userId=ModalRoute.of(context)!.settings.arguments as String;
    return Column(
      children: [
        FutureBuilder(
            future: fetchData(),
            builder: (context,snapshot){
              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: result.length,
                  itemBuilder: (context,index){
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(image: NetworkImage(result[index]["image"],scale:2.5),width: 100,height: 100,),
                                Container(width: 10,),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(result[index]["name"]),
                                     Container(height: 5,),
                                     Text(result[index]["source"],style: TextStyle(fontSize: 10,color: Colors.grey[500]),),

                                   ],
                                )),
                                ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                onPressed: (){
                                        News? news=News(key: result[index]["key"], name: result[index]["name"], url: result[index]["url"], image: result[index]["image"], description: result[index]["description"]);
                                        showModalBottomSheet(context: context,
                                            builder: (BuildContext context){
                                              return FutureBuilder(
                                                future: firebaseService().getUserFromFirestore(userId),
                                                builder: (context,snapshot){
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Loading();}
                                                  else{
                                                    User user = snapshot.data!;
                                                    return GridView.builder(
                                                      itemCount: user.contexts.length,
                                                      padding: const EdgeInsets.all(5),
                                                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                                      itemBuilder: (BuildContext context,int index2){
                                                        return GestureDetector(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            color: Colors.deepOrangeAccent[100 * ((index2 + 1) % 8)],
                                                            child: Text(user.contexts[index2].contextName),

                                                          ),
                                                          onTap: (){
                                                          firebaseService().addNewsToContext(userId, user.contexts[index2].contextId, news);
                                                          Fluttertoast.showToast(msg: "ADDED", toastLength: Toast.LENGTH_LONG);
                                                          Navigator.of(context).pop();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              );


                                        }


                                        );


                                },
                                icon: Icon(Icons.favorite),
                            ),
                          ),
                          TextButton(
                            child: Text("Detaylar için tıklayın"),
                            onPressed:(){
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context){
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: ()=>Navigator.pop(context),
                                          icon: Icon(Icons.arrow_back_ios),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: NetworkImage(result[index]["image"],scale:2.5),width: 100,height: 100,),
                                        ),

                                      ),
                                      Center(child: Text(result[index]["name"],style: TextStyle(fontWeight: FontWeight.bold),)),
                                      SizedBox(height: 10,),
                                      Text(result[index]['description']),
                                      ElevatedButton(
                                          child: Text("click to see the new on website"),
                                          onPressed: () async {
                                            Uri uri=Uri.parse(result[index]['url']);
                                            if(await canLaunchUrl(uri)){
                                              await launchUrl(uri,webViewConfiguration: WebViewConfiguration(enableJavaScript: true));
                                            }else{
                                                Text("ERROR");
                                            }
                                          },
                                      )
                                    ],
                                  );
                                },);
                            },
                          ),

                        ],
                      ),

                      );
                  },
                ),
              );
            })
      ],
    );
  }
}

List<News> listOfNews=[];



