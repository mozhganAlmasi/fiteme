import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_size/data/model/size_model.dart';
import 'package:shahrzad/feature/feature_size/domain/entities/entities.dart';
import 'package:shahrzad/feature/feature_size/domain/repository/repositories.dart';


class GetSizeUseCase implements UseCase<List<SizeModel> , String>{
  final SizeRepository sizeRepository;

  GetSizeUseCase({required this.sizeRepository});

  @override
  Future<List<SizeModel>> call({required String params}) {
   return sizeRepository.getSize(params);
  }

  
}