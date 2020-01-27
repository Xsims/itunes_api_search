import 'package:flutter/material.dart';
import 'package:itunes_api_search/models/product.dart';

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Product.
  final Product product;

  // In the constructor, require a Product.
  DetailScreen({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Product to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(product.trackName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(product.collectionName),
      ),
    );
  }
}