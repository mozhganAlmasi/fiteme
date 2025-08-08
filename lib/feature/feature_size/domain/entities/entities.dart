import 'package:equatable/equatable.dart';

class SizeEntities extends Equatable
{
  final int id;
  final double waist;
  final double chest;
  final double hips;
  final double arm;
  final double thigh;
  final double shoulder;
  final double belly;
  final String dateInsert;
  final String userId;

  SizeEntities(
      {required this.id,
        required this.waist,
        required this.chest,
        required this.hips,
        required this.arm,
        required this.thigh,
        required this.shoulder,
        required this.belly,
        required this.dateInsert,
        required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [id ,waist ,chest ,hips ,arm ,thigh ,shoulder ,belly ,dateInsert ,userId];
}