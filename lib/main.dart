import 'package:flutter/material.dart';
import 'screens/search_results.dart';

void main() => runApp(MaterialApp(
      title: 'Itunes Api Search',
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String searchKeyword = "";

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {

                  }),
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    _controller.clear();
                  }),
            ),
            onSubmitted: (String keyword) {
              searchKeyword = keyword;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new MyHomePage(title: searchKeyword),
                ),
              );
            },
          ),
        ),
        body: Container());
  }
}
