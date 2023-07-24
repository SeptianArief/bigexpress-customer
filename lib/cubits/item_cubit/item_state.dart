part of '../cubits.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemFailed extends ItemState {
  final ApiReturnValue data;

  const ItemFailed(this.data);

  @override
  List<Object> get props => [data];
}

class ItemLoaded extends ItemState {
  final List<ItemModel> data;

  const ItemLoaded(this.data);

  @override
  List<Object> get props => [data];
}
