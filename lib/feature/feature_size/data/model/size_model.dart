import 'package:shahrzad/feature/feature_size/domain/entities/entities.dart';

class SizeModel extends SizeEntities {

  SizeModel({
    required id,
    required waist,
    required chest,
    required hips,
    required arm,
    required thigh,
    required shoulder,
    required belly,
    required dateInsert,
    required userId,
  }) : super(id: id, waist: waist, chest: chest, hips: hips, arm: arm, thigh: thigh, shoulder: shoulder, belly: belly, dateInsert: dateInsert, userId: userId);

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: (json['id'] as num).toInt(),
      waist: (json['waist'] as num).toDouble(),
      chest: (json['chest'] as num).toDouble(),
      hips: (json['hips'] as num).toDouble(),
      arm: (json['arm'] as num).toDouble(),
      thigh: (json['thigh'] as num).toDouble(),
      shoulder: (json['shoulder'] as num).toDouble(),
      belly: (json['belly'] as num).toDouble(),
      dateInsert: json['dateinsert'], // این قسمت اصلاح شد
      userId: json['userid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'waist': waist,
      'chest': chest,
      'hips': hips,
      'arm': arm,
      'thigh': thigh,
      'shoulder': shoulder,
      'belly': belly,
      'dateinsert': dateInsert, // این قسمت هم اصلاح شد
      'userid': userId,
    };
  }
}

extension SizeModelDisplay on SizeModel {
  Map<String, dynamic> toDisplayMap() {
    return {
      'دور کمر': waist,
      'دور سینه': chest,
      'دور باسن': hips,
      'دور بازو': arm,
      'دور ران': thigh,
      'سرشانه': shoulder,
      'دور شکم': belly,
    };
  }
}
