import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itunes_api_search/models/api_result.dart';

Future<ApiResult> fetchApiResult(http.Client client) async {
  final response =
  await client.get('https://itunes.apple.com/search?term=jack+johnson');
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return ApiResult.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Itunes Api Search';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<ApiResult>(
        future: fetchApiResult(http.Client()),
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

  ProductsList({Key key, this.apiResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: apiResult.resultCount,
      itemBuilder: (context, index) {
        // Download and display image with the thumbnail's url
        return Image.network(apiResult.products[index].artworkUrl100);
      },
    );
  }
}