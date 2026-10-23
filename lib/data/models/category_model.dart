class CategoryModel {
  final int? id;
  final String code;         // Örn: 'gluten', 'vegan', 'lactose' (Sistem anahtarı)
  final String categoryName; // Örn: 'Gluten', 'Vegan' (Görünen isim)
  final String type;         // 'ALLERGEN' veya 'DIET'
  final String? description;

  CategoryModel({
    this.id,
    required this.code,
    required this.categoryName,
    required this.type,
    this.description,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      code: map['code'] as String,
      categoryName: map['category_name'] as String,
      type: map['type'] as String,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // veya id
      'code': code,
      'category_name': categoryName,
      'type': type,
      'description': description,
    };
  }
}