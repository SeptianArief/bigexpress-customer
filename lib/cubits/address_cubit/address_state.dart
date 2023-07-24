part of '../cubits.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressFailed extends AddressState {
  final ApiReturnValue data;

  const AddressFailed(this.data);

  @override
  List<Object> get props => [data];
}

class AddressLoaded extends AddressState {
  final List<AddressLocal> data;

  const AddressLoaded(this.data);

  @override
  List<Object> get props => [data];
}
