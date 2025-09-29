import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shahrzad/repositories/size_repository.dart';

import '../../models/size_model.dart';

part 'sizes_event.dart';
part 'sizes_state.dart';

class SizesBloc extends Bloc<SizesEvent, SizesState> {
  SizesBloc() : super(SizesInitial()) {
    on<SizesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SizeLoadingEvent>((event, emit) async {
      emit(SizeLoading());
    });

    on<SizeCreateEvent>((event, emit) async {
      try {
        await SizeRepository.createSize(event.Size);
        emit(SizeCreateSuccess());
      } catch (e) {
        emit(SizeCreateFail(e.toString()));
      }
    });

    on<SizesLoadEvent>((event, emit) async {
      try {
        emit(SizeLoading());
        List<SizeModel> result =  await SizeRepository.fetchSize(event.userID);
        if(result.length ==0) {
          emit(SizeEmpty());
        }else{
          emit(SizeLoadSuccess(result));
        }

      } catch (e) {
        emit(SizeLoadFail(e.toString()));
      }
    });

    on<SizeDeletEvent>((event , emit) async{
      try{
        await SizeRepository.deletSize(event.userID, event.rowID);
        emit(SizeDeletSuccess(event.rowID));
      }catch(e){
        emit(SizeDeleteFail(e.toString()));
      }
    });


  }
}
