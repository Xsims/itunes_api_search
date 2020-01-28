import 'package:flutter/material.dart';
import 'package:itunes_api_search/models/product.dart';

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Product.
  final Product product;
  final Image image;
  final int index;

  // In the constructor, require a Product.
  DetailScreen({Key key, @required this.product, this.image, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Hero(
                    child: Text(product.trackName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    tag: 'name_hero$index',
                  ),
                  background: Hero(
                    tag: 'image_hero$index',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image.image,
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
            ),
          ];
        },
        body: Center(
          child: Text("Sample Text"),
        ),
      ),
    );
  }
}
