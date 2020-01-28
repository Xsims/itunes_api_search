import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itunes_api_search/models/api_result.dart';
import 'details.dart';

Future<ApiResult> fetchApiResult(http.Client client, String keyword) async {
  final keywordWithoutSpace = keyword.replaceAll(RegExp(' '), '+');
  final response = await client.get(
      'https://itunes.apple.com/search?country=FR&term=${keywordWithoutSpace
          .toLowerCase()}');
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return ApiResult.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  String searchKeyword = 'jack johnson';

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: TextEditingController.fromValue(
              new TextEditingValue(text: title)),
          style: TextStyle(fontSize: 15),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<ApiResult>(
        future: fetchApiResult(http.Client(), title),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          // Display circular progress while data hasn't been fetched
          return snapshot.hasData
              ? ProductsList(apiResult: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final ApiResult apiResult;
  Map<String, IconData> iconMapping = {
    'song': Icons.music_note,
    'feature-movie': Icons.local_movies,
    'default value': Icons.error
  };

  ProductsList({Key key, this.apiResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation)
    {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 4,
          ),
          itemCount: apiResult.resultCount,
          itemBuilder: (context, index) {
            return GridTile(
              // Download and display image with the thumbnail's url
                child: new InkResponse(
                  child: Hero(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        image: DecorationImage(
                          image: Image
                              .network(
                            apiResult.products[index].artworkUrl100,
                          )
                              .image,
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    tag: 'image_hero$index',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(
                              product: apiResult.products[index],
                              image: Image.network(
                                  apiResult.products[index].artworkUrl100),
                              index: index,
                            ),
                      ),
                    );
                  },
                ),
                footer: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Hero(
                    child: Text(
                      apiResult.products[index].trackName ?? 'default value',
                      style: TextStyle(color: Colors.white),
                    ),
                    tag: 'name_hero$index',
                  ),
                ),
                header: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '\$' +
                                apiResult.products[index].trackPrice
                                    .toString() ??
                                'default value',
                            style: TextStyle(color: Colors.white)),
                        Icon(
                            iconMapping[apiResult.products[index].kind ??
                                'default value'],
                            color: Colors.white)
                      ]),
                ));
          });
    });
  }
}
