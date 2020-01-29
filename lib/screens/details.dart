import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itunes_api_search/models/product.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final Image image;
  final int index;

  DetailScreen({Key key, @required this.product, this.image, this.index})
      : super(key: key);

  @override
  DetailScreenState createState() => DetailScreenState(product, image, index);
}

class DetailScreenState extends State<DetailScreen> {
  // Declare a field that holds the Product.
  Product product;
  Image image;
  int index;
  bool alreadySaved = false;

  DetailScreenState(this.product, this.image, this.index); //constructor

  @override
  Widget build(BuildContext context) {
    double _height = product.kind == 'song' ? 300 : 170;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        alreadySaved
                            ? alreadySaved = false
                            : alreadySaved = true;
                      });
                    }),
              ],
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Hero(
                    child: Text(
                        product.trackName.length < 25
                            ? product.trackName
                            : product.trackName.substring(0, 24) + '...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            decoration: TextDecoration.none)),
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
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Container(
                            margin: const EdgeInsets.all(60.0),
                            child: Image(
                              image: image.image,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ];
        },
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.fade,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 24.0,
                                decoration: TextDecoration.none),
                            text: product.trackName ?? 'default value'),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.fade,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            text:
                                'par ' + product.artistName ?? 'default value'),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.primaryGenreName ?? 'default value',
                        style: TextStyle(color: Colors.black38)),
                    Text('\$' + product.trackPrice.toString() ??
                        'default value'),
                  ]),
            ),
            Container(
              height: _height ?? 170.0,
              child: WebView(
                initialUrl: product.previewUrl,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                product.longDescription == null ? '' : 'Description',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(product.longDescription ?? ''),
            ),
          ]),
        ),
      ),
    );
  }
}
