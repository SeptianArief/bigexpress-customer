part of '../cubits.dart';

class UtilCubit extends Cubit<UtilState> {
  UtilCubit() : super(UtilInitial());

  void fetchBanner() {
    emit(UtilLoading());
    UtilService.listBanner().then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(BannerLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchBank() {
    emit(UtilLoading());
    UtilService.listBankOwner().then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(BankLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchNotification({required String id}) {
    emit(UtilLoading());
    UtilService.notificationList(id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(NotificationsLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchDriver({required String lat, required String lon}) {
    emit(UtilLoading());
    UtilService.listDriver(lat: lat, lon: lon).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(DriverLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchPromo() {
    emit(UtilLoading());
    UtilService.listPromo().then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(PromoLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchService() {
    emit(UtilLoading());
    UtilService.listService().then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchCity() {
    emit(UtilLoading());
    UtilService.listCity().then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(CityLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchTransaction({required String id}) {
    emit(UtilLoading());
    UtilService.listTransaction(id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(TransactionLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void detailOrder({required String id}) async {
    emit(UtilLoading());
    OrderService.fetchTransaction(id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(TransactionDetailLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchPaymentList(
    BuildContext context, {
    required String amount,
  }) async {
    emit(UtilLoading());
    UserState state = BlocProvider.of<UserCubit>(context).state;
    if (state is UserLogged) {
      FinanceAPI.paymentList(
        id: state.user.id.toString(),
        amount: amount,
        tempId: 'TP${DateFormat('ddMMyy').format(DateTime.now())}',
        name: state.user.name,
        phone: state.user.phoneNumber,
      ).then((value) {
        if (value.status == RequestStatus.successRequest) {
          emit(PaymentListLoaded(
            value.data!,
          ));
        } else {
          emit(UtilFailed(value));
        }
      });
    }
  }

  void fetchPaymentDetail(BuildContext context,
      {required bool isVA,
      required String amount,
      required PaymentListMaster data}) async {
    emit(UtilLoading());
    UserState state = BlocProvider.of<UserCubit>(context).state;
    if (state is UserLogged) {
      FinanceAPI.detailPayment(
              id: state.user.id.toString(),
              amount: amount,
              isVA: isVA,
              name: state.user.name,
              phone: state.user.phoneNumber,
              trxId: data.trxId.toString())
          .then((value) {
        if (value.status == RequestStatus.successRequest) {
          emit(PaymentListDetailLoaded(value.data!));
        } else {
          emit(UtilFailed(value));
        }
      });
    }
  }
}
