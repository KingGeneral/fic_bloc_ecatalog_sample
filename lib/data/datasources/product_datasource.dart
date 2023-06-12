import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductDataSource {
  Future<Either<String, List<ProductResponseModel>>> getAllProduct() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/'));
    if (response.statusCode == 200) {
      return Right(List<ProductResponseModel>.from(jsonDecode(response.body)
          .map((x) => ProductResponseModel.fromMap(x))));
    } else {
      return const Left('get product error');
    }
  }

  Future<Either<String, ProductResponseModel>> createProduct(
      ProductRequestModel model) async {
    final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/products/'),
        body: model.toJson(),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('error add product');
    }
  }

  Future<Either<String, List<ProductResponseModel>>> getAllProductPagination(
      int page, int limit) async {
    final response = await http.get(
      // Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=10'),
      Uri.parse(
          'https://api.escuelajs.co/api/v1/products?offset=${page * limit}&limit=${limit}'),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return Right(List<ProductResponseModel>.from(jsonDecode(response.body)
          .map((x) => ProductResponseModel.fromMap(x))));
      // return Right(List<ProductResponseModel>.from(jsonDecode(response.body)));
    } else {
      return const Left('get product error');
    }
  }

  Future<Either<String, ProductResponseModel>> updateProduct(
      ProductRequestModel model, int id) async {
    // header
    var headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(model.toMap());
    print(body);
    final response = await http.put(
      Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
      // body: model.toJson(),
      body: body,
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('error update product');
    }
  }
}
