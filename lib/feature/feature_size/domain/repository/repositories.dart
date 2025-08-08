import 'package:shahrzad/feature/feature_size/data/model/size_model.dart';

abstract class SizeRepository{
  Future<List<SizeModel>> getSize(String userID);
  Future<bool> createSize(SizeModel size);
  Future<bool> deletSize(String userID , int id);

}