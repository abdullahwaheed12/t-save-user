import 'dart:convert';

class ProductDetailModel {
  String title;
  String condition;
  String brand;
  String price;
  String category;
  String description;
  String imageUrl;

  ProductDetailModel({
    required this.title,
    required this.condition,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  ProductDetailModel copyWith({
    String? title,
    String? condition,
    String? brand,
    String? price,
    String? category,
    String? description,
    String? imageUrl,
  }) {
    return ProductDetailModel(
      title: title ?? this.title,
      condition: condition ?? this.condition,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'condition': condition});
    result.addAll({'brand': brand});
    result.addAll({'price': price});
    result.addAll({'category': category});
    result.addAll({'description': description});
    result.addAll({'imageUrl': imageUrl});

    return result;
  }

  factory ProductDetailModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailModel(
      title: map['title'] ?? '',
      condition: map['condition'] ?? '',
      brand: map['brand'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetailModel.fromJson(String source) =>
      ProductDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductDetailModel(title: $title, condition: $condition, brand: $brand, price: $price, category: $category, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDetailModel &&
        other.title == title &&
        other.condition == condition &&
        other.brand == brand &&
        other.price == price &&
        other.category == category &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        condition.hashCode ^
        brand.hashCode ^
        price.hashCode ^
        category.hashCode ^
        description.hashCode ^
        imageUrl.hashCode;
  }
}
