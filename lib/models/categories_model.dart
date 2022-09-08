import 'dart:convert';

class CategoriesModel {
  String categoryName;
  String categoryImagePath;
  CategoriesModel({
    required this.categoryName,
    required this.categoryImagePath,
  });

  CategoriesModel copyWith({
    String? categoryName,
    String? categoryImagePath,
  }) {
    return CategoriesModel(
      categoryName: categoryName ?? this.categoryName,
      categoryImagePath: categoryImagePath ?? this.categoryImagePath,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'categoryName': categoryName});
    result.addAll({'categoryImagePath': categoryImagePath});

    return result;
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> map) {
    return CategoriesModel(
      categoryName: map['categoryName'] ?? '',
      categoryImagePath: map['categoryImagePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesModel.fromJson(String source) =>
      CategoriesModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoriesModel(categoryName: $categoryName, categoryImagePath: $categoryImagePath)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriesModel &&
        other.categoryName == categoryName &&
        other.categoryImagePath == categoryImagePath;
  }

  @override
  int get hashCode => categoryName.hashCode ^ categoryImagePath.hashCode;
}
