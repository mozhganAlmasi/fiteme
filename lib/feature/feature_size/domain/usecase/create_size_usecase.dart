import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_size/data/model/size_model.dart';
import 'package:shahrzad/feature/feature_size/domain/repository/repositories.dart';

import 'delet_size_params.dart';


class CreateSizeUseCase implements UseCase<bool , SizeModel>{
  final SizeRepository sizeRepository;

  CreateSizeUseCase({required this.sizeRepository});

  @override
  Future<bool> call({required SizeModel params}) {
    return sizeRepository.createSize( params);

  }
}