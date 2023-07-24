part of '../cubits.dart';

abstract class OrderFormstate extends Equatable {
  const OrderFormstate();

  @override
  List<Object> get props => [];
}

class OrderForm extends OrderFormstate {
  final OrderFormModel controller;

  const OrderForm(this.controller);

  @override
  List<Object> get props => [controller];
}

class OrderFormModel {
  ValueNotifier<AddressLocal?> addressSender = ValueNotifier(null);
  // ValueNotifier<AddressLocal?> addressReceiver = ValueNotifier(null);
  ValueNotifier<List<AddressLocal?>> addressReceiver = ValueNotifier([null]);
  ValueNotifier<ItemModel?> selectedItem = ValueNotifier(null);
  TextEditingController catatan = TextEditingController();
  ValueNotifier<List<DriverPreview>> selectedDriver = ValueNotifier([]);
  ValueNotifier<int?> selectedService = ValueNotifier(null);
  ValueNotifier<PriceModel?> price = ValueNotifier(null);
  ValueNotifier<bool> itemStore = ValueNotifier(false);
  ValueNotifier<String> catatanValue = ValueNotifier('');
}
