import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_size/domain/entities/entities.dart';
import 'package:shahrzad/feature/feature_size/domain/repository/repositories.dart';


class GetSizeUseCase implements UseCase<List<SizeEntities> , String>{
  final SizeRepository sizeRepository;

  GetSizeUseCase({required this.sizeRepository});

  @override
  Future<List<SizeEntities>> call({required String params}) {
   return sizeRepository.getSize(params);
  }

  
}