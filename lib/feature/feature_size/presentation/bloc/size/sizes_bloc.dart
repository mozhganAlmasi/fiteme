import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shahrzad/feature/feature_size/data/model/size_model.dart';
import 'package:shahrzad/feature/feature_size/domain/entities/entities.dart';
import 'package:shahrzad/feature/feature_size/domain/usecase/create_size_usecase.dart';
import 'package:shahrzad/feature/feature_size/domain/usecase/get_size_usecase.dart';

import '../../../domain/usecase/delet_size_params.dart';
import '../../../domain/usecase/delet_size_usecase.dart';


part 'sizes_event.dart';
part 'sizes_state.dart';

class SizesBloc extends Bloc<SizesEvent, SizesState> {
  final GetSizeUseCase getSizeUseCase;
  final CreateSizeUseCase createSizeUseCase;
  final DeletSizeUseCase deletSizeUseCase;

  SizesBloc({required this.getSizeUseCase , required this.createSizeUseCase , required this.deletSizeUseCase}) : super(SizesInitial()) {
    on<SizesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadingSize>((event, emit) async {
      emit(SizeLoading());
    });

    on<CreateSize>((event, emit) async {
      try {
        await createSizeUseCase(params : event.size);
        emit(SizeCreateSuccess());
      } catch (e) {
        emit(SizeCreateFail(e.toString()));
      }
    });

    on<LoadSizes>((event, emit) async {
      try {
        emit(SizeLoading());
        List<SizeEntities> result =  await getSizeUseCase(params: event.userID);
        if(result.length ==0) {
          emit(SizeEmpty());
        }else{
          emit(SizeLoadSuccess(result));
        }

      } catch (e) {
        emit(SizeLoadFail(e.toString()));
      }
    });

    on<DeleteSize>((event , emit) async{
      try{
        DeletSizeParams params = DeletSizeParams(userID: event.userID, id: event.rowID);
        await deletSizeUseCase(params: params);
        emit(SizeDeletSuccess(event.rowID));
      }catch(e){
        emit(SizeDeleteFail(e.toString()));
      }
    });


  }
}
