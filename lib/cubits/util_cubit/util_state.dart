part of '../cubits.dart';

abstract class UtilState extends Equatable {
  const UtilState();

  @override
  List<Object> get props => [];
}

class UtilInitial extends UtilState {}

class UtilLoading extends UtilState {}

class UtilFailed extends UtilState {
  final ApiReturnValue data;

  const UtilFailed(this.data);

  @override
  List<Object> get props => [data];
}

class BannerLoaded extends UtilState {
  final List<BannerModel> data;

  const BannerLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BankLoaded extends UtilState {
  final List<BankOwnerModel> data;

  const BankLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TopupLoaded extends UtilState {
  final List<TopupModel> data;

  const TopupLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class NotificationsLoaded extends UtilState {
  final List<Notifications> data;

  const NotificationsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class DriverLoaded extends UtilState {
  final List<DriverPreview> data;

  const DriverLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceLoaded extends UtilState {
  final List<ServiceModel> data;

  const ServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CityLoaded extends UtilState {
  final List<CityModel> data;

  const CityLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class PromoLoaded extends UtilState {
  final List<PromoModel> data;

  const PromoLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TransactionLoaded extends UtilState {
  final List<TransactionPreview> data;

  const TransactionLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TransactionDetailLoaded extends UtilState {
  final TransactionDetail data;

  const TransactionDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class PaymentListLoaded extends UtilState {
  final PaymentListMaster data;

  const PaymentListLoaded(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}

class PaymentListDetailLoaded extends UtilState {
  final DetailPayment data;

  const PaymentListDetailLoaded(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}
