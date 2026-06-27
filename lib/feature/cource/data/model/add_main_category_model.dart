class AddMainCategoryModel {
  final String id;
  final String name;
  final String image;
    final List<String> keywords;


  AddMainCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.keywords,
  });

  factory AddMainCategoryModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AddMainCategoryModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      keywords: List<String>.from(map["keywords"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      'name': name,
      'image': image,
      'keywords': keywords,
    };
  }
}
