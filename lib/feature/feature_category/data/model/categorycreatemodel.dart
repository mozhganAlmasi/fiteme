class CategoryCreateModel {
  String categoryName;
  int coachCode;

  CategoryCreateModel({
    required this.categoryName,
    required this.coachCode,
  });

  // برای ساخت از JSON (در صورت نیاز)
  factory CategoryCreateModel.fromJson(Map<String, dynamic> json) {
    return CategoryCreateModel(
      categoryName: json['name'] ?? '',
      coachCode: json['coachcode'],
    );
  }

  // برای تبدیل به JSON جهت ارسال به سرور
  Map<String, dynamic> toJson() {
    return {
      'name': categoryName,
      'coachcode': coachCode,
    };
  }
}
