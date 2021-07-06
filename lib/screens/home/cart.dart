import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/cartitem.dart';
import 'package:flutter_app2/models/lessons.dart';
import 'package:flutter_app2/models/userr.dart';
import 'package:flutter_app2/providers/cartitemprovider.dart';
import 'package:flutter_app2/providers/productprovider.dart';
import 'package:flutter_app2/screens/home/appbar.dart';
import 'package:flutter_app2/services/database.dart';
import 'package:provider/provider.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DataBaseService _db = DataBaseService();
  CartItemProvider cartItemprovider =null;
  double total=0;
  @override
  Widget build(BuildContext context) {
    cartItemprovider = Provider.of<CartItemProvider>(context);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              createHeader(context),
              createCartList(context),
              footer(context)
            ],
          );
        },
      ),
    );
  }

  footer(BuildContext context) {
    final items = Provider.of<List<CartItem>>(context);
    final products = Provider.of<List<Product>>(context);
    final user = Provider.of<Userr>(context);
    total = 0;
    for(int i=0;i<items.length;i++){
      for(int k=0;k<products.length;k++){
        if(products.elementAt(k).productId == items.elementAt(i).productId)
          {
            total = total +products.elementAt(k).price * items.elementAt(i).quantity;
          }
      }
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  total.toString() + " PLN",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(32),
            child: RaisedButton(
              onPressed: () {
                for (int i=0;i<items.length;i++){
                  if(items.elementAt(i).uid==user.uid)
                  {
                    FirebaseFirestore.instance.collection('cartItem').doc(items.elementAt(i).cartItemId).delete();
                  }
                }
                print('go checkout page??');
              },
              color: Color(0xFFECB6B6),
              padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Text(
                "KUP TERAZ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDFDFD),
                ),
              ),
            ),
          ),//Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            "KOSZYK",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          createSubTitle(context),
      ]
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle(BuildContext context) {
    final items = Provider.of<List<CartItem>>(context);
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total " +  items.length.toString() + " lessons", // attach length of cart table
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  

  createCartList(BuildContext context) {
    final items = Provider.of<List<CartItem>>(context);
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount:items.length ?? 0,
      itemBuilder: (context, index) {
        return createCartListItem(items[index]);
      },

    );
  }

  dropItemFromCart(String id){
      cartItemprovider.removeCartItem(id);
  }

 createCartListItem(CartItem cartitem) {
     String text = cartitem.productId;
     return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product').where("productId",isEqualTo: cartitem.productId).snapshots(),
        builder: (context, snapshot){
        if (!snapshot.hasData) return const Center(
         child: const CupertinoActivityIndicator(),
        );
        return Stack(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return Stack(
              children: <Widget>[
                Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Row(
                  children: <Widget>[

              // Container(
              //   margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
              //   width: 50,
              //   height: 50,
              //   child: CircleAvatar(
              //           child: Icon(
              //             Icons.menu_book,
              //             color: Colors.white,
              //             size: 35,
              //           ),
              //           radius: 25,
              //           backgroundColor: Colors.pink[100],
              //         ),
              // ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          
                          document.data()['category'],
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //Utils.getSizedBox(height: 6),
                      // Text(
                      //   "$text",
                      //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        "Data: " + "13.06.2021",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        "Godzin: " + cartitem.quantity.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                             (document.data()['price']*cartitem.quantity).toString() + " PLN", //price per hour * count of hour
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 24,
                                      color:Color(0xFFECB6B6),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if(cartitem.quantity>0)
                                          cartItemprovider.addquantity(cartitem.cartItemId, cartitem.quantity-1);
                                      });
                                    },
                                  ),

                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12, right: 12, left: 12),
                                    alignment: Alignment.center,
                                    child: Text(
                                      cartitem.quantity.toString(),
                                      style:
                                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        size: 24,
                                        color: Color(0xFFECB6B6)),
                                    onPressed: () {
                                      setState(() {
                                        cartItemprovider.addquantity(cartitem.cartItemId, cartitem.quantity+1);
                                      });
                                    },
                                  ),

                                ],
                              ),
                            )
                          ],
                )
            ),
            ],
            ),
            ),
            flex: 100,
            ),
            ],
            ),
            ),
            Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: IconButton(
              padding: EdgeInsets.only(right: 5, top: 0),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
              alignment: Alignment.center,
              onPressed: () {
                setState(() {
                  dropItemFromCart(cartitem.cartItemId);
                });
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Color(0xFFECB6B6),
            ),
        )
    )
              ],
            );
          }).toList(),
         );  
      }
     );
  }
}