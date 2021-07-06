

import 'package:flutter/material.dart';
import 'package:flutter_app2/models/lessons.dart';
import 'package:flutter_app2/models/userr.dart';
import 'package:provider/provider.dart';

import '../detailpage.dart';
import 'edit_products.dart';

class Products extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    final user = Provider.of<Userr>(context);
    bool edit = false;

    return Scaffold(
        appBar: AppBar(
          title: Text('Your products'),
          backgroundColor: Color(0xFFECB6B6),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 30.0,
              ),
              onPressed: () {
                if(edit!=true) edit = true;
                else edit = false;
                },
              ////TODO onPressed
            )
          ],
        ),
        body: Container(
            child:(products != null)
            ? ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(products[index].name??"test"),
                      trailing: Text(products[index].price.toString() + " PLN"??"test2" ),
                      onTap: () {
                        if(edit==true) {
                          edit = false;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProduct(products[index],)));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailPage(product: products[index],)));
                        }
                      },
                    )
                  );
                })
            : Center(child: CircularProgressIndicator())
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFECB6B6),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditProduct()));
        },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
    );

  }
}