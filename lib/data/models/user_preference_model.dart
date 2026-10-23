class UserPreferenceModel {
  final int? id;
  final int categoryId; // CATEGORIES tablosuna Foreign Key
  final bool isEnabled; // true: Aktif, false: Pasif

  UserPreferenceModel({
    this.id,
    required this.categoryId,
    required this.isEnabled,
  });

  factory UserPreferenceModel.fromMap(Map<String, dynamic> map) {
    return UserPreferenceModel(
      id: map['id'] as int?,
      categoryId: map['category_id'] as int,
      isEnabled: (map['is_enabled'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'is_enabled': isEnabled ? 1 : 0,
    };
  }
}