part of '../pages.dart';

class SelectPaymentPage extends StatefulWidget {
  const SelectPaymentPage({Key? key}) : super(key: key);

  @override
  State<SelectPaymentPage> createState() => _SelectPaymentPageState();
}

class _SelectPaymentPageState extends State<SelectPaymentPage> {
  TextEditingController controller = TextEditingController();
  PromoModel? promo;

  double getDiscountRate(PromoModel dataPromo, String price) {
    double priceTemp = double.parse(price);
    double discount = dataPromo.discountRate == 0
        ? dataPromo.maxDiscount
        : (dataPromo.discountRate / 100) * priceTemp >= dataPromo.maxDiscount
            ? dataPromo.maxDiscount
            : (dataPromo.discountRate / 100) * priceTemp;

    return discount;
  }

  checkout({required int isWallet, required index}) {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    OrderFormstate orderState = BlocProvider.of<OrderFormCubit>(context).state;
    if (userState is UserLogged && orderState is OrderForm) {
      EasyLoading.show(status: 'Mohon Tunggu');
      OrderService.checkout(
              idUser: userState.user.id.toString(),
              serviceId:
                  orderState.controller.selectedService.value!.toString(),
              addressSender: json
                  .encode(orderState.controller.addressSender.value!.toJson()),
              addressReceiver1: json.encode(
                  orderState.controller.addressReceiver.value[0]!.toJson()),
              addressReceiver2: orderState.controller.addressReceiver.value.length < 2
                  ? ''
                  : json.encode(
                      orderState.controller.addressReceiver.value[1]!.toJson()),
              addressReceiver3: orderState.controller.addressReceiver.value.length < 3
                  ? ''
                  : json.encode(
                      orderState.controller.addressReceiver.value[2]!.toJson()),
              items: json
                  .encode(orderState.controller.selectedItem.value!.toJson()),
              price: orderState.controller.price.value!.data,
              discount: promo == null
                  ? '0'
                  : getDiscountRate(promo!, orderState.controller.price.value!.data)
                      .toString(),
              discountName: promo == null ? '' : promo!.title,
              driver1:
                  orderState.controller.selectedDriver.value[0].id.toString(),
              driver2: orderState.controller.selectedDriver.value.length < 2
                  ? '0'
                  : orderState.controller.selectedDriver.value[1].id.toString(),
              driver3: orderState.controller.selectedDriver.value.length < 3 ? '0' : orderState.controller.selectedDriver.value[2].id.toString(),
              isWallet: isWallet.toString(),
              billIndex: index.toString(),
              timeStamp: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()))
          .then((value) {
        EasyLoading.dismiss();
        if (value.status == RequestStatus.successRequest) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => MainPage()), (route) => false);

          showSnackbar(context,
              title: 'Berhasil membuat Transaksi', customColor: Colors.green);
          BlocProvider.of<OrderFormCubit>(context)
              .emit(OrderForm(OrderFormModel()));
        } else {
          showSnackbar(context,
              title: value.data ?? 'Gagal membuat Transaksi',
              customColor: Colors.orange);
        }
      });
    }
  }

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      BlocProvider.of<UserCubit>(context)
          .refreshProfile(id: userState.user.id.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return BlocBuilder<UserCubit, UserState>(
        bloc: BlocProvider.of<UserCubit>(context),
        builder: (context, stateUser) {
          return BlocBuilder<OrderFormCubit, OrderFormstate>(
              bloc: BlocProvider.of<OrderFormCubit>(context),
              builder: (context, state) {
                if (state is OrderForm) {
                  return Column(
                    children: [
                      HeaderBar(title: 'Pilih Pembayaran'),
                      Container(
                          padding: EdgeInsets.all(5.0.w),
                          width: double.infinity,
                          color: ColorPallette.secondaryGrey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tagihan',
                                      style: FontTheme.boldBaseFont.copyWith(
                                          fontSize: 11.0.sp,
                                          color: ColorPallette.baseBlue)),
                                  Text(
                                      moneyChanger(double.parse(
                                          state.controller.price.value!.data)),
                                      style: FontTheme.boldBaseFont.copyWith(
                                          fontSize: 11.0.sp,
                                          color: promo == null
                                              ? ColorPallette.baseBlue
                                              : Colors.black87))
                                ],
                              ),
                              promo == null
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          SizedBox(height: 3.0.w),
                                          Text('Voucher Digunakan'),
                                          SizedBox(height: 1.0.w),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Promo',
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue)),
                                              Text(promo!.title,
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color:
                                                              Colors.black87))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Kode Voucher',
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue)),
                                              Text(promo!.promoCode,
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color:
                                                              Colors.black87))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Diskon',
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue)),
                                              Text(
                                                  moneyChanger(getDiscountRate(
                                                      promo!,
                                                      state.controller.price
                                                          .value!.data)),
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color:
                                                              Colors.black87))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Tagihan',
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue)),
                                              Text(
                                                  moneyChanger(double.parse(
                                                          state.controller.price
                                                              .value!.data) -
                                                      getDiscountRate(
                                                          promo!,
                                                          state.controller.price
                                                              .value!.data)),
                                                  style: FontTheme.boldBaseFont
                                                      .copyWith(
                                                          fontSize: 11.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue))
                                            ],
                                          ),
                                        ])
                            ],
                          )),
                      Expanded(
                          child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                              children: [
                            SizedBox(height: 5.0.w),
                            GestureDetector(
                              onTap: () {
                                UserState userS =
                                    BlocProvider.of<UserCubit>(context).state;
                                if (userS is UserLogged) {
                                  yesOrNoDialog(context,
                                          title:
                                              'Bayar Transaksi dengan Saldo Dompet',
                                          desc:
                                              'Apakah Anda yakin untuk membayar transaksi dengan Saldo Dompet?')
                                      .then((value) {
                                    if (value) {
                                      double priceFinal = double.parse(
                                          state.controller.price.value!.data);
                                      if (promo != null) {
                                        priceFinal = priceFinal -
                                            getDiscountRate(
                                                promo!,
                                                state.controller.price.value!
                                                    .data);
                                      }

                                      if (userS.user.saldo < priceFinal) {
                                        showSnackbar(context,
                                            title: 'Saldo Anda Tidak Cukup',
                                            customColor: Colors.orange);
                                      } else {
                                        checkout(index: 0, isWallet: 1);
                                      }
                                    }
                                  });
                                }
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.0.w, vertical: 3.0.w),
                                      child: Row(
                                        children: [
                                          Container(
                                              margin:
                                                  EdgeInsets.only(right: 3.0.w),
                                              width: 7.0.w,
                                              height: 7.0.w,
                                              child: Image.asset(
                                                  'assets/images/Saldo.png')),
                                          Expanded(
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Dompet',
                                                          style: FontTheme
                                                              .boldBaseFont
                                                              .copyWith(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  color: ColorPallette
                                                                      .baseBlue)),
                                                      SizedBox(height: 1.0.w),
                                                      Text(
                                                          moneyChanger(stateUser
                                                                  is UserLogged
                                                              ? double.parse(
                                                                  stateUser.user
                                                                      .saldo
                                                                      .toString())
                                                              : 0),
                                                          style: FontTheme
                                                              .regularBaseFont
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.0.sp,
                                                                  color: Colors
                                                                      .black87))
                                                    ],
                                                  ))),
                                          SizedBox(width: 3.0.w),
                                          GestureDetector(
                                            onTap: () {
                                              UserState userState =
                                                  BlocProvider.of<UserCubit>(
                                                          context)
                                                      .state;
                                              if (userState is UserLogged) {
                                                BlocProvider.of<UserCubit>(
                                                        context)
                                                    .refreshProfile(
                                                        id: userState.user.id
                                                            .toString());
                                              }
                                            },
                                            child: Container(
                                                height: 10.0.w,
                                                width: 10.0.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.green),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.refresh,
                                                    color: Colors.white)),
                                          ),
                                          SizedBox(width: 3.0.w),
                                          Icon(Icons.arrow_forward_ios_rounded,
                                              color: Colors.black12)
                                        ],
                                      ))),
                            ),
                            SizedBox(height: 3.0.w),
                            GestureDetector(
                              onTap: () async {
                                OrderFormstate state =
                                    BlocProvider.of<OrderFormCubit>(context)
                                        .state;

                                if (state is OrderForm) {
                                  int? result = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      builder: (context) {
                                        return CashPaymentPicker(
                                          receiverAddress: state
                                              .controller.addressReceiver.value,
                                          senderAddress: state
                                              .controller.addressSender.value!,
                                        );
                                      });

                                  if (result != null) {
                                    yesOrNoDialog(context,
                                            title:
                                                'Bayar Transaksi dengan Tunai',
                                            desc:
                                                'Apakah Anda yakin untuk membayar transaksi dengan Tunai?')
                                        .then((value) {
                                      if (value) {
                                        checkout(index: result, isWallet: 0);
                                      }
                                    });
                                  }
                                }
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.0.w, vertical: 4.0.w),
                                      child: Row(
                                        children: [
                                          Container(
                                              margin:
                                                  EdgeInsets.only(right: 3.0.w),
                                              width: 7.0.w,
                                              height: 7.0.w,
                                              child: Image.asset(
                                                  'assets/images/Tunai.png')),
                                          Expanded(
                                              child: SizedBox(
                                            width: double.infinity,
                                            child: Text('Tunai',
                                                style: FontTheme.boldBaseFont
                                                    .copyWith(
                                                        fontSize: 12.0.sp,
                                                        color: ColorPallette
                                                            .baseBlue)),
                                          )),
                                          SizedBox(width: 3.0.w),
                                          Icon(Icons.arrow_forward_ios_rounded,
                                              color: Colors.black12)
                                        ],
                                      ))),
                            )
                          ])),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.w, vertical: 3.0.w),
                        color: ColorPallette.secondaryGrey,
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () async {
                                if (promo == null) {
                                  PromoModel? data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PickVoucherPage()));

                                  if (data != null) {
                                    setState(() {
                                      promo = data;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.0.w, vertical: 2.0.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Row(children: [
                                    Icon(
                                      Icons.discount,
                                      color: ColorPallette.baseBlue,
                                    ),
                                    SizedBox(width: 2.0.w),
                                    Expanded(
                                        child: Text(
                                            promo == null
                                                ? 'Gunakan Voucher Disini'
                                                : promo!.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FontTheme.regularBaseFont
                                                .copyWith(
                                                    fontSize: 10.0.sp,
                                                    fontWeight: promo == null
                                                        ? FontWeight.normal
                                                        : FontWeight.bold,
                                                    color: Colors.black87))),
                                    SizedBox(width: 2.0.w),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 4.0.w, color: Colors.black54)
                                  ])),
                            )),
                            promo == null
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      // if (promo == null) {
                                      //   EasyLoading.show(
                                      //       status: 'Mohon Tunggu');
                                      //   UtilService.listPromoByCode(
                                      //           code: controller.text
                                      //               .toUpperCase())
                                      //       .then((value) {
                                      //     EasyLoading.dismiss();
                                      //     if (value.status ==
                                      //         RequestStatus.successRequest) {
                                      //       if (value.data == null) {
                                      //         showSnackbar(context,
                                      //             title:
                                      //                 'Voucher Tidak Ditemukan',
                                      //             customColor: Colors.orange);
                                      //       } else {
                                      //         setState(() {
                                      //           promo = value.data!;
                                      //           controller.text = controller
                                      //               .text
                                      //               .toUpperCase();
                                      //         });
                                      //       }
                                      //     } else {
                                      //       showSnackbar(context,
                                      //           title:
                                      //               'Gagal Mendapatkan Info Promo');
                                      //     }
                                      //   });
                                      // } else {

                                      // }
                                      setState(() {
                                        promo = null;
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(left: 3.0.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w, vertical: 2.0.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red),
                                        alignment: Alignment.center,
                                        child: Text('Hapus',
                                            style: FontTheme.regularBaseFont
                                                .copyWith(
                                                    fontSize: 11.0.sp,
                                                    color: Colors.white))),
                                  )
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              });
        });
  }
}

class CashPaymentPicker extends StatefulWidget {
  final AddressLocal senderAddress;
  final List<AddressLocal?> receiverAddress;
  const CashPaymentPicker(
      {Key? key, required this.senderAddress, required this.receiverAddress})
      : super(key: key);

  @override
  State<CashPaymentPicker> createState() => _CashPaymentPickerState();
}

class _CashPaymentPickerState extends State<CashPaymentPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Pihak Yang Membayar',
                style: FontTheme.boldPoppinsFont.copyWith(fontSize: 12.0.sp),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close))
            ],
          ),
        ),
        Expanded(
            child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, 0);
              },
              child: Container(
                padding: EdgeInsets.all(5.0.w),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengirim',
                      style: FontTheme.boldBaseFont
                          .copyWith(fontSize: 12.sp, color: Colors.black87),
                    ),
                    SizedBox(height: 2.0.w),
                    Text(
                      widget.senderAddress.name,
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 11.sp, color: Colors.black87),
                    ),
                    Text(
                      widget.senderAddress.address,
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 9.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: List.generate(widget.receiverAddress.length, (index) {
                return widget.receiverAddress[index] == null
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          Navigator.pop(context, index + 1);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0.w),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black12))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penerima ${index + 1}',
                                style: FontTheme.boldBaseFont.copyWith(
                                    fontSize: 12.sp, color: Colors.black87),
                              ),
                              SizedBox(height: 2.0.w),
                              Text(
                                widget.receiverAddress[index]!.name,
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 11.sp, color: Colors.black87),
                              ),
                              Text(
                                widget.receiverAddress[index]!.address,
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 9.sp, color: Colors.black54),
                              ),
                            ],
                          ),
                        ));
              }),
            )
          ],
        ))
      ],
    );
  }
}
