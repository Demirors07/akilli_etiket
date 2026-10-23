class IngredientSearchTermModel {
  final int? id;
  final int ingredientId;   // Hangi bileşene ait olduğu (Foreign Key)
  final String searchTerm;  // Örn: 'jelatin', 'gelatine', 'e441'

  IngredientSearchTermModel({
    this.id,
    required this.ingredientId,
    required this.searchTerm,
  });

  factory IngredientSearchTermModel.fromMap(Map<String, dynamic> map) {
    return IngredientSearchTermModel(
      id: map['id'] as int?,
      ingredientId: map['ingredient_id'] as int,
      searchTerm: map['search_term'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredient_id': ingredientId,
      'search_term': searchTerm,
    };
  }
}