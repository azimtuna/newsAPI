import 'package:deneme/Widgets.dart';
import 'package:deneme/flutterService.dart';
import 'package:flutter/material.dart';
import 'package:deneme/apiRequests.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';

class HomePage extends StatefulWidget{


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final String userId=ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar:AppBar(
          title: Text("NEWS ON TURKEY"),
          actions: [
            Badge(
              alignment: AlignmentDirectional.bottomStart,
              child:IconButton(
                icon:Icon(Icons.add_box),
                onPressed:(){
                  Navigator.of(context).pushNamed("/tool",arguments: userId);
                },
              ),
            ),
          ],
        ) ,
        body:myApi(),
    );
  }
}
class Tool extends StatefulWidget{
  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {

  @override
  Widget build(BuildContext context) {
    final String userId=ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("context"),
        actions: [
          Badge(
            alignment: AlignmentDirectional.bottomStart,
            child:IconButton(
              icon:Icon(Icons.add_box),
              onPressed:(){
                Navigator.of(context).pushNamed("/toolRegister",arguments: userId);
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: firebaseService().getUserFromFirestore(userId),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();}
          else{
            User user = snapshot.data!;
            return GridView.builder(
              itemCount: user.contexts.length,
              padding: const EdgeInsets.all(5),
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 1.5),
              itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                     color: Colors.deepOrangeAccent[100 * ((index + 1) % 8)],
                      child: Text(user.contexts[index].contextName),
                  ),
                  onTap:(){
                    List<News> list=List.of(user.contexts[index].news);
                    Navigator.of(context).pushNamed('/listView',arguments: list);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ContextElements extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<News> liste=ModalRoute.of(context)!.settings.arguments as List<News>;
    return Scaffold(
      appBar: AppBar(title: Text("context")),
      body: ListView.builder(
      itemCount: liste.length,
      padding: EdgeInsets.all(5),
      itemBuilder: (BuildContext context,int index){
        return ListTile(
          title:Text(liste[index].name),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: (){
              showModalBottomSheet(context: context, builder: (BuildContext context){
                return Center(
                  child: ElevatedButton(
                    child: Text("click to see the new on website"),
                    onPressed: () async {
                      Uri uri=Uri.parse(liste[index].url);
                      if(await canLaunchUrl(uri)){
                        await launchUrl(uri,webViewConfiguration: WebViewConfiguration(enableJavaScript: true));
                      }else{
                        Text("ERROR");
                      }
                    },
                  ),
                );
              });
            },
          ),
        );
      },
    ),);
  }

}


class ToolRegister extends StatefulWidget{
  @override
  State<ToolRegister> createState() => _ToolRegisterState();
}

class _ToolRegisterState extends State<ToolRegister> {
  @override
  Widget build(BuildContext context) {
    final String userId=ModalRoute.of(context)!.settings.arguments as String;
    final contextName=TextEditingController();
    return  Scaffold(
     appBar: AppBar(title:Text("add context")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: contextName,
            decoration: InputDecoration(
              labelText: "Context Name",
              labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.purple.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red.shade900)),
            ),
          ),
          ElevatedButton(
              onPressed: (){
                Context context1=Context(contextId: " ", contextName: contextName.text, news: []);
                firebaseService().addContextToUser(userId, context1);
                Navigator.of(context).pop();
              },
              child: Text("Add the Context"),
          ),
        ],
      ),
   );
  }
}


