import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_size/domain/repository/repositories.dart';

import 'delet_size_params.dart';


class DeletSizeUseCase implements UseCase<bool , DeletSizeParams>{
  final SizeRepository sizeRepository;

  DeletSizeUseCase({required this.sizeRepository});

  @override
  Future<bool> call({required DeletSizeParams params}) {
    return sizeRepository.deletSize(params.userID, params.id);

  }
}