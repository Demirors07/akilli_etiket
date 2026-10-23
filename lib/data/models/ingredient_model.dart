class IngredientModel {
  final int? id;
  final String? code;          // Örn: 'E441'
  final String canonicalName;  // Örn: 'Gelatin'
  final String? description;   // Kısa açıklama

  IngredientModel({
    this.id,
    this.code,
    required this.canonicalName,
    this.description,
  });

  // DB ---> Model
  // DB'den "key-value" olarak gelen verileri modele aktarır.
  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      id: map['id'] as int?,
      code: map['code'] as String?,
      canonicalName: map['canonical_name'] as String,
      description: map['description'] as String?,
    );
  }

  // Model ---> DB
  // Modeli Map kalıbına alır. Öyle aktarır.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'canonical_name': canonicalName,
      'description': description,
    };
  }
}

