class CourseModel {
  final String id;
  final String name;
  final String image;
  final String categoryId;
  final String categoryName;
  final String tutor;
  final List<String> tags;
  final double price;
  final double offerPrice;
  final double tax;
  final double applePrice;
  final double appleOfferPrice;
  final String duration;
  final bool hasLiveClasses;
  final bool hasStudyMaterials;
  final bool availableOnPC;
  final bool isPopular;
  final bool listOnIOS;
  final bool isLifeLong;
  final List<String> keywords;

  CourseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    required this.tutor,
    required this.tags,
    required this.price,
    required this.offerPrice,
    required this.tax,
    required this.applePrice,
    required this.appleOfferPrice,
    required this.duration,
    required this.hasLiveClasses,
    required this.hasStudyMaterials,
    required this.availableOnPC,
    required this.isPopular,
    required this.listOnIOS,
    required this.isLifeLong,
    required this.keywords,
  });

CourseModel copyWith({
  String? id,
  String? name,
  String? image,
  String? categoryId,
  String? categoryName,
  String? tutor,
  List<String>? tags,
  double? price,
  double? offerPrice,
  double? tax,
  double? applePrice,
  double? appleOfferPrice,
  String? duration,
  bool? hasLiveClasses,
  bool? hasStudyMaterials,
  bool? availableOnPC,
  bool? isPopular,
  bool? listOnIOS,
  bool? isLifeLong,
  List<String>? keywords,
}) {
  return CourseModel(
    id: id ?? this.id,
    name: name ?? this.name,
    image: image ?? this.image,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    tutor: tutor ?? this.tutor,
    tags: tags ?? this.tags,
    price: price ?? this.price,
    offerPrice: offerPrice ?? this.offerPrice,
    tax: tax ?? this.tax,
    applePrice: applePrice ?? this.applePrice,
    appleOfferPrice: appleOfferPrice ?? this.appleOfferPrice,
    duration: duration ?? this.duration,
    hasLiveClasses: hasLiveClasses ?? this.hasLiveClasses,
    hasStudyMaterials:
        hasStudyMaterials ?? this.hasStudyMaterials,
    availableOnPC: availableOnPC ?? this.availableOnPC,
    isPopular: isPopular ?? this.isPopular,
    listOnIOS: listOnIOS ?? this.listOnIOS,
    isLifeLong: isLifeLong ?? this.isLifeLong,
    keywords: keywords ?? this.keywords,
  );
}
  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      tutor: map['tutor'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      price: (map['price'] ?? 0).toDouble(),
      offerPrice: (map['offerPrice'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      applePrice: (map['applePrice'] ?? 0).toDouble(),
      appleOfferPrice: (map['appleOfferPrice'] ?? 0).toDouble(),
      duration: map['duration'] ?? '',
      hasLiveClasses: map['hasLiveClasses'] ?? false,
      hasStudyMaterials: map['hasStudyMaterials'] ?? false,
      availableOnPC: map['availableOnPC'] ?? false,
      isPopular: map['isPopular'] ?? false,
      listOnIOS: map['listOnIOS'] ?? false,
      isLifeLong: map['isLifeLong'] ?? false,
      keywords: List<String>.from(map['keywords'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'tutor': tutor,
      'tags': tags,
      'price': price,
      'offerPrice': offerPrice,
      'tax': tax,
      'applePrice': applePrice,
      'appleOfferPrice': appleOfferPrice,
      'duration': duration,
      'hasLiveClasses': hasLiveClasses,
      'hasStudyMaterials': hasStudyMaterials,
      'availableOnPC': availableOnPC,
      'isPopular': isPopular,
      'listOnIOS': listOnIOS,
      'isLifeLong': isLifeLong,
      'keywords': keywords,
    };
  }
}
