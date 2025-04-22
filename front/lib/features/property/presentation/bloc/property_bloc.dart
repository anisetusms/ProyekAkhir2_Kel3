import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/features/property/domain/usecases/get_properties.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final GetProperties getProperties;

  PropertyBloc({required this.getProperties}) : super(PropertyInitial()) {
    on<LoadProperties>((event, emit) async {
      emit(PropertyLoading());
      
      final result = await getProperties(Params(isDeleted: event.isDeleted));
      
      result.fold(
        (failure) => emit(PropertyError(message: failure.message)),
        (properties) => emit(PropertyLoaded(properties: properties)),
      );
    });
  }
}