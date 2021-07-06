

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/lessons.dart';
import 'package:flutter_app2/models/useerr.dart';
import 'package:flutter_app2/models/userr.dart';
import 'package:provider/provider.dart';

import 'appbar.dart';
import 'detailpage.dart';

class TutorDetailPage extends StatefulWidget {

  final UserData user;
  TutorDetailPage({this.user,});
  @override
  _TutorDetailPageState createState()=> _TutorDetailPageState();
}


class _TutorDetailPageState extends State<TutorDetailPage>{

  Widget tutorDataSection(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.account_circle, ////TODO add user profile photo
                  color: Colors.white,
                  size: 50,
                ),
                radius: 25,
                backgroundColor: Color(0xFFECB6B6),
              ),
              title: Text(widget.user.name), ////TODO connect to database
              subtitle: Text("Student and Teacher"), //moze tu poziom wiedzy nauczyciela np student lub nauczyciel////TODO
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow[700],
          ),
          Text('4.5'), ////TODO add tutor rate
        ],
      ),
    );
  }

  // Widget tutorProductList(BuildContext context){
  //   final products = Provider.of<List<Product>>(context);
  //
  //   return Container(
  //       child:(products != null)
  //           ? ListView.builder(
  //           itemCount: products.length,
  //           itemBuilder: (context, index) {
  //             return Card(
  //                 child: ListTile(
  //                   title: Text(products[index].name??"test"),
  //                   trailing: Text(products[index].price.toString() + " PLN"??"test2" ),
  //                   onTap: () {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                           builder: (context) => DetailPage(product: products[index],)));
  //                   },
  //                 )
  //             );
  //           })
  //           : Center(child: CircularProgressIndicator())
  //   );
  // }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(),
        widgets: <Widget>[Icon(Icons.more_vert)],
      ),
      body: Container(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children:<Widget> [
              tutorDataSection(context),

              //tutorProductList(context),
            ],
          ),
        ),

      ),
    );
  }
}