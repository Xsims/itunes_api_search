import 'package:itunes_api_search/models/product.dart';

// A class that converts a response body into a ApiResult.
class ApiResult {
  int resultCount;
  List<Product> products;

  ApiResult({this.resultCount, this.products});

  ApiResult.fromJson(Map<String, dynamic> json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      products = new List<Product>();
      json['results'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCount'] = this.resultCount;
    if (this.products != null) {
      data['results'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
