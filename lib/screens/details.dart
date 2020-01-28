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
  List<WebViewController> _listController = List();

  List<double> _heights =
      List<double>.generate(htmlStrings.length, (int index) => 20.0);

  DetailScreenState(this.product, this.image, this.index); //constructor

  @override
  Widget build(BuildContext context) {
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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            text:'par ' + product.artistName ?? 'default value'),
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
                  Text('\$' + product.trackPrice.toString() ?? 'default value'),
                ]),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                height: _heights[index] ?? 100.0,
                child: WebView(
                  initialUrl: product.previewUrl,
                  onPageFinished: (some) async {
                    double height = double.parse(await _listController[index]
                        .evaluateJavascript(
                            "document.documentElement.scrollHeight;"));
                    setState(() {
                      _heights[index] =
                          product.kind == 'song' ? height + 300 : height + 149;
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) async {
                    _listController.add(controller);
                  },
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              product.longDescription == null ? '': 'Description',
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
    );
  }
}

final List<String> htmlStrings = [
  '''<p>Table shows some compounds and the name of their manufacturing process</p>
<table style="border-collapse: collapse; width: 100%; height: 85px;" border="1">
<tbody>
<tr style="height: 17px;">
<td style="width: 50%; text-align: center; height: 17px;">Compounds/Elements</td>
<td style="width: 50%; text-align: center; height: 17px;">Manufacture process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 50%; height: 17px;">Nitric acid</td>
<td style="width: 50%; height: 17px;">Ostwald's process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 50%; height: 17px;">Ammonia</td>
<td style="width: 50%; height: 17px;">Haber's process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 50%; height: 17px;">Sulphuric acid</td>
<td style="width: 50%; height: 17px;">Contact process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 50%; height: 17px;">Sodium</td>
<td style="width: 50%; height: 17px;">Down's process</td>
</tr>
</tbody>
</table>''',
  '''<p>\(L=[M{L }^{2 }{T }^{-2 }{A }^{-2 }]\)</p>
<p>\(C=[{M }^{-1 }{L }^{-2 }{T }^{4 }{A }^{2 }]\)</p>
<p>\(R=[M{L }^{2 }{T }^{-3 }{A }^{-2 }]\)</p>
<p>\(\therefore \frac {R}{L}=\frac{[M{L }^{2 }{T }^{-2 }{A }^{-2 }]}{[M{L }^{2 }{T }^{-3 }{A }^{-2 }]}=[T]\)</p>''',
  '''<p>Displacement(s)\(=\left(13.8\pm0.2\right)m\)</p>
<p>Time(t)\(=\left(4.0\pm0.3\right)s\)</p>
<p>Velocity(v)\(=\frac{13.8}{4.0}=3.45m{s}^{-1}\)</p>
<p>\(\frac{\delta v}{v}=\pm\left(\frac{\delta s}{s}+\frac{\delta t}{t}\right)=\pm\left(\frac{0.2}{13.8}+\frac{0.3}{4.0}\right)=\pm0.0895\)</p>
<p>\(\delta v =\pm0.0895*3.45=\pm0.3\)(rounding off to one place of decimal)</p>
<p>\(v=\left(3.45\pm0.3\right)m{s}^{-1}\)</p>''',
  '''<p>The only real numbers satisfying \(x^2=4\) are 2 and -2. But none of them satisfy the final condition, \(x+2=3\). So, there is no real number such that these conditions are met. Hence this is null set.</p>
<p>Note that, for \(x\) to be a memner of \(\{x:p(x),q(x)\}\),&nbsp;<em><strong>both</strong></em> \(p(x)\) and \(q(x)\) should be true.</p>''',
];
