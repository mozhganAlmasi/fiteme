class CategoryModel {
  int id;
  String? categoryName;
  int coachCode;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.coachCode,
  });

  // برای ساخت از JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['name']?? '',
      coachCode: json['coachcode'],
    );
  }

  // برای تبدیل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': categoryName,
      'coachcode': coachCode,
    };
  }
}
