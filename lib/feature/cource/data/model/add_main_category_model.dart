class AddMainCategoryModel {
  final String id;
  final String name;
  final String image;

  AddMainCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory AddMainCategoryModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AddMainCategoryModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      'name': name,
      'image': image,
    };
  }
}
