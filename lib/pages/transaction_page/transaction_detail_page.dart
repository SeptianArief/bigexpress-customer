part of '../pages.dart';

class TransactionDetailPage extends StatefulWidget {
  final TransactionPreview data;
  const TransactionDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  UtilCubit detailTransaction = UtilCubit();
  int ratingTemp = 0;

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2623194, 106.9780988),
    zoom: 15.8,
  );

  /// INITIAL ROUTE POLYLINES
  final Set<Polyline> _polylines = {};

  /// INITIAL POLYLINE COORDINATES
  final List<LatLng> _polylineCoordinates = [];

  /// INJECT POLYLINE LIBRARY
  final PolylinePoints _polylinePoints = PolylinePoints();

  // INITIAL MARKERS STATE
  final Set<Marker> _markers = {};

  // INITIAL MARKER IMAGE
  BitmapDescriptor _startLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _myLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _finishLocationIcon = BitmapDescriptor.defaultMarker;

  // GOOGLE MAP CONTROLLER
  final Completer<GoogleMapController> _controller = Completer();

  // GET MARKER IMAGE AS BYTE
  static Future<Uint8List> _getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);

    return data.buffer.asUint8List();
  }

  @override
  void initState() {
    detailTransaction.detailOrder(id: widget.data.id.toString());
    // INIT COURIER MARKER IMAGE
    _getBytesFromAsset("assets/images/Titik Awal.png").then((onValue) {
      setState(() {
        _startLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    // INIT USER MARKER IMAGE
    _getBytesFromAsset("assets/images/Motor Kurir.png").then((onValue) {
      setState(() {
        _myLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    // INIT FINISH MARKER IMAGE
    _getBytesFromAsset("assets/images/Titik Akhir.png").then((onValue) {
      setState(() {
        _finishLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(children: [
      HeaderBar(
          title: 'Transaksi',
          suffix: GestureDetector(
              onTap: () {
                detailTransaction.detailOrder(id: widget.data.id.toString());
              },
              child: Icon(Icons.refresh, color: Colors.white))),
      BlocBuilder<UtilCubit, UtilState>(
          bloc: detailTransaction,
          builder: (context, state) {
            if (state is UtilLoading) {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else if (state is TransactionDetailLoaded) {
              TransactionDetail data = state.data;
              return Expanded(
                child: Column(
                  children: [
                    data.transactionStatus == 2
                        ? Container(
                            width: 100.0.w,
                            height: 40.0.h,
                            child: _mapSection(data))
                        : SizedBox(),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: ListView(
                        children: [
                          // SizedBox(height: 5.0.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data.service,
                                          style: FontTheme.boldBaseFont
                                              .copyWith(
                                                  fontSize: 15.0.sp,
                                                  color:
                                                      ColorPallette.baseBlue)),
                                      SizedBox(height: 2.0.w),
                                      Text(
                                          dateToReadable(data.createdAt
                                                  .substring(0, 10)) +
                                              '\n' +
                                              data.createdAt.substring(11, 16) +
                                              ' WIB',
                                          style: FontTheme.regularBaseFont
                                              .copyWith(
                                            fontSize: 10.0.sp,
                                          ))
                                    ]),
                              )),
                              SizedBox(width: 3.0.w),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status',
                                        style: FontTheme.boldBaseFont.copyWith(
                                            fontSize: 12.0.sp,
                                            color: Colors.black87)),
                                    SizedBox(height: 1.0.w),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.0.w, vertical: 2.0.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: data.transactionStatus ==
                                                        1 ||
                                                    data.transactionStatus == 2
                                                ? ColorPallette.baseBlue
                                                : data.transactionStatus == 3
                                                    ? Colors.green
                                                    : Colors.red),
                                        child: Text(
                                            getStatusFromTransaction(
                                                data.transactionStatus),
                                            style: FontTheme.boldBaseFont
                                                .copyWith(
                                                    fontSize: 11.0.sp,
                                                    color: Colors.white)))
                                  ]),
                            ],
                          ),
                          data.driver != null
                              ? _buildDriverSection(data)
                              : Container(),
                          _buildAddressSection(data),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 3.0.w),
                              width: double.infinity,
                              color: Colors.black12,
                              height: 1),
                          _buildItemSection(data),
                          _buildReviewSection(data),
                          data.transactionStatus == 1
                              ? Container(
                                  margin: EdgeInsets.only(top: 10.0.w),
                                  child: CustomButton(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text(
                                                  'Batalkan Pesanan',
                                                  textAlign: TextAlign.center,
                                                  style: FontTheme
                                                      .mediumBaseFont
                                                      .copyWith(
                                                          fontSize: 13.0.sp,
                                                          color: ColorPallette
                                                              .baseBlue),
                                                ),
                                                content: StatefulBuilder(
                                                  builder: (context, _) {
                                                    TextEditingController
                                                        controller =
                                                        TextEditingController();
                                                    return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InputField(
                                                            controller:
                                                                controller,
                                                            onChanged:
                                                                (value) {},
                                                            maxLines: 3,
                                                            borderType: 'solid',
                                                            hintText:
                                                                'Alasan Pembatalan',
                                                          ),
                                                          SizedBox(
                                                              height: 3.0.w),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              width: 60.0.w,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0.w),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border.all(
                                                                      color: ColorPallette
                                                                          .baseBlue)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'Batal',
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11.0
                                                                                .sp,
                                                                        color: ColorPallette
                                                                            .baseBlue),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 3.0.w),
                                                          GestureDetector(
                                                            onTap: () {
                                                              yesOrNoDialog(
                                                                      context,
                                                                      title:
                                                                          'Batalkan Order?',
                                                                      desc:
                                                                          'Apakah Anda Yakin untuk membatalkan orderan ini?')
                                                                  .then(
                                                                      (valueCancel) {
                                                                if (valueCancel) {
                                                                  EasyLoading.show(
                                                                      status:
                                                                          'Mohon Tunggu');
                                                                  OrderService.cancelOrder(
                                                                          id: widget
                                                                              .data
                                                                              .id
                                                                              .toString(),
                                                                          reason: controller
                                                                              .text)
                                                                      .then(
                                                                          (value) {
                                                                    EasyLoading
                                                                        .dismiss();
                                                                    if (value
                                                                            .status ==
                                                                        RequestStatus
                                                                            .successRequest) {
                                                                      showSnackbar(
                                                                          context,
                                                                          title:
                                                                              'Berhasil Cancel Orderan',
                                                                          customColor:
                                                                              Colors.green);

                                                                      detailTransaction.detailOrder(
                                                                          id: widget
                                                                              .data
                                                                              .id
                                                                              .toString());
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      showSnackbar(
                                                                          context,
                                                                          title:
                                                                              'Gagal Cancel Orderan',
                                                                          customColor:
                                                                              Colors.orange);
                                                                    }
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              width: 60.0.w,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2.0.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    ColorPallette
                                                                        .baseBlue,
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'Konfirmasi',
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ]);
                                                  },
                                                ));
                                          });
                                    },
                                    pressAble: true,
                                    text: 'Batalkan Pesanan',
                                    gradient: LinearGradient(
                                      colors: [Colors.red, Colors.red],
                                      begin: FractionalOffset(0.0, 0.0),
                                      end: FractionalOffset(1.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp,
                                    ),
                                  ))
                              : Container(),
                          SizedBox(height: 10.0.w),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            } else {
              return Expanded(child: FailedRequest(
                onTap: () {
                  detailTransaction.detailOrder(id: widget.data.id.toString());
                },
              ));
            }
          })
    ]);
  }

  Widget _mapSection(TransactionDetail data) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          indoorViewEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          trafficEnabled: false,
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            //create polyline
            late PolylineResult result;
            late LatLng destinationMarker;

            if (data.runningStatus == 0) {
              destinationMarker =
                  LatLng(data.addressSender['lat'], data.addressSender['lon']);
              result = await _polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(data.driver!.lat, data.driver!.lon),
                  PointLatLng(
                      data.addressSender['lat'], data.addressSender['lon']),
                  travelMode: TravelMode.transit);
            } else if (data.runningStatus == 1) {
              destinationMarker = LatLng(
                  data.addressReceiver1['lat'], data.addressReceiver1['lon']);
              result = await _polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(data.driver!.lat, data.driver!.lon),
                  PointLatLng(data.addressReceiver1['lat'],
                      data.addressReceiver1['lon']),
                  travelMode: TravelMode.transit);
            } else if (data.runningStatus == 2) {
              destinationMarker = LatLng(
                  data.addressReceiver2!['lat'], data.addressReceiver2!['lon']);
              result = await _polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(data.driver!.lat, data.driver!.lon),
                  PointLatLng(data.addressReceiver2!['lat'],
                      data.addressReceiver2!['lon']),
                  travelMode: TravelMode.transit);
            } else if (data.runningStatus == 3) {
              destinationMarker = LatLng(
                  data.addressReceiver3!['lat'], data.addressReceiver3!['lon']);
              result = await _polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(data.driver!.lat, data.driver!.lon),
                  PointLatLng(data.addressReceiver3!['lat'],
                      data.addressReceiver3!['lon']),
                  travelMode: TravelMode.transit);
            }

            setState(() {
              /// ADD INTO POLYLINES
              if (result.points.isNotEmpty) {
                for (var point in result.points) {
                  _polylineCoordinates.add(
                    LatLng(point.latitude, point.longitude),
                  );
                }
              }

              Polyline polyline = Polyline(
                polylineId: const PolylineId("poly"),
                color: ColorPallette.baseBlue,
                width: 5,
                points: _polylineCoordinates,
              );

              _polylines.add(polyline);

              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(data.driver!.lat, data.driver!.lon),
                    zoom: 17.00,
                  ),
                ),
              );

              _markers.addAll([
                Marker(
                  markerId: const MarkerId('1'),
                  position: LatLng(
                    data.driver!.lat,
                    data.driver!.lon,
                  ),
                  icon: _myLocationIcon,
                  rotation: 0,
                ),
                Marker(
                  markerId: const MarkerId('5'),
                  position: destinationMarker,
                  icon: _startLocationIcon,
                  rotation: 0,
                ),
              ]);
            });
          },
        ),
        Positioned(
          bottom: 3.0.w,
          right: 3.0.w,
          child: GestureDetector(
            onTap: () async {
              final GoogleMapController controller = await _controller.future;

              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(data.driver!.lat, data.driver!.lon),
                    zoom: 17.00,
                  ),
                ),
              );
            },
            child: Image.asset(
              "assets/images/Target Posisi.png",
              width: 12.0.w,
              height: 12.0.w,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildReviewSection(TransactionDetail data) {
    return data.transactionStatus == 3
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 3.0.w),
                width: double.infinity,
                color: Colors.black12,
                height: 1),
            Text('Review',
                style: FontTheme.boldBaseFont.copyWith(
                    fontSize: 13.0.sp, color: ColorPallette.baseBlue)),
            SizedBox(height: 3.0.w),
            data.review != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 0 : 2.0.w),
                        child: Icon(Icons.star,
                            size: 8.0.w,
                            color: data.review > index
                                ? Colors.amber
                                : Colors.grey),
                      );
                    }))
                : Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratingTemp = rating.toInt();
                        });
                      },
                    ),
                  ),
            data.review == 0
                ? Container(
                    margin: EdgeInsets.only(top: 3.0.w),
                    child: CustomButton(
                      onTap: () async {
                        if (ratingTemp > 0) {
                          yesOrNoDialog(context,
                                  title: 'Berikan Review',
                                  desc: 'Berikan Review Bintang $ratingTemp?')
                              .then((value) {
                            if (value) {
                              EasyLoading.show(status: 'Mohon Tunggu');
                              UtilService.reviewTransaction(
                                      id: widget.data.id.toString(),
                                      rating: ratingTemp.toString())
                                  .then((valueAPI) {
                                EasyLoading.dismiss();
                                if (valueAPI.status ==
                                    RequestStatus.successRequest) {
                                  showSnackbar(context,
                                      title: 'Berhasil Melakukan Review');

                                  detailTransaction.detailOrder(
                                      id: widget.data.id.toString());
                                } else {
                                  showSnackbar(context,
                                      title: 'Gagal Melakukan Review');
                                }
                              });
                            }
                          });
                        } else {
                          showSnackbar(context, title: 'Minimal Bintang 1');
                        }
                      },
                      pressAble: true,
                      text: 'Berikan Review',
                    ))
                : Container()
          ])
        : Container();
  }

  Widget _buildItemSection(TransactionDetail data) {
    return Container(
        margin: EdgeInsets.only(top: 0.0.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Item',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 13.0.sp, color: ColorPallette.baseBlue)),
          SizedBox(height: 3.0.w),
          Text(
            data.item['name'],
            style: FontTheme.boldBaseFont.copyWith(
                fontSize: 10.0.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "${data.item['weight']} KG",
            style: FontTheme.regularBaseFont.copyWith(
              fontSize: 10.0.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 3.0.w),
          Text(
            'Catatan',
            style: FontTheme.regularBaseFont.copyWith(
              fontSize: 10.0.sp,
              color: Colors.black54,
            ),
          ),
          Text(
            data.item['note'].isEmpty ? 'Tidak Ada Catatan' : data.item['note'],
            style: FontTheme.regularBaseFont.copyWith(
              fontSize: 10.0.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 3.0.w),
          Text(
            'Barang Pecah Belah',
            style: FontTheme.regularBaseFont.copyWith(
              fontSize: 10.0.sp,
              color: Colors.black54,
            ),
          ),
          Text(
            data.item['isBrokenItem']
                ? 'Ya Barang Pecah Belah'
                : 'Bukan Barang Pecah Belah',
            style: FontTheme.regularBaseFont.copyWith(
              fontSize: 10.0.sp,
              color: Colors.black87,
            ),
          ),
        ]));
  }

  EvidenceModel? isAvailableEvidence(List<EvidenceModel> data, int index) {
    EvidenceModel? dataReturn;
    for (var i = 0; i < data.length; i++) {
      if (data[i].indexLocation == index) {
        dataReturn = data[i];
      }
    }

    return dataReturn;
  }

  bool isChatOver(TransactionDetail dataDetail) {
    DateTime currentDateTime = DateTime.now();

    if (dataDetail.addressReceiver2 == null) {
      if (isAvailableEvidence(dataDetail.dataEvidence, 1) != null) {
        DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
            .parse(isAvailableEvidence(dataDetail.dataEvidence, 1)!.timestamp)
            .add(Duration(minutes: 30));
        if (currentDateTime.isAfter(dataDateTime)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      if (dataDetail.addressReceiver3 == null) {
        if (isAvailableEvidence(dataDetail.dataEvidence, 2) != null) {
          DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
              .parse(isAvailableEvidence(dataDetail.dataEvidence, 2)!.timestamp)
              .add(Duration(minutes: 30));
          if (currentDateTime.isAfter(dataDateTime)) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        if (isAvailableEvidence(dataDetail.dataEvidence, 3) != null) {
          DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
              .parse(isAvailableEvidence(dataDetail.dataEvidence, 3)!.timestamp)
              .add(Duration(minutes: 30));
          if (currentDateTime.isAfter(dataDateTime)) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
  }

  Widget _buildAddressSection(TransactionDetail data) {
    Widget _addressListWidget(
        {required String title,
        required Map<String, dynamic> address,
        EvidenceModel? photoEvidence}) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 8.0.sp, color: ColorPallette.baseBlue)),
                  Text(address['owner'] ?? 'Nama Tidak Diketahui',
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 8.0.sp, color: ColorPallette.baseBlack)),
                  Text(address['address'],
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 8.0.sp, color: ColorPallette.baseBlack)),
                  SizedBox(height: 1.0.w),
                  Text(address['note'],
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 8.0.sp, color: Colors.black54)),
                ],
              ),
            ),
            photoEvidence == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PhotoPreviewPage(
                                        urlPhoto: baseUrl +
                                            'upload/evidence/' +
                                            photoEvidence.photo,
                                      )));
                        },
                        child: Container(
                            width: 15.0.w,
                            height: 15.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(baseUrl +
                                        'upload/evidence/' +
                                        photoEvidence.photo)))),
                      ),
                      SizedBox(height: 2.0.w),
                      Text(
                          dateToReadable(
                                  photoEvidence.timestamp.substring(0, 10)) +
                              ' ' +
                              photoEvidence.timestamp.substring(11, 16),
                          style: FontTheme.regularBaseFont.copyWith(
                              fontSize: 8.0.sp, color: Colors.black54))
                    ],
                  )
          ],
        ),
        SizedBox(height: 3.0.w)
      ]);
    }

    return Container(
      margin: EdgeInsets.only(top: 0.0.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Alamat',
            style: FontTheme.boldBaseFont
                .copyWith(fontSize: 13.0.sp, color: ColorPallette.baseBlue)),
        SizedBox(height: 1.0.w),
        _addressListWidget(
            title: 'Alamat 1',
            address: data.addressSender,
            photoEvidence: isAvailableEvidence(data.dataEvidence, 0)),
        _addressListWidget(
            title: 'Alamat 2',
            address: data.addressReceiver1,
            photoEvidence: isAvailableEvidence(data.dataEvidence, 1)),
        data.addressReceiver2 == null
            ? Container()
            : _addressListWidget(
                title: 'Alamat 3',
                address: data.addressReceiver2!,
                photoEvidence: isAvailableEvidence(data.dataEvidence, 2)),
        data.addressReceiver3 == null
            ? Container()
            : _addressListWidget(
                title: 'Alamat 4',
                address: data.addressReceiver3!,
                photoEvidence: isAvailableEvidence(data.dataEvidence, 3)),
      ]),
    );
  }

  Widget _buildDriverSection(TransactionDetail data) {
    return Container(
      margin: EdgeInsets.only(top: 10.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Driver',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 13.0.sp, color: ColorPallette.baseBlue)),
          SizedBox(height: 3.0.w),
          Row(
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
                                  data.driver!.photo))),
                    ),
                    SizedBox(width: 10),
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
                                        data.driver!.name,
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
                                        int batasRate =
                                            data.driver!.rating.floor();
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
                                                data.driver!.vehicleName,
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
                                )
                              ],
                            )))
                  ],
                ),
              )),
              SizedBox(width: 3.0.w),
              data.transactionStatus > 3
                  ? Container()
                  : isChatOver(data)
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            launch(
                                'https://wa.me/62${data.driver!.phoneNumber.substring(1)}');
                          },
                          child: Container(
                              width: 10.0.w,
                              height: 10.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green),
                              child: Icon(Icons.chat, color: Colors.white)),
                        ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(bottom: 5.0.w, top: 5.0.w),
              width: double.infinity,
              color: Colors.black12,
              height: 1),
        ],
      ),
    );
  }
}
