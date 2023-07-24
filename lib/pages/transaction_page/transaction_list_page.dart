part of '../pages.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

String getStatusFromTransaction(int transactionStatus) {
  return transactionStatus == 1
      ? 'Mencari Driver'
      : transactionStatus == 2
          ? 'Sedang Berjalan'
          : transactionStatus == 3
              ? 'Terkirim'
              : transactionStatus == 4
                  ? 'Dibatalkan'
                  : 'Gagal Mendapat Driver';
}

class _TransactionListPageState extends State<TransactionListPage> {
  UtilCubit listTransactionCubit = UtilCubit();
  int selectedIndex = 0;

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      listTransactionCubit.fetchTransaction(id: userState.user.id.toString());
    }
    super.initState();
  }

  Widget _buildFilterData({required String title, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 1.0.w),
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorPallette.baseYellow),
              color: index == selectedIndex
                  ? ColorPallette.baseYellow
                  : Colors.transparent),
          child: Text(title,
              style: FontTheme.regularBaseFont.copyWith(
                  fontSize: 10.0.sp,
                  color: index == selectedIndex
                      ? Colors.white
                      : ColorPallette.baseYellow))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      ColorPallette.baseBlue,
                      Color(0xFFBAC8DE),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transaksi',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 13.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: () {
                          UserState userState =
                              BlocProvider.of<UserCubit>(context).state;
                          if (userState is UserLogged) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NotificationPage()));
                          } else {
                            showBottomSignInSheet(context);
                          }
                        },
                        child: Icon(Icons.notifications_rounded,
                            color: Colors.white))
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 3.0.w),
                    _buildFilterData(title: 'Semua', index: 0),
                    _buildFilterData(title: 'Sedang Berjalan', index: 1),
                    _buildFilterData(title: 'Terkirim', index: 2),
                    _buildFilterData(title: 'Dibatalkan', index: 3),
                    SizedBox(width: 3.0.w),
                  ],
                ),
              ),
            ),
            BlocBuilder<UtilCubit, UtilState>(
                bloc: listTransactionCubit,
                builder: (context, state) {
                  if (state is UtilLoading) {
                    return Expanded(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      children: List.generate(8, (index) {
                        return PlaceHolder(
                          child: Container(
                            width: 90.0.w,
                            height: 30.0.w,
                            margin: EdgeInsets.only(
                                top: index == 0 ? 3.0.w : 2.0.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                          ),
                        );
                      }),
                    ));
                  } else if (state is TransactionLoaded) {
                    List<TransactionPreview> dataFinal = [];

                    for (var i = 0; i < state.data.length; i++) {
                      if ((state.data[i].transactionStatus == 1 ||
                              state.data[i].transactionStatus == 2) &&
                          selectedIndex == 1) {
                        dataFinal.add(state.data[i]);
                      }
                      if ((state.data[i].transactionStatus == 4 ||
                              state.data[i].transactionStatus == 5) &&
                          selectedIndex == 3) {
                        dataFinal.add(state.data[i]);
                      }
                      if ((state.data[i].transactionStatus == 3) &&
                          selectedIndex == 2) {
                        dataFinal.add(state.data[i]);
                      }

                      if (selectedIndex == 0) {
                        dataFinal.add(state.data[i]);
                      }
                    }

                    return Expanded(
                        child: dataFinal.isEmpty
                            ? Center(child: Text('Data Kosong'))
                            : RefreshIndicator(
                                onRefresh: () async {
                                  UserState userState =
                                      BlocProvider.of<UserCubit>(context).state;
                                  if (userState is UserLogged) {
                                    listTransactionCubit.fetchTransaction(
                                        id: userState.user.id.toString());
                                  }
                                },
                                child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0.w),
                                    children: List.generate(dataFinal.length,
                                        (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TransactionDetailPage(
                                                          data: dataFinal[
                                                              index])));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(5.0.w),
                                            margin: EdgeInsets.only(
                                                bottom: index ==
                                                        dataFinal.length - 1
                                                    ? 5.0.w
                                                    : 0,
                                                top:
                                                    index == 0 ? 5.0.w : 2.0.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.black38),
                                                color: ColorPallette
                                                    .secondaryGrey),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            dateToReadable(dataFinal[
                                                                        index]
                                                                    .createdAt
                                                                    .substring(
                                                                        0,
                                                                        10)) +
                                                                ' ' +
                                                                dataFinal[index]
                                                                    .createdAt
                                                                    .substring(
                                                                        11, 16),
                                                            style: FontTheme
                                                                .regularBaseFont
                                                                .copyWith(
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    color: ColorPallette
                                                                        .baseBlack)),
                                                        Text(
                                                            dataFinal[index]
                                                                .service,
                                                            style: FontTheme
                                                                .boldBaseFont
                                                                .copyWith(
                                                                    fontSize:
                                                                        12.0.sp,
                                                                    color: ColorPallette
                                                                        .baseBlack)),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0.w,
                                                              horizontal:
                                                                  4.0.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: dataFinal[index]
                                                                          .transactionStatus ==
                                                                      1 ||
                                                                  dataFinal[index]
                                                                          .transactionStatus ==
                                                                      2
                                                              ? ColorPallette
                                                                  .baseBlue
                                                              : dataFinal[index]
                                                                          .transactionStatus ==
                                                                      3
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                      child: Text(
                                                          getStatusFromTransaction(
                                                              dataFinal[index]
                                                                  .transactionStatus),
                                                          style: FontTheme
                                                              .regularBaseFont
                                                              .copyWith(
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  color: Colors
                                                                      .white)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 3.0.w),
                                                Row(children: [
                                                  Expanded(
                                                      child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'Penjemputan',
                                                                  style: FontTheme
                                                                      .boldBaseFont
                                                                      .copyWith(
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          color:
                                                                              ColorPallette.baseBlue)),
                                                              SizedBox(
                                                                  height:
                                                                      1.0.w),
                                                              Text(
                                                                  (dataFinal[index].addressSender[
                                                                              'address_name'] ??
                                                                          '-') +
                                                                      " (${dataFinal[index].addressSender['owner']})",
                                                                  style: FontTheme
                                                                      .regularBaseFont
                                                                      .copyWith(
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          color:
                                                                              ColorPallette.baseBlack)),
                                                              Text(
                                                                  dataFinal[index]
                                                                          .addressSender[
                                                                      'address'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FontTheme
                                                                      .regularBaseFont
                                                                      .copyWith(
                                                                          fontSize: 8.0
                                                                              .sp,
                                                                          color:
                                                                              Colors.black54)),
                                                              SizedBox(
                                                                  height:
                                                                      3.0.w),
                                                              Text('Tujuan',
                                                                  style: FontTheme
                                                                      .boldBaseFont
                                                                      .copyWith(
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          color:
                                                                              ColorPallette.baseBlue)),
                                                              SizedBox(
                                                                  height:
                                                                      1.0.w),
                                                              Text(
                                                                  (dataFinal[index].addressReceiver1[
                                                                              'address_name'] ??
                                                                          '-') +
                                                                      " (${dataFinal[index].addressReceiver1['owner']})",
                                                                  style: FontTheme
                                                                      .regularBaseFont
                                                                      .copyWith(
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          color:
                                                                              ColorPallette.baseBlack)),
                                                              Text(
                                                                  dataFinal[index]
                                                                          .addressReceiver1[
                                                                      'address'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FontTheme
                                                                      .regularBaseFont
                                                                      .copyWith(
                                                                          fontSize: 8.0
                                                                              .sp,
                                                                          color:
                                                                              Colors.black54)),
                                                              dataFinal[index].addressReceiver2 !=
                                                                          null ||
                                                                      dataFinal[index]
                                                                              .addressReceiver3 !=
                                                                          null
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 1.0
                                                                              .w),
                                                                      child: Text(
                                                                          dataFinal[index].addressReceiver3 != null
                                                                              ? '+2 Alamat Tujuan'
                                                                              : '+ 1 Alamat Tujuan',
                                                                          style: FontTheme.regularBaseFont.copyWith(
                                                                              fontSize: 11.0.sp,
                                                                              color: ColorPallette.baseBlue)))
                                                                  : Container()
                                                            ],
                                                          ))),
                                                  SizedBox(width: 3.0.w),
                                                  Text(
                                                      moneyChanger(
                                                          dataFinal[index]
                                                                  .price -
                                                              dataFinal[index]
                                                                  .discount),
                                                      style: FontTheme
                                                          .boldBaseFont
                                                          .copyWith(
                                                              fontSize: 15.0.sp,
                                                              color: Colors
                                                                  .black87))
                                                ]),
                                                dataFinal[index].transactionStatus ==
                                                            3 ||
                                                        dataFinal[index]
                                                                .transactionStatus ==
                                                            5
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          OrderFormstate
                                                              orderFormState =
                                                              BlocProvider.of<
                                                                          OrderFormCubit>(
                                                                      context)
                                                                  .state;
                                                          if (orderFormState
                                                              is OrderForm) {
                                                            //set sender location
                                                            orderFormState
                                                                    .controller
                                                                    .addressSender
                                                                    .value =
                                                                AddressLocal.fromJson(
                                                                    dataFinal[
                                                                            index]
                                                                        .addressSender);
                                                            //set receiver location
                                                            orderFormState
                                                                .controller
                                                                .addressReceiver
                                                                .value = [
                                                              AddressLocal.fromJson(
                                                                  dataFinal[
                                                                          index]
                                                                      .addressReceiver1),
                                                            ];

                                                            //set receiver location 2
                                                            if (dataFinal[index]
                                                                    .addressReceiver2 !=
                                                                null) {
                                                              orderFormState
                                                                  .controller
                                                                  .addressReceiver
                                                                  .value
                                                                  .add(AddressLocal.fromJson(
                                                                      dataFinal[
                                                                              index]
                                                                          .addressReceiver2!));
                                                            }

                                                            //set receiver location 3
                                                            if (dataFinal[index]
                                                                    .addressReceiver3 !=
                                                                null) {
                                                              orderFormState
                                                                  .controller
                                                                  .addressReceiver
                                                                  .value
                                                                  .add(AddressLocal.fromJson(
                                                                      dataFinal[
                                                                              index]
                                                                          .addressReceiver3!));
                                                            }

                                                            //set Item selected
                                                            orderFormState.controller.selectedItem.value = ItemModel(
                                                                id: dataFinal[index]
                                                                    .item['id'],
                                                                isBrokenItem:
                                                                    dataFinal[index]
                                                                            .item[
                                                                        'isBrokenItem'],
                                                                name: dataFinal[index]
                                                                        .item[
                                                                    'name'],
                                                                weight: dataFinal[index]
                                                                        .item[
                                                                    'weight'],
                                                                note: dataFinal[
                                                                        index]
                                                                    .item['note']);

                                                            //set service selected
                                                            orderFormState
                                                                .controller
                                                                .selectedService
                                                                .value = dataFinal[
                                                                    index]
                                                                .serviceId;

                                                            //calculate distance and price
                                                            completeAddressFetchPrice(
                                                                context,
                                                                onSuccess: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) => PickDriverPage(
                                                                          isResetOnBack:
                                                                              true,
                                                                          senderLocation: LatLng(
                                                                              dataFinal[index].addressSender['lat'],
                                                                              dataFinal[index].addressSender['lon']))));
                                                            },
                                                                state:
                                                                    orderFormState);
                                                          }
                                                        },
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 4.0.w),
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        3.0.w),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                color: Colors
                                                                    .transparent,
                                                                border: Border.all(
                                                                    color: ColorPallette
                                                                        .baseBlue)),
                                                            child: Center(
                                                                child: Text(
                                                                    dataFinal[index].transactionStatus ==
                                                                            3
                                                                        ? 'Pesan Lagi'
                                                                        : 'Ulangi Pesanan',
                                                                    style: FontTheme
                                                                        .boldBaseFont
                                                                        .copyWith(
                                                                      fontSize:
                                                                          11.0.sp,
                                                                      color: ColorPallette
                                                                          .baseBlue,
                                                                    )))),
                                                      )
                                                    : Container()
                                              ],
                                            )),
                                      );
                                    })),
                              ));
                  } else {
                    return FailedRequest(
                      verticalMargin: 20.0.w,
                      onTap: () {
                        UserState userState =
                            BlocProvider.of<UserCubit>(context).state;
                        if (userState is UserLogged) {
                          listTransactionCubit.fetchTransaction(
                              id: userState.user.id.toString());
                        }
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
