import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Widgets {
  Future<void> RegisterDialogBuilder(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (BuildContext contex){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please check your password"),
            actions: [
            TextButton(
                child: Text("Ok"),
                onPressed:() {
                  Navigator.pop(context);
                },
            ),

            ],
          );
        }
    );
  }
}
class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: CircularProgressIndicator(
          color: Colors.amber,
        ),
    );
  }

}