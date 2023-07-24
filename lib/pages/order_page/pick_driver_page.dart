part of '../pages.dart';

class PickDriverPage extends StatefulWidget {
  final LatLng senderLocation;
  final bool isResetOnBack;
  const PickDriverPage(
      {Key? key, required this.senderLocation, this.isResetOnBack = false})
      : super(key: key);

  @override
  State<PickDriverPage> createState() => _PickDriverPageState();
}

class _PickDriverPageState extends State<PickDriverPage> {
  // SELECTED COURIER STATE
  Driver? _selectedCourierIndex;

  List<DriverPreview> _selectedCourier = [];

  // INITIAL MARKERS STATE
  final Set<Marker> _markers = {};

  // INITIAL MARKER IMAGE
  BitmapDescriptor _pinLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _pinLocation2Icon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _myLocationIcon = BitmapDescriptor.defaultMarker;

  // GOOGLE MAP CONTROLLER
  final Completer<GoogleMapController> _controller = Completer();

  // INITIAL CAMERA POSITION
  late CameraPosition _initialCameraPosition;

  // GET MARKER IMAGE AS BYTE
  static Future<Uint8List> _getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);

    return data.buffer.asUint8List();
  }

  final List<dynamic> _lists = [];

  removeFromList(String id) {
    for (var i = 0; i < _selectedCourier.length; i++) {
      if (_selectedCourier[i].id.toString() == id) {
        setState(() {
          _selectedCourier.removeAt(i);
        });
      }
    }
  }

  bool isCourierSelected(String id) {
    bool result = false;

    for (var i = 0; i < _selectedCourier.length; i++) {
      if (_selectedCourier[i].id.toString() == id) {
        result = true;
      }
    }

    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      _initialCameraPosition = CameraPosition(
        target: widget.senderLocation,
        zoom: 16.00,
      );
    });
    super.initState();

    // INIT COURIER MARKER IMAGE
    _getBytesFromAsset("assets/images/Motor Kurir 2.png").then((onValue) {
      setState(() {
        _pinLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    _getBytesFromAsset("assets/images/Motor Kurir.png").then((onValue) {
      setState(() {
        _pinLocation2Icon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    // INIT USER MARKER IMAGE
    _getBytesFromAsset("assets/images/Titik Awal.png").then((onValue) {
      setState(() {
        _myLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Provider.of<OrderProvider>(context, listen: false)
      //     .fetchDrivers(widget.idFrom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.isResetOnBack) {
            BlocProvider.of<OrderFormCubit>(context)
                .emit(OrderForm(OrderFormModel()));
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }

          return false;
        },
        child: Scaffold(
          backgroundColor: ColorPallette.baseWhite,
          body: Column(
            children: [
              HeaderBar(
                title: 'Pilih Kurir',
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
                onTap: () {
                  if (widget.isResetOnBack) {
                    BlocProvider.of<OrderFormCubit>(context)
                        .emit(OrderForm(OrderFormModel()));
                  }

                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 45.h,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _initialCameraPosition,
                      indoorViewEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      trafficEnabled: true,
                      markers: _markers,
                      // gestureRecognizers: <
                      //     Factory<OneSequenceGestureRecognizer>>{
                      //   Factory<OneSequenceGestureRecognizer>(
                      //     () => EagerGestureRecognizer(),
                      //   ),
                      // },
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);

                        LatLng myPosition = widget.senderLocation;

                        setState(() {
                          _markers.addAll([
                            /// SET USER MARKER
                            Marker(
                              markerId: const MarkerId('sender'),
                              position: LatLng(
                                myPosition.latitude,
                                myPosition.longitude,
                              ),
                              icon: _myLocationIcon,
                              rotation: 0,
                            ),
                          ]);
                        });
                      },
                    ),

                    /// WIDGET: SET CURRENT LOCATION BUTTON
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 3.0.w,
                          bottom: 3.0.w,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final GoogleMapController controller =
                                await _controller.future;

                            try {
                              // LatLng myPosition = widget.senderLocation;

                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: widget.senderLocation,
                                    zoom: 17.00,
                                  ),
                                ),
                              );
                            } catch (_) {
                              // Fluttertoast.showToast(
                              //   msg: "Gagal Mendapatkan Posisi",
                              //   gravity: ToastGravity.BOTTOM,
                              // );
                            }
                          },
                          child: Image.asset(
                            "assets/images/Target Posisi.png",
                            width: 12.0.w,
                            height: 12.0.w,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      children: [
                        SizedBox(height: 3.0.w),

                        /// SECTION: GOOGLE MAPS VIEW
                        Container(
                          // padding:
                          //     EdgeInsets.symmetric(vertical: 5.0.w, horizontal: 5.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// WIDGET: TIP SECTION TEXT
                              Text(
                                "Pilih Maksimal 3 Kurir",
                                style: FontTheme.regularPoppinsFont.copyWith(
                                  fontSize: 11.sp,
                                ),
                              ),

                              SizedBox(height: 3.0.w),

                              FutureBuilder<
                                      ApiReturnValue<List<DriverPreview>?>>(
                                  future: UtilService.listDriver(
                                      lat: widget.senderLocation.latitude
                                          .toString(),
                                      lon: widget.senderLocation.longitude
                                          .toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.status ==
                                          RequestStatus.successRequest) {
                                        List<Marker> dataMarker = [];
                                        for (var index = 0;
                                            index < snapshot.data!.data!.length;
                                            index++) {
                                          dataMarker.add(Marker(
                                            markerId:
                                                MarkerId(index.toString()),
                                            position: LatLng(
                                              snapshot.data!.data![index].lat,
                                              snapshot.data!.data![index].lon,
                                            ),
                                            icon: snapshot.data!.data![index]
                                                        .isValidate ==
                                                    1
                                                ? _pinLocationIcon
                                                : _pinLocation2Icon,
                                            rotation: 45,
                                          ));
                                        }

                                        _markers.addAll(dataMarker);

                                        return snapshot.data!.data!.isEmpty
                                            ? Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0.h),
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Kurir Tidak Ditemukan',
                                                  style: FontTheme
                                                      .regularBaseFont
                                                      .copyWith(
                                                          fontSize: 12.0.sp,
                                                          color: Color.fromARGB(
                                                              221,
                                                              234,
                                                              132,
                                                              132)),
                                                ),
                                              )
                                            : Column(
                                                children: List.generate(
                                                    snapshot.data!.data!.length,
                                                    (index) {
                                                DriverPreview dataTemp =
                                                    snapshot.data!.data![index];
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: index ==
                                                              snapshot
                                                                      .data!
                                                                      .data!
                                                                      .length -
                                                                  1
                                                          ? 20.0.w
                                                          : 0),
                                                  child:
                                                      _buildCourierOptionCard(
                                                    isValidate:
                                                        dataTemp.isValidate,
                                                    position: LatLng(
                                                        dataTemp.lat,
                                                        dataTemp.lon),
                                                    data: dataTemp,
                                                    index: index,
                                                    courierName: dataTemp.name,
                                                    star:
                                                        dataTemp.rating.floor(),
                                                    distance: calculateDistance(
                                                                dataTemp.lat,
                                                                dataTemp.lon,
                                                                widget
                                                                    .senderLocation
                                                                    .latitude,
                                                                widget
                                                                    .senderLocation
                                                                    .longitude)
                                                            .toStringAsFixed(
                                                                2) +
                                                        ' KM',
                                                    vehicle:
                                                        dataTemp.vehicleName,
                                                  ),
                                                );
                                              }));
                                      } else {
                                        return Text(
                                            snapshot.data!.status.toString());
                                      }
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }),

                              //   orderProvider.drivers
                              //       .asMap()
                              //       .entries
                              //       .map(
                              //         (driver) =>
                              //       )
                              //       .toList(),
                              // );
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 3.0.w,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                          alignment: Alignment.center,
                          child: CustomButton(
                            onTap: () {
                              if (_selectedCourier.isEmpty) {
                                showSnackbar(context,
                                    title: 'Harap Pilih Driver Terlebih Dahulu',
                                    customColor: Colors.orange);
                              } else {
                                OrderFormstate state =
                                    BlocProvider.of<OrderFormCubit>(context)
                                        .state;
                                if (state is OrderForm) {
                                  state.controller.selectedDriver.value =
                                      _selectedCourier;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectPaymentPage()));
                                }
                              }
                            },
                            pressAble: _selectedCourier.isNotEmpty,
                            text: 'Pilih Kurir (${_selectedCourier.length})',
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCourierOptionCard(
      {required DriverPreview data,
      required int index,
      required String courierName,
      required LatLng position,
      required int star,
      required String distance,
      required String vehicle,
      required int isValidate}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 12.0.w,
                    height: 12.0.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(baseUrl +
                                'upload/profile_picture/' +
                                data.photo))),
                  ),
                  SizedBox(width: 3.0.w),
                  Expanded(
                      child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 40.0.w),
                                    child: Text(
                                      courierName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontTheme.boldBaseFont.copyWith(
                                        fontSize: 11.sp,
                                        color: ColorPallette.baseBlue,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.0.w),
                                  Row(
                                    children: List.generate(5, (index) {
                                      int batasRate = star;
                                      return Icon(
                                        Icons.star,
                                        size: 3.0.w,
                                        color: batasRate > index
                                            ? Colors.amber
                                            : Colors.grey,
                                      );
                                    }),
                                  )
                                ],
                              ),
                              SizedBox(height: 2.0.w),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Icon Peta01.png",
                                          width: 4.0.w,
                                          height: 4.0.w,
                                        ),
                                        SizedBox(
                                          width: 1.w,
                                        ),

                                        /// WIDGET: COURIER DISTANCE
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              distance,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Icon Motor.png",
                                          width: 4.0.w,
                                          height: 4.0.w,
                                        ),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),

                                        // /// WIDGET: MOTOR NAME
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              vehicle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 1.0.w),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 1.0.w),
                                      width: 4.0.w,
                                      height: 4.0.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isValidate == 1
                                              ? Colors.green
                                              : Colors.orange),
                                      child: Icon(
                                          isValidate == 1
                                              ? Icons.check
                                              : Icons.info_outlined,
                                          size: 3.0.w,
                                          color: Colors.white)),
                                  Text(
                                      isValidate == 1
                                          ? 'Tervalidasi'
                                          : 'Belum Tervalidasi',
                                      style: FontTheme.regularBaseFont.copyWith(
                                          fontSize: 9.0.sp,
                                          color: isValidate == 1
                                              ? Colors.green
                                              : Colors.orange)),
                                ],
                              ),
                            ],
                          )))
                ],
              ),
            )),
            SizedBox(width: 10),
            // Expanded(
            //   child: Container(
            //     width: double.infinity,
            //     child: Row(
            //       children: [
            //         /// WIDGET: DELIVERY IMAGE
            //         Image.asset(
            //           "assets/images/Delivery.png",
            //           width: 48.r,
            //           height: 48.r,
            //         ),
            //         SizedBox(
            //           width: 12.w,
            //         ),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(
            //               children: [
            //                 /// WIDGET: COURIER NAME
            //                 Text(
            //                   courierName,
            //                   style: FontTheme.boldBaseFont.copyWith(
            //                     fontSize: 13.sp,
            //                     color: ColorPallette.baseBlue,
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: 12.w,
            //                 ),

            //                 /// WIDGET: COURIER RATING
            //                 RatingStars(star),
            //               ],
            //             ),
            //             SizedBox(
            //               height: 7.h,
            //             ),
            //             Row(
            //               children: [
            //                 /// WIDGET: MAP ICON
            //                 Image.asset(
            //                   "assets/images/Icon Peta01.png",
            //                   width: 14.r,
            //                   height: 14.r,
            //                 ),
            //                 SizedBox(
            //                   width: 6.w,
            //                 ),

            //                 /// WIDGET: COURIER DISTANCE
            //                 Text(
            //                   distance,
            //                   style: FontTheme.regularBaseFont.copyWith(
            //                     fontSize: 11.sp,
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   width: 12.w,
            //                 ),

            //                 /// WIDGET: MOTOR ICON
            //                 Image.asset(
            //                   "assets/images/Icon Motor.png",
            //                   width: 15.r,
            //                   height: 15.r,
            //                 ),
            //                 SizedBox(
            //                   width: 6.w,
            //                 ),

            //                 // /// WIDGET: MOTOR NAME
            //                 Expanded(
            //                   child: SizedBox(
            //                     width: double.infinity,
            //                     child: Text(
            //                       'adkfjklajs fklajsdlf ajsldkf jasldjflk alsjdfl jalsdjlfjal jlfdjal ',
            //                       maxLines: 1,
            //                       overflow: TextOverflow.ellipsis,
            //                       style: FontTheme.regularBaseFont.copyWith(
            //                         fontSize: 13.sp,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(),
            //               ],
            //             ),
            //             const SizedBox(),
            //           ],
            //         ),
            //         const SizedBox(),
            //       ],
            //     ),
            //   ),
            // ),

            /// WIDGET: CHECKBOX BUTTON
            Container(
              width: 5.0.w,
              height: 5.0.w,
              decoration: BoxDecoration(
                color: ColorPallette.baseBlack.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Checkbox(
                value: isCourierSelected(data.id.toString()),
                activeColor: ColorPallette.baseBlue,
                checkColor: ColorPallette.baseWhite,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onChanged: (value) async {
                  // orderProvider.pickDriver(data);
                  bool updateCamera = false;
                  bool toCurrent = false;

                  setState(() {
                    if (isCourierSelected(data.id.toString())) {
                      removeFromList(data.id.toString());

                      updateCamera = true;
                      toCurrent = true;
                    } else {
                      if (_selectedCourier.length >= 3) {
                        // Fluttertoast.showToast(msg: 'Maksimal 3 Kurir');
                      } else {
                        updateCamera = true;
                        _selectedCourier.add(data);
                      }
                    }
                  });

                  if (updateCamera == true) {
                    if (toCurrent) {
                      final GoogleMapController controller =
                          await _controller.future;

                      // LatLng myPosition = widget.senderLocation;

                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: widget.senderLocation,
                            zoom: 17.00,
                          ),
                        ),
                      );
                    } else {
                      final GoogleMapController controller =
                          await _controller.future;

                      // LatLng myPosition = widget.senderLocation;

                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: position,
                            zoom: 17.00,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // orderProvider.pickDriver(
        //   Driver(
        //     id: index,
        //     name: courierName,
        //     star: star.toDouble(),
        //     distance: distance,
        //     vehicle: vehicle,
        //   ),
        // );

        setState(() {});
      },
    );
  }
}

class RatingStars extends StatelessWidget {
  final int count;

  const RatingStars(
    this.count, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.generate(
      count,
      (index) => Padding(
        padding: EdgeInsets.only(right: 1),
        child: Icon(
          Icons.star,
          color: ColorPallette.baseYellow,
          size: 15,
        ),
      ),
    );

    return Row(
      children: widgets,
    );
  }
}
