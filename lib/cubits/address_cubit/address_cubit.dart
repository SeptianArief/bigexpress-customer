part of '../cubits.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  void fetchAddress(String type, String id) {
    emit(AddressLoading());
    AddressService.fetchAddress(id: id, type: type).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(AddressLoaded(value.data!));
      } else {
        emit(AddressFailed(value));
      }
    });
  }
}
