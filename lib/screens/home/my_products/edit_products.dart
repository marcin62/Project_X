

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/lessons.dart';
import 'package:flutter_app2/models/userr.dart';
import 'package:flutter_app2/providers/productprovider.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  EditProduct([this.product]);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  String category = "Matematyka";

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.product == null) {
      //New Record
      nameController.text = "";
      priceController.text = "";
      categoryController.text = "";
      descriptionController.text = "";
      new Future.delayed(Duration.zero, () {
        final productProvider = Provider.of<ProductProvider>(context,listen: false);
        productProvider.loadValues(Product());
      });
    } else {
      //Controller Update
      nameController.text=widget.product.name;
      priceController.text=widget.product.price.toString();
      categoryController.text=widget.product.category;
      descriptionController.text=widget.product.descryption;
      //State Update
      new Future.delayed(Duration.zero, () {
        final productProvider = Provider.of<ProductProvider>(context,listen: false);
        productProvider.loadValues(widget.product);
      });
      
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final user = Provider.of<Userr>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Product'),backgroundColor: Color(0xFFECB6B6) ,),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(

          children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8),
            child:TextField(
                controller: nameController,
                decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Product Name',
                ),
                onChanged: (value) {
                  productProvider.changeName(value);
                },
              ),
            ),
            _dropDownCategory(),
            // TextField(
            //   controller: categoryController,
            //   decoration: InputDecoration(hintText: 'Product Category'),
            //   onChanged: (value) {
            //     productProvider.changeCategory(value);
            //   },
            // ),
            Card(
              margin: const EdgeInsets.all(8),
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 6,
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Product Description'),
                  onChanged: (value) {
                    productProvider.changeDescription(value);
                  },
                ),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child:TextField(
                controller: priceController,
                decoration: InputDecoration(
                    hintText: 'Product Price',

                ),
                onChanged: (value) => productProvider.changePrice(value),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              padding: const EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Color(0xFFECB6B6),
              child: Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFFFDFDFD),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
              ),
              onPressed: () {
                productProvider.changeuid(user.uid);
                productProvider.changeCategory(category);
                if(descriptionController.value != null && nameController.value!=null && priceController.value!=null)
                  productProvider.saveProduct();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            (widget.product !=null) ? RaisedButton(
              padding: const EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Color(0xFF939292),
              textColor: Colors.white,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFFDFDFD),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              onPressed: () {
                productProvider.removeProduct(widget.product.productId);
                Navigator.of(context).pop();
              },
            ): Container(),
          ],
        ),
      ),
    );
  }



    Widget _dropDownCategory(){
    return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('category').snapshots(),
    builder: (context, snapshot){
      if (!snapshot.hasData) return const Center(
        child: const CupertinoActivityIndicator(),
      );
      return Card(
          margin: const EdgeInsets.all(8),
        child: new Row(
          children: <Widget>[
            new Expanded(
                flex: 2,
                child: new Container(
                  padding: EdgeInsets.fromLTRB(17.0,10.0,10.0,10.0),
                  child: new Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                  ),
                )
            ),
            new Expanded(
              flex: 3,
              child:new InputDecorator(
                decoration: const InputDecoration(
                  hintText: 'Choose an category',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                isEmpty: category == null,
                child: new DropdownButton(
                  value: category,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  items: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new DropdownMenuItem<String>(
                        value: document.data()['category_name'],
                        child: new Container(
                          height: 30.0,
                          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                          child: new Text(document.data()['category_name']),
                        )
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}
}