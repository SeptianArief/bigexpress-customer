part of '../cubits.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemInitial());

  void fetchItem(String id) {
    emit(ItemLoading());
    ItemService.listItem(id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ItemLoaded(value.data!));
      } else {
        emit(ItemFailed(value));
      }
    });
  }
}
