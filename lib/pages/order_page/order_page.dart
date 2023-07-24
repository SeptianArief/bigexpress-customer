part of '../pages.dart';

class OrderPage extends StatefulWidget {
  final int idService;
  const OrderPage({Key? key, required this.idService}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isNoteClickable = false;

  // PICK FORM CONTROLLER (STEP 1)
  final TextEditingController _pickNameController = TextEditingController();
  final TextEditingController _pickPhoneController = TextEditingController();
  bool itemSaved = false;

  // SHIP FORM CONTROLLER (STEP 2)
  final TextEditingController _shipNameController = TextEditingController();
  final TextEditingController _shipPhoneController = TextEditingController();

  // ITEM NAME CONTROLLER (STEP 3)
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemWeightController = TextEditingController();
  ValueNotifier<int?> weightFinal = ValueNotifier(null);

  // NOTE CONTROLLER (STEP 4)
  final TextEditingController _noteController = TextEditingController();

  // ACTIVE STEP STATE
  int _currentActiveForm = 1;
  late int _activeService;
  bool saveItem = false;
  bool isBrokenItem = false;
  int totalReceiverAddress = 1;

  List<Map<String, String>> dataService = [
    {
      'asset': 'assets/images/BIG Express.png',
      'name': "BIG Express",
      "desc": "Langsung diambil. Tiba maksimal 1 jam"
    },
    {
      "asset": "assets/images/BIG Sameday.png",
      "name": "BIG Sameday",
      "desc": "Diambil pagi maksimal pukul 12.00 dan sore maksimal 18.00"
    }
  ];

  @override
  void initState() {
    OrderFormstate orderState = BlocProvider.of<OrderFormCubit>(context).state;
    if (orderState is OrderForm) {
      orderState.controller.selectedService.value = widget.idService;
    }

    print(widget.idService);
    setState(() {
      _activeService = widget.idService;
    });
    super.initState();
  }

  bool isItemActive() {
    bool returnValue = false;
    OrderFormstate orderFormState =
        BlocProvider.of<OrderFormCubit>(context).state;
    if (orderFormState is OrderForm) {
      if ((_itemWeightController.text.isEmpty &&
          (_itemNameController.text.isEmpty || weightFinal.value == null))) {
        if (orderFormState.controller.selectedItem.value != null) {
          returnValue = true;
        }
      } else {
        returnValue = true;
      }
    }

    if (_currentActiveForm >= 3) {
      returnValue = true;
    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<OrderFormCubit>(context)
            .emit(OrderForm(OrderFormModel()));
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          backgroundColor: ColorPallette.baseWhite,
          body: BlocBuilder<OrderFormCubit, OrderFormstate>(
            bloc: BlocProvider.of<OrderFormCubit>(context),
            builder: (context, stateOrder) {
              if (stateOrder is OrderForm) {
                return Column(
                  children: [
                    HeaderBar(
                      title: 'Transaksi',
                      onTap: () {
                        BlocProvider.of<OrderFormCubit>(context)
                            .emit(OrderForm(OrderFormModel()));
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 5.0.w),
                          BlocBuilder<UtilCubit, UtilState>(
                              bloc: BlocProvider.of<UtilCubit>(context),
                              builder: (context, state) {
                                if (state is ServiceLoaded) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: List.generate(
                                            state.data.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          OrderFormstate orderState =
                                              BlocProvider.of<OrderFormCubit>(
                                                      context)
                                                  .state;
                                          if (orderState is OrderForm) {
                                            orderState
                                                .controller
                                                .selectedService
                                                .value = state.data[index].id;
                                            setState(() {
                                              _activeService =
                                                  state.data[index].id;
                                            });
                                            completeAddressFetchPrice(context,
                                                onSuccess: () {},
                                                state: orderState);
                                          }
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left:
                                                    index == 0 ? 5.0.w : 3.0.w,
                                                right: index ==
                                                        dataService.length - 1
                                                    ? 5.0.w
                                                    : 0),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0.w,
                                                vertical: 3.0.w),
                                            decoration: BoxDecoration(
                                              color: state.data[index].id ==
                                                      _activeService
                                                  ? ColorPallette.baseBlue
                                                  : ColorPallette.secondaryGrey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: ColorPallette.baseGrey,
                                                width: 0.3,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  baseUrl +
                                                      'asset/other/' +
                                                      state.data[index].logo,
                                                  width: 12.0.w,
                                                  height: 12.0.w,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                SizedBox(
                                                  width: 35.0.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        state.data[index].name,
                                                        style: FontTheme
                                                            .boldUbuntuFont
                                                            .copyWith(
                                                          fontSize: 12.sp,
                                                          color: state
                                                                      .data[
                                                                          index]
                                                                      .id ==
                                                                  _activeService
                                                              ? Colors.white
                                                              : ColorPallette
                                                                  .baseBlue,
                                                        ),
                                                      ),
                                                      SizedBox(height: 1.0.w),
                                                      Text(
                                                        state.data[index].desc,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: FontTheme
                                                            .regularBaseFont
                                                            .copyWith(
                                                          fontSize: 9.sp,
                                                          color: state
                                                                      .data[
                                                                          index]
                                                                      .id ==
                                                                  _activeService
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.8)
                                                              : ColorPallette
                                                                  .baseBlack
                                                                  .withOpacity(
                                                                      0.8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    })),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.0.w,
                                ),

                                /// WIDGET: FORM STEP 1
                                TimelineForm(
                                  isFirst: true,
                                  index: 1,
                                  isActive: _currentActiveForm >= 1,
                                  isChecked: _currentActiveForm > 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// WIDGET: STEP TITLE
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 3.0.w,
                                            right: 3.0.w,
                                            top: 1.5.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_currentActiveForm > 1) {
                                              setState(() {
                                                _currentActiveForm = 1;
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Alamat Pengambilan",
                                            style:
                                                FontTheme.boldBaseFont.copyWith(
                                              fontSize: 13.sp,
                                              color: _currentActiveForm >= 1
                                                  ? ColorPallette.baseBlue
                                                  : ColorPallette.baseGrey,
                                            ),
                                          ),
                                        ),
                                      ),

                                      _currentActiveForm != 1
                                          ? SizedBox(height: 10.0.w)
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.0.w,
                                                vertical: 3.0.w,
                                              ),
                                              child: Column(
                                                children: [
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          stateOrder.controller
                                                              .addressSender,
                                                      builder: (context,
                                                          AddressLocal?
                                                              dataAddressSender,
                                                          _) {
                                                        return dataAddressSender ==
                                                                null
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              AddressListPage(type: 0)));
                                                                },
                                                                child: DropdownWidget(
                                                                    hintText:
                                                                        'Alamat Pengambilan',
                                                                    value: dataAddressSender
                                                                        ?.address),
                                                              )
                                                            : Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            dataAddressSender
                                                                                .name,
                                                                            style:
                                                                                FontTheme.boldBaseFont.copyWith(fontSize: 11.0.sp, color: Colors.black87)),
                                                                        Text(
                                                                            dataAddressSender
                                                                                .phoneNumber,
                                                                            style:
                                                                                FontTheme.regularBaseFont.copyWith(fontSize: 8.0.sp, color: Colors.black54)),
                                                                        SizedBox(
                                                                            height:
                                                                                1.0.w),
                                                                        Text(dataAddressSender
                                                                            .address),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                  SizedBox(
                                                                      width: 3.0
                                                                          .w),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (_) => const AddressListPage(type: 0)));
                                                                      },
                                                                      child: Container(
                                                                          width: 12.0
                                                                              .w,
                                                                          height: 12.0
                                                                              .w,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  10),
                                                                              color: Colors
                                                                                  .orange),
                                                                          child: const Icon(
                                                                              Icons.edit,
                                                                              color: Colors.white)))
                                                                ],
                                                              );
                                                      }),
                                                  SizedBox(height: 3.0.w),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),

                                Column(
                                  children: List.generate(totalReceiverAddress,
                                      (index) {
                                    bool isPressableGlob = false;
                                    for (var i = 0;
                                        i <
                                            stateOrder.controller
                                                .addressReceiver.value.length;
                                        i++) {
                                      if (stateOrder.controller.addressReceiver
                                              .value[i] !=
                                          null) {
                                        isPressableGlob = true;
                                      }
                                    }
                                    return TimelineForm(
                                      index: index + 2,
                                      isActive: isPressableGlob,
                                      isChecked: _currentActiveForm > 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// WIDGET: STEP TITLE
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 3.0.w,
                                                right: 3.0.w,
                                                top: 3.0.w),
                                            child: GestureDetector(
                                              onTap: () {
                                                bool isPressable = false;
                                                for (var i = 0;
                                                    i <
                                                        stateOrder
                                                            .controller
                                                            .addressReceiver
                                                            .value
                                                            .length;
                                                    i++) {
                                                  if (stateOrder
                                                          .controller
                                                          .addressReceiver
                                                          .value[i] !=
                                                      null) {
                                                    isPressable = true;
                                                  }
                                                }
                                                if (isPressable) {
                                                  setState(() {
                                                    _currentActiveForm = 2;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                totalReceiverAddress == 1
                                                    ? "Alamat Pengiriman"
                                                    : "Alamat Pengiriman ${index + 1}",
                                                style: FontTheme.boldBaseFont
                                                    .copyWith(
                                                  fontSize: 13.sp,
                                                  color: isPressableGlob
                                                      ? ColorPallette.baseBlue
                                                      : ColorPallette.baseGrey,
                                                ),
                                              ),
                                            ),
                                          ),

                                          _currentActiveForm != 2
                                              ? SizedBox(height: 10.0.w)
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w,
                                                    vertical: 3.0.w,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      /// WIDGET: SHIP ADDRESS DROPDOWN
                                                      ValueListenableBuilder(
                                                          valueListenable:
                                                              stateOrder
                                                                  .controller
                                                                  .addressReceiver,
                                                          builder: (context,
                                                              List<AddressLocal?>
                                                                  dataAddressReceiver,
                                                              _) {
                                                            return dataAddressReceiver[
                                                                        index] ==
                                                                    null
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                            onTap: () async {
                                                                              await Navigator.push(context, MaterialPageRoute(builder: (_) => AddressListPage(type: 1, index: index)));
                                                                              setState(() {});
                                                                            },
                                                                            child: DropdownWidget(hintText: totalReceiverAddress == 1 ? "Alamat Pengiriman" : "Alamat Pengiriman ${index + 1}", value: null)),
                                                                      ),
                                                                      totalReceiverAddress >
                                                                              1
                                                                          ? GestureDetector(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  totalReceiverAddress = totalReceiverAddress - 1;
                                                                                  stateOrder.controller.addressReceiver.value.removeAt(index);
                                                                                });
                                                                              },
                                                                              child: Container(margin: EdgeInsets.only(left: 3.0.w), width: 12.0.w, height: 12.0.w, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red), child: const Icon(Icons.close, color: Colors.white)),
                                                                            )
                                                                          : Container(),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(dataAddressReceiver[index]!.name,
                                                                                style: FontTheme.boldBaseFont.copyWith(fontSize: 11.0.sp, color: Colors.black87)),
                                                                            Text(dataAddressReceiver[index]!.phoneNumber,
                                                                                style: FontTheme.regularBaseFont.copyWith(fontSize: 8.0.sp, color: Colors.black54)),
                                                                            Text(dataAddressReceiver[index]!.address),
                                                                          ],
                                                                        ),
                                                                      )),
                                                                      SizedBox(
                                                                          width:
                                                                              3.0.w),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          await Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => AddressListPage(type: 1, index: index)));
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Container(
                                                                            width:
                                                                                12.0.w,
                                                                            height: 12.0.w,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange),
                                                                            child: const Icon(Icons.edit, color: Colors.white)),
                                                                      ),
                                                                      totalReceiverAddress >
                                                                              1
                                                                          ? GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  totalReceiverAddress = totalReceiverAddress - 1;
                                                                                  stateOrder.controller.addressReceiver.value.removeAt(index);
                                                                                });
                                                                              },
                                                                              child: Container(margin: EdgeInsets.only(left: 2.0.w), width: 12.0.w, height: 12.0.w, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red), child: Icon(Icons.close, color: Colors.white)),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  );
                                                          }),
                                                      index ==
                                                                  totalReceiverAddress -
                                                                      1 &&
                                                              totalReceiverAddress <
                                                                  3
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  totalReceiverAddress =
                                                                      totalReceiverAddress +
                                                                          1;
                                                                  stateOrder
                                                                      .controller
                                                                      .addressReceiver
                                                                      .value
                                                                      .add(
                                                                          null);
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5.0
                                                                            .w),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0.w),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: ColorPallette
                                                                            .baseBlue)),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Tambah Alamat Pengiriman',
                                                                  style: FontTheme
                                                                      .regularBaseFont
                                                                      .copyWith(
                                                                          fontSize: 11.0
                                                                              .sp,
                                                                          color:
                                                                              ColorPallette.baseBlue),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                          const SizedBox(),
                                        ],
                                      ),
                                    );
                                  }),
                                ),

                                /// WIDGET: FORM STEP 3
                                TimelineForm(
                                  index: 3 + totalReceiverAddress - 1,
                                  isActive: isItemActive(),
                                  isChecked: _currentActiveForm > 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// WIDGET: STEP TITLE
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 3.0.w,
                                            right: 3.0.w,
                                            top: 1.5.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (isItemActive()) {
                                              setState(() {
                                                _currentActiveForm = 3;
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Detail Item",
                                            style:
                                                FontTheme.boldBaseFont.copyWith(
                                              fontSize: 12.sp,
                                              color: isItemActive()
                                                  ? ColorPallette.baseBlue
                                                  : ColorPallette.baseGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // if (_currentActiveForm != 3)
                                      //   SizedBox(
                                      //     height: 30.h,
                                      //   ),
                                      // if (_currentActiveForm == 3)

                                      _currentActiveForm != 3
                                          ? SizedBox(height: 10.0.w)
                                          : ValueListenableBuilder(
                                              valueListenable: stateOrder
                                                  .controller.selectedItem,
                                              builder: (context,
                                                  ItemModel? selectedItem, _) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w,
                                                    vertical: 3.0.w,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      selectedItem == null
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Nama Item",
                                                                  style: FontTheme.boldBaseFont.copyWith(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        2.0.w),
                                                                InputField(
                                                                  hintText:
                                                                      "Masukkan Nama Item",
                                                                  controller:
                                                                      _itemNameController,
                                                                  borderType:
                                                                      "solid",
                                                                  verticalPadding:
                                                                      3.0.w,
                                                                  onChanged:
                                                                      (value) {
                                                                    // checkoutProvider.setSenderName(value ?? "");
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        5.0.w),
                                                                InputField(
                                                                  hintText:
                                                                      "Masukan berat item",

                                                                  // controller: checkoutProvider
                                                                  //     .weightController,
                                                                  controller:
                                                                      _pickNameController,
                                                                  borderType:
                                                                      "none",
                                                                  fillColor:
                                                                      ColorPallette
                                                                          .secondaryGrey,
                                                                  verticalPadding:
                                                                      3.0.w,
                                                                  suffixIcon:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4.0.w),
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight: Radius.circular(
                                                                                10),
                                                                            bottomRight: Radius.circular(
                                                                                10)),
                                                                        color: ColorPallette
                                                                            .baseBlue),
                                                                    child: Center(
                                                                        heightFactor: 1,
                                                                        widthFactor: 1,
                                                                        child: Text(
                                                                          'KG',
                                                                          style: FontTheme
                                                                              .boldUbuntuFont
                                                                              .copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value!
                                                                        .isNotEmpty) {
                                                                      setState(
                                                                          () {
                                                                        weightFinal.value =
                                                                            int.parse(value);
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        weightFinal.value =
                                                                            null;
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        3.0.w),
                                                                itemSaved
                                                                    ? Container()
                                                                    : Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              1.0.w,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            /// WIDGET: BROKEN ITEM CHECKBOX
                                                                            SizedBox(
                                                                              width: 6.0.w,
                                                                              height: 6.0.w,
                                                                              child: Checkbox(
                                                                                side: const BorderSide(
                                                                                  color: ColorPallette.baseBlack,
                                                                                  width: 1.5,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(3),
                                                                                ),
                                                                                value: saveItem,
                                                                                activeColor: ColorPallette.baseBlack,
                                                                                focusColor: ColorPallette.baseBlack,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    saveItem = value!;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 1.0.w,
                                                                            ),

                                                                            /// WIDGET: BROKEN ITEM CHECKBOX TEXT
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  saveItem = !saveItem;
                                                                                });
                                                                              },
                                                                              child: Text(
                                                                                "Simpan Item",
                                                                                style: FontTheme.regularBaseFont.copyWith(
                                                                                  color: ColorPallette.baseBlack,
                                                                                  fontSize: 10.0.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                    height:
                                                                        5.0.w),
                                                                CustomButton(
                                                                    onTap:
                                                                        () async {
                                                                      await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => ItemListPage()));

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    text:
                                                                        'Ambil Dari Daftar Item',
                                                                    pressAble:
                                                                        true),
                                                                SizedBox(
                                                                  height: 5.w,
                                                                ),
                                                              ],
                                                            )
                                                          : Column(children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          selectedItem
                                                                              .name,
                                                                          style: FontTheme
                                                                              .boldBaseFont
                                                                              .copyWith(fontSize: 12.0.sp),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                1.0.w),
                                                                        Text(
                                                                          selectedItem.weight.toString() +
                                                                              'KG',
                                                                          style: FontTheme
                                                                              .regularBaseFont
                                                                              .copyWith(fontSize: 12.0.sp),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                  SizedBox(
                                                                      width: 3.0
                                                                          .w),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (_) => const ItemListPage()));

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: Container(
                                                                          width: 12.0
                                                                              .w,
                                                                          height: 12.0
                                                                              .w,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  10),
                                                                              color: Colors
                                                                                  .orange),
                                                                          child: const Icon(
                                                                              Icons.edit,
                                                                              color: Colors.white))),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        stateOrder
                                                                            .controller
                                                                            .selectedItem
                                                                            .value = null;
                                                                        setState(
                                                                            () {
                                                                          weightFinal.value =
                                                                              null;
                                                                        });
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                        margin: EdgeInsets.only(
                                                                            left: 2.0
                                                                                .w),
                                                                        width: 12.0
                                                                            .w,
                                                                        height:
                                                                            12.0
                                                                                .w,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                10),
                                                                            color: Colors
                                                                                .red),
                                                                        child: Icon(
                                                                            Icons
                                                                                .close,
                                                                            color:
                                                                                Colors.white)),
                                                                  )
                                                                ],
                                                              )
                                                            ]),

                                                      SizedBox(height: 3.0.w),

                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 1.0.w,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            /// WIDGET: BROKEN ITEM CHECKBOX
                                                            SizedBox(
                                                              width: 6.0.w,
                                                              height: 6.0.w,
                                                              child: Checkbox(
                                                                side:
                                                                    BorderSide(
                                                                  color: ColorPallette
                                                                      .baseYellow,
                                                                ),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                                value:
                                                                    isBrokenItem,
                                                                activeColor:
                                                                    ColorPallette
                                                                        .baseYellow,
                                                                focusColor:
                                                                    ColorPallette
                                                                        .baseYellow,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    isBrokenItem =
                                                                        value!;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 1.0.w,
                                                            ),

                                                            /// WIDGET: BROKEN ITEM CHECKBOX TEXT
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  isBrokenItem =
                                                                      !isBrokenItem;
                                                                });
                                                              },
                                                              child: Text(
                                                                "Barang Pecah Belah",
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        color: ColorPallette
                                                                            .baseYellow,
                                                                        fontSize:
                                                                            9.0.sp),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        height: 5.w,
                                                      ),
                                                      ValueListenableBuilder(
                                                          valueListenable:
                                                              weightFinal,
                                                          builder: (context,
                                                              int? weight, _) {
                                                            String
                                                                selectedWeight =
                                                                '';

                                                            if (selectedItem !=
                                                                null) {
                                                              weightFinal
                                                                      .value =
                                                                  selectedItem
                                                                      .weight
                                                                      .toInt();
                                                            }

                                                            if (weight !=
                                                                null) {
                                                              if (weight >= 0 &&
                                                                  weight <= 5) {
                                                                selectedWeight =
                                                                    'Kapasitas Kecil';
                                                              } else if (weight >
                                                                      5 &&
                                                                  weight <=
                                                                      20) {
                                                                selectedWeight =
                                                                    'Kapasitas Sedang';
                                                              } else if (weight >
                                                                      20 &&
                                                                  weight <=
                                                                      30) {
                                                                selectedWeight =
                                                                    'Kapasitas Besar';
                                                              } else {
                                                                selectedWeight =
                                                                    '';
                                                              }
                                                            }

                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    3.0.w,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  /// WIDGET: ITEM SIZE CARD 1
                                                                  ItemSizeCard(
                                                                    isActive:
                                                                        selectedWeight ==
                                                                            "Kapasitas Kecil",
                                                                    imagePath: selectedWeight ==
                                                                            "Kapasitas Kecil"
                                                                        ? "assets/images/Icon Paket06.png"
                                                                        : "assets/images/Icon Paket05.png",
                                                                    title:
                                                                        "Kecil",
                                                                    subtitle:
                                                                        "Maksimum:\n5 kg",
                                                                    onTap: () {
                                                                      // checkoutProvider.setSelectedSize(
                                                                      //     "Kapasitas Kecil");
                                                                    },
                                                                  ),

                                                                  /// WIDGET: ITEM SIZE CARD 2
                                                                  ItemSizeCard(
                                                                    isActive:
                                                                        selectedWeight ==
                                                                            "Kapasitas Sedang",
                                                                    imagePath: selectedWeight ==
                                                                            "Kapasitas Sedang"
                                                                        ? "assets/images/Icon Paket04.png"
                                                                        : "assets/images/Icon Paket03.png",
                                                                    title:
                                                                        "Sedang",
                                                                    subtitle:
                                                                        "Maksimum:\n20 kg",
                                                                    onTap: () {
                                                                      // checkoutProvider.setSelectedSize(
                                                                      //     "Kapasitas Sedang");
                                                                    },
                                                                  ),

                                                                  /// WIDGET: ITEM SIZE CARD 3
                                                                  ItemSizeCard(
                                                                    isActive:
                                                                        selectedWeight ==
                                                                            "Kapasitas Besar",
                                                                    imagePath: selectedWeight ==
                                                                            "Kapasitas Besar"
                                                                        ? "assets/images/Icon Paket02.png"
                                                                        : "assets/images/Icon Paket01.png",
                                                                    title:
                                                                        "Besar",
                                                                    subtitle:
                                                                        "Maksimum:\n30 kg",
                                                                    onTap: () {
                                                                      // checkoutProvider.setSelectedSize(
                                                                      //     "Kapasitas Besar");
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),

                                                      // SizedBox(
                                                      //   height: 20.h,
                                                      // ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment.spaceBetween,
                                                      //   children: [
                                                      //     /// WIDGET: SAVE ITEM SWITCH TEXT
                                                      //     Text(
                                                      //       "Simpan Ke Daftar Item",
                                                      //       style: FontTheme.regularBaseFont
                                                      //           .copyWith(
                                                      //         fontSize: 13.5.sp,
                                                      //       ),
                                                      //     ),

                                                      //     /// WIDGET: SAVE ITEM SWITCH BUTTON
                                                      //     SizedBox(
                                                      //       width: 40,
                                                      //       height: 20,
                                                      //       child: Switch(
                                                      //         value:
                                                      //             checkoutProvider.saveToItemList,
                                                      //         activeColor: ColorPallette.baseBlue,
                                                      //         onChanged: (value) {
                                                      //           checkoutProvider
                                                      //               .setSaveItemToList(value);
                                                      //         },
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      const SizedBox(),
                                                    ],
                                                  ),
                                                );
                                              }),
                                      const SizedBox(),
                                    ],
                                  ),
                                ),

                                /// WIDGET: FORM STEP 4
                                TimelineForm(
                                  isLast: true,
                                  index: 4 + totalReceiverAddress - 1,
                                  isActive: isNoteClickable,
                                  isChecked: _currentActiveForm > 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// WIDGET: STEP TITLE
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 3.0.w,
                                            right: 3.0.w,
                                            top: 1.5.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (isNoteClickable) {
                                              setState(() {
                                                _currentActiveForm = 4;
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Catatan",
                                            style:
                                                FontTheme.boldBaseFont.copyWith(
                                              fontSize: 13.sp,
                                              color: isNoteClickable
                                                  ? ColorPallette.baseBlue
                                                  : ColorPallette.baseGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // _currentActiveForm == 3 ? Container() :
                                      _currentActiveForm != 4
                                          ? SizedBox(height: 10.0.w)
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.0.w,
                                                vertical: 3.0.w,
                                              ),
                                              child: InputField(
                                                hintText: "Catatan",
                                                controller: _noteController,
                                                borderType: "solid",
                                                verticalPadding: 3.0.w,
                                                maxLines: 5,
                                                onChanged: (value) {},
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    BottomActionBar(
                      onActionPressed: () async {
                        if (_currentActiveForm == 4) {
                          OrderFormstate orderFormState =
                              BlocProvider.of<OrderFormCubit>(context).state;
                          if (orderFormState is OrderForm) {
                            if (orderFormState.controller.selectedItem.value ==
                                null) {
                              orderFormState.controller.selectedItem.value =
                                  ItemModel(
                                      name: _itemNameController.text,
                                      weight: double.parse(
                                          weightFinal.value.toString()),
                                      isBrokenItem: isBrokenItem,
                                      note: _noteController.text,
                                      id: 99);
                            } else {
                              orderFormState.controller.selectedItem.value!
                                  .isBrokenItem = isBrokenItem;
                              orderFormState.controller.selectedItem.value!
                                  .note = _noteController.text;
                            }

                            // orderFormState.controller.itemStore.value =
                            //     saveItem;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PickDriverPage(
                                          senderLocation: LatLng(
                                              orderFormState
                                                  .controller
                                                  .addressSender
                                                  .value!
                                                  .latitude!,
                                              orderFormState
                                                  .controller
                                                  .addressSender
                                                  .value!
                                                  .longitude!),
                                        )));

                            // Navigator.pushNamed(
                            //     context, SelectCourierScreen.routeName,
                            //     arguments: [
                            //       '',
                            //       LatLng(
                            //         orderFormState.controller
                            //             .addressSender.value!.latitude!,
                            //         orderFormState.controller
                            //             .addressSender.value!.longitude!,
                            //       )
                            //     ]);
                          }
                        }

                        if (_currentActiveForm == 3) {
                          OrderFormstate orderFormState =
                              BlocProvider.of<OrderFormCubit>(context).state;
                          if (orderFormState is OrderForm) {
                            if ((_itemWeightController.text.isEmpty &&
                                (_itemNameController.text.isEmpty ||
                                    weightFinal.value == null))) {
                              if (orderFormState
                                      .controller.selectedItem.value !=
                                  null) {
                                setState(() {
                                  _currentActiveForm++;
                                  isNoteClickable = true;
                                });
                              } else {
                                showSnackbar(context,
                                    title: "Harap Isi Data Barang dan Berat",
                                    customColor: Colors.orange);
                              }
                            } else {
                              if (saveItem) {
                                if (saveItem) {
                                  setState(() {
                                    _currentActiveForm++;

                                    isNoteClickable = true;
                                  });
                                } else {
                                  UserState userState =
                                      BlocProvider.of<UserCubit>(context).state;
                                  if (userState is UserLogged) {
                                    ItemService.postItem(
                                            idUser:
                                                userState.user.id.toString(),
                                            nameItem: _itemNameController.text,
                                            weightItem:
                                                weightFinal.value!.toString())
                                        .then((value) {
                                      if (value.status ==
                                          RequestStatus.successRequest) {
                                        showSnackbar(context,
                                            title: 'Berhasil Menyimpan Item');
                                        setState(() {
                                          saveItem = true;

                                          _currentActiveForm++;

                                          isNoteClickable = true;
                                        });
                                      } else {
                                        showSnackbar(context,
                                            title: 'Gagal Menyimpan Item',
                                            customColor: Colors.orange);
                                      }
                                    });
                                  }
                                }
                              } else {
                                setState(() {
                                  _currentActiveForm++;

                                  isNoteClickable = true;
                                });
                              }
                            }
                          }
                        }

                        if (_currentActiveForm == 2) {
                          int indexReceiverAddress = 0;

                          for (var i = 0;
                              i <
                                  stateOrder
                                      .controller.addressReceiver.value.length;
                              i++) {
                            if (stateOrder
                                    .controller.addressReceiver.value[i] !=
                                null) {
                              indexReceiverAddress = indexReceiverAddress + 1;
                            }
                          }
                          if (indexReceiverAddress == 0) {
                            showSnackbar(context,
                                title: "Harap Isi Semua Form Pada Step 2",
                                customColor: Colors.orange);
                          } else {
                            setState(() {
                              _currentActiveForm++;
                            });
                          }
                        }

                        if (_currentActiveForm == 1) {
                          if (stateOrder.controller.addressSender.value ==
                              null) {
                            showSnackbar(context,
                                title: "Harap Isi Semua Form Pada Step 1",
                                customColor: Colors.orange);
                          } else {
                            setState(() {
                              _currentActiveForm++;
                            });
                          }
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class ItemSizeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isActive;
  final void Function()? onTap;

  const ItemSizeCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isActive = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            /// WIDGET: ICON OPTION
            /// A
            FractionallySizedBox(
                widthFactor: 0.6,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(3.0.w),
                      decoration: BoxDecoration(
                        color: isActive
                            ? ColorPallette.baseBlue
                            : const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          imagePath,
                        ),
                      ),
                    ))),

            SizedBox(
              height: 3.w,
            ),

            /// WIDGET: OPTION TITLE
            Text(
              title,
              style: FontTheme.boldPoppinsFont.copyWith(
                fontSize: 12.sp,
                color:
                    isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
              ),
            ),
            SizedBox(
              height: 3.w,
            ),

            /// WIDGET: OPTION SUBTITLE
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: FontTheme.mediumPoppinsFont.copyWith(
                fontSize: 9.sp,
                color:
                    isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Maksimal Ukuran\n50cm x 50cm',
              textAlign: TextAlign.center,
              style: FontTheme.mediumPoppinsFont.copyWith(
                fontSize: 7.sp,
                color:
                    isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  final void Function()? onActionPressed;

  const BottomActionBar({Key? key, this.onActionPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderFormCubit, OrderFormstate>(
        bloc: BlocProvider.of<OrderFormCubit>(context),
        builder: (context, state) {
          if (state is OrderForm) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0.w,
                vertical: 3.0.w,
              ),
              decoration: BoxDecoration(
                color: ColorPallette.baseWhite,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-2, -2),
                    blurRadius: 5,
                    color: ColorPallette.baseBlack.withOpacity(0.15),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// WIDGET: COST NOMINAL NUMBER
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: state.controller.price,
                            builder: (context, PriceModel? dataPrice, _) =>
                                dataPrice == null
                                    ? Text(
                                        'Rp0',
                                        style: FontTheme.boldBaseFont.copyWith(
                                          fontSize: 13.sp,
                                          color: ColorPallette.baseBlue,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataPrice.isValid
                                                ? NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    decimalDigits: 0,
                                                    symbol: "Rp ",
                                                  ).format(
                                                    int.parse(dataPrice.data),
                                                  )
                                                : 'Melebihi Jarak Maksimal',
                                            style:
                                                FontTheme.boldBaseFont.copyWith(
                                              fontSize: dataPrice.isValid
                                                  ? 13.sp
                                                  : 10.0.sp,
                                              color: dataPrice.isValid
                                                  ? ColorPallette.baseBlue
                                                  : ColorPallette.baseYellow,
                                            ),
                                          ),
                                          Text(
                                            'Jarak ' +
                                                dataPrice.totalDistance +
                                                ' KM',
                                            style: FontTheme.regularBaseFont
                                                .copyWith(
                                                    fontSize: 10.0.sp,
                                                    color: Colors.black54),
                                          ),
                                        ],
                                      )),
                      ],
                    ),
                  ),

                  /// WIDGET: NEXT ACTION BUTTON
                  ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      primary: ColorPallette.baseBlue,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      fixedSize: Size(183, 42.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Selanjutnya",
                      style: FontTheme.semiBoldBaseFont.copyWith(
                        color: ColorPallette.baseWhite,
                        fontSize: 11.sp,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
