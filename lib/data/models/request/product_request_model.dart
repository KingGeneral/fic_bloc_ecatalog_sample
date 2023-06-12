import 'dart:convert';

// create product
// {{
//   "title": "New Product",
//   "price": 100,
//   "description": "A description",
//   "categoryId": 1,
//   "images": [
//     "https://placeimg.com/640/480/any"
//   ]
// }

class ProductRequestModel {
  final String title;
  final int price;
  final String description;
  final int categoryId;
  final List<String> images;
  ProductRequestModel({
    required this.title,
    required this.price,
    required this.description,
    this.categoryId = 1,
    this.images = const ['https://placeimg.com/640/480/any'],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': images,
    };
  }

  factory ProductRequestModel.fromMap(Map<String, dynamic> map) {
    return ProductRequestModel(
      title: map['title'] ?? '',
      price: map['price']?.toInt() ?? 0,
      description: map['description'] ?? '',
      categoryId: map['categoryId']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductRequestModel.fromJson(String source) =>
      ProductRequestModel.fromMap(json.decode(source));
}
