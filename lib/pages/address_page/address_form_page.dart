part of '../pages.dart';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

bool isAvailableApp(mapTool.LatLng currLocation) {
  bool returnValue = false;

  List<List<double>> polygonGresik = [
    [112.62982178, -5.84188604],
    [112.62776947, -5.85353518],
    [112.59087372, -5.85321903],
    [112.58023071, -5.84212065],
    [112.58423615, -5.82927418],
    [112.57468414, -5.82696819],
    [112.58924866, -5.77219725],
    [112.61146545, -5.76828051],
    [112.61080933, -5.75488424],
    [112.62610626, -5.74709463],
    [112.63632965, -5.73553705],
    [112.64755249, -5.72903442],
    [112.66983032, -5.73627377],
    [112.67486572, -5.72250175],
    [112.6897049, -5.7243762],
    [112.70463562, -5.73292065],
    [112.72724915, -5.73803043],
    [112.72466278, -5.75800037],
    [112.73619843, -5.7648387],
    [112.73194885, -5.77458096],
    [112.7390976, -5.77920008],
    [112.73834991, -5.7892108],
    [112.72707367, -5.81635904],
    [112.73226929, -5.82921267],
    [112.72158813, -5.83070898],
    [112.71308899, -5.84225702],
    [112.69853973, -5.84941053],
    [112.65727997, -5.85015345],
    [112.62982178, -5.84188604],
    [112.36825562, -7.32472992],
    [112.38808441, -7.31933451],
    [112.40866852, -7.30594254],
    [112.40765381, -7.28769779],
    [112.4119873, -7.27354574],
    [112.3970108, -7.26456833],
    [112.41957855, -7.23179007],
    [112.43375397, -7.22905731],
    [112.43643188, -7.22267628],
    [112.4527359, -7.20820522],
    [112.47301483, -7.20461464],
    [112.4841156, -7.19718027],
    [112.50231171, -7.19228315],
    [112.50460815, -7.17199707],
    [112.49777985, -7.16355133],
    [112.47883606, -7.1644001],
    [112.47015381, -7.15933418],
    [112.47609711, -7.12565517],
    [112.49647522, -7.1273737],
    [112.50144958, -7.10683107],
    [112.51794434, -7.10340261],
    [112.53591156, -7.09571314],
    [112.53095245, -7.08768511],
    [112.54786682, -7.06560183],
    [112.55238342, -7.05038881],
    [112.54059601, -7.05282402],
    [112.52472687, -7.03925371],
    [112.51400757, -7.04118729],
    [112.49839783, -7.03099632],
    [112.50691986, -7.0211072],
    [112.50593567, -7.01204538],
    [112.48716736, -7.00874805],
    [112.48087311, -7.002388],
    [112.46154022, -7.00748587],
    [112.45040894, -7.00143766],
    [112.42879486, -7.00257158],
    [112.42166901, -6.99599743],
    [112.38986969, -6.98584557],
    [112.37021637, -6.9858551],
    [112.36663818, -6.97712612],
    [112.37490082, -6.95817709],
    [112.40387726, -6.95840263],
    [112.42324829, -6.95044994],
    [112.42742157, -6.93410873],
    [112.42326355, -6.92249107],
    [112.42531586, -6.90712929],
    [112.44065857, -6.89871883],
    [112.44564056, -6.88646173],
    [112.44055939, -6.87484169],
    [112.44885254, -6.87883997],
    [112.45391846, -6.88334799],
    [112.47533417, -6.89984512],
    [112.50572205, -6.90719175],
    [112.54291534, -6.90928888],
    [112.54875946, -6.90649652],
    [112.55513763, -6.8874836],
    [112.54766083, -6.87648249],
    [112.53449249, -6.87517452],
    [112.55286407, -6.85270309],
    [112.57322693, -6.89474583],
    [112.59812927, -6.90749216],
    [112.59902191, -6.92284203],
    [112.59365845, -6.93920422],
    [112.59806824, -6.95608759],
    [112.6076889, -6.96098089],
    [112.62213135, -6.9829855],
    [112.64091492, -6.99254465],
    [112.64888763, -7.01723289],
    [112.65426636, -7.05535793],
    [112.63757324, -7.06599617],
    [112.63153076, -7.07675362],
    [112.63407898, -7.09898043],
    [112.62320709, -7.1204257],
    [112.62815094, -7.13532495],
    [112.65791321, -7.15100193],
    [112.66744995, -7.18011379],
    [112.66149139, -7.1930027],
    [112.65917206, -7.19635439],
    [112.63481903, -7.19963551],
    [112.61344147, -7.20904303],
    [112.59268951, -7.20230389],
    [112.5989151, -7.22958851],
    [112.61455536, -7.24820757],
    [112.61721039, -7.25752592],
    [112.63188171, -7.26093245],
    [112.62688446, -7.27648211],
    [112.62941742, -7.31164026],
    [112.64935303, -7.31456327],
    [112.64850616, -7.33530045],
    [112.65383148, -7.33899784],
    [112.65634155, -7.35682011],
    [112.63024139, -7.36778831],
    [112.61824036, -7.36636209],
    [112.5927124, -7.37229729],
    [112.56628418, -7.39793062],
    [112.54248047, -7.40595198],
    [112.52375031, -7.40361261],
    [112.49377441, -7.40917397],
    [112.49208069, -7.39909077],
    [112.48287201, -7.39778614],
    [112.47637939, -7.38183594],
    [112.47719574, -7.35406494],
    [112.48468018, -7.34086895],
    [112.47978973, -7.32925987],
    [112.47738647, -7.30573893],
    [112.46234894, -7.31241512],
    [112.44429016, -7.3050189],
    [112.44034576, -7.31409645],
    [112.40975189, -7.3176136],
    [112.39401245, -7.32754517],
    [112.39147186, -7.3333602],
    [112.36825562, -7.32472992]
  ];

  List<List<double>> polygonSidoarjo = [
    [112.83726370255887, -7.566480528952477],
    [112.8165206183329, -7.558917813305648],
    [112.78470604065228, -7.562778279992809],
    [112.76955353886582, -7.573585864695088],
    [112.7690151992931, -7.573855520115332],
    [112.72283027369917, -7.568798766249252],
    [112.70618431815285, -7.544932674702349],
    [112.68256546822283, -7.548573899265254],
    [112.67089097124232, -7.560773413261598],
    [112.67052521876487, -7.560774814405371],
    [112.6447616503309, -7.536817965975573],
    [112.6445460000989, -7.536759992079174],
    [112.63125599966567, -7.533225992784541],
    [112.60276225407586, -7.501311282788661],
    [112.60260078080239, -7.501148696154594],
    [112.58184318871326, -7.491911370912245],
    [112.57032500109892, -7.478124993273021],
    [112.5117420001942, -7.466801991817649],
    [112.48671435058782, -7.458960897326728],
    [112.46864300017535, -7.445290992684368],
    [112.47066327499124, -7.430545111267063],
    [112.4716200619174, -7.43003020712758],
    [112.49374267018914, -7.409200587436378],
    [112.49399560271594, -7.408981188830003],
    [112.5237503048337, -7.403612613930198],
    [112.54248355627215, -7.40595185039678],
    [112.56628678340941, -7.397930734115282],
    [112.5927123428014, -7.372297142898058],
    [112.63024133417129, -7.367788176882077],
    [112.65634340832264, -7.356820135140314],
    [112.6982989806145, -7.341501739912595],
    [112.6991742161182, -7.340649822930176],
    [112.70460233513074, -7.336239198679279],
    [112.70480957130576, -7.336236408982301],
    [112.72717775744854, -7.348411023449164],
    [112.72745506430078, -7.348456216180637],
    [112.73623648182922, -7.346255136264747],
    [112.73632701837823, -7.34616340361737],
    [112.74286918066925, -7.340994340615512],
    [112.74299520986212, -7.340832573263872],
    [112.7554091537105, -7.336743195840999],
    [112.79752442581265, -7.345279308892199],
    [112.79774086385089, -7.345259718060734],
    [112.82568351928, -7.343300163670781],
    [112.84265609510373, -7.333724724815405],
    [112.83249000131354, -7.420120000137108],
    [112.83758000041769, -7.47057000010461],
    [112.81289000127357, -7.478479999751357],
    [112.83737798300852, -7.511763028240352],
    [112.86450710092298, -7.518292983133859],
    [112.87251706021516, -7.535422994274933],
    [112.86835962929456, -7.569080633563606],
    [112.84682742324799, -7.575654809920771],
    [112.83726370255887, -7.566480528952477]
  ];

  List<List<double>> polygonSurabaya = [
    [112.82568351928, -7.343300163670781],
    [112.79774086385089, -7.345259718060734],
    [112.79752442581265, -7.345279308892199],
    [112.7554091537105, -7.336743195840999],
    [112.74299520986212, -7.340832573263872],
    [112.74286918066925, -7.340994340615512],
    [112.73632701837823, -7.34616340361737],
    [112.73623648182922, -7.346255136264747],
    [112.72745506430078, -7.348456216180637],
    [112.72717775744854, -7.348411023449164],
    [112.70480957130576, -7.336236408982301],
    [112.70460233513074, -7.336239198679279],
    [112.6991742161182, -7.340649822930176],
    [112.6982989806145, -7.341501739912595],
    [112.65634340832264, -7.356820135140314],
    [112.64850907583423, -7.335300282181488],
    [112.64934661895234, -7.314615261784136],
    [112.62941887538182, -7.31164044025332],
    [112.62862254729372, -7.289650845309447],
    [112.62861626283131, -7.289074753096605],
    [112.63185113502288, -7.260907963231092],
    [112.61720553430905, -7.257547210234742],
    [112.59538262960575, -7.219614861236038],
    [112.59811212597492, -7.211987597648721],
    [112.66147996263123, -7.193020197823052],
    [112.66834000019198, -7.220135000329209],
    [112.68608800026209, -7.225521998740422],
    [112.71413999976221, -7.216290000182546],
    [112.71928000027287, -7.204980000226056],
    [112.74332000001903, -7.194339998791131],
    [112.76479818109226, -7.196254563696367],
    [112.78001973372477, -7.208660769777911],
    [112.80654903621009, -7.255701375117563],
    [112.8363269282462, -7.267322187068485],
    [112.84641999978417, -7.307640000384882],
    [112.82687000025135, -7.333260000148066],
    [112.82568351928, -7.343300163670781]
  ];

  print('masuk sini');

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonSurabaya.length, (index) {
        return mapTool.LatLng(
            polygonSurabaya[index][1], polygonSurabaya[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonSidoarjo.length, (index) {
        return mapTool.LatLng(
            polygonSidoarjo[index][1], polygonSidoarjo[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonGresik.length, (index) {
        return mapTool.LatLng(polygonGresik[index][1], polygonGresik[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  return returnValue;
}

completeAddressFetchPrice(
  BuildContext context, {
  required Function() onSuccess,
  required OrderForm state,
}) {
  bool isCompleteAddress = false;
  int validAddressReceiver = 0;

  for (var i = 0; i < state.controller.addressReceiver.value.length; i++) {
    if (state.controller.addressReceiver.value[i] != null) {
      validAddressReceiver = validAddressReceiver + 1;
    }
  }

  if (state.controller.addressSender.value != null &&
      validAddressReceiver > 0) {
    isCompleteAddress = true;
  }

  if (isCompleteAddress) {
    List<List<double>> dataCoordinates = [];

    state.controller.addressReceiver.value.forEach((element) {
      if (element != null) {
        dataCoordinates.add([element.latitude!, element.longitude!]);
      }
    });

    dataCoordinates.add([
      state.controller.addressSender.value!.latitude!,
      state.controller.addressSender.value!.longitude!
    ]);

    double distanceTotal = 0;
    for (var i = 0; i < dataCoordinates.length - 1; i++) {
      distanceTotal += calculateDistance(
          dataCoordinates[i][0],
          dataCoordinates[i][1],
          dataCoordinates[i + 1][0],
          dataCoordinates[i + 1][1]);
    }

    EasyLoading.show(status: 'Mohon Tunggu..');

    AddressService.fetchPrice(
            id: state.controller.selectedService.value.toString(),
            totalDistance: distanceTotal.toStringAsFixed(2))
        .then((value) {
      EasyLoading.dismiss();
      if (value.status == RequestStatus.successRequest) {
        state.controller.price.value = value.data!;
        onSuccess();
      } else {
        showSnackbar(context,
            title: 'Gagal Mengambil Data Biaya', customColor: Colors.orange);
      }
    });
  } else {
    onSuccess();
  }
}

onSelectedAddress(BuildContext context,
    {required int typeAddress,
    required OrderForm state,
    int? index,
    required AddressLocal data,
    required Function() onSuccess}) {
  if (typeAddress == 0) {
    state.controller.addressSender.value = data;
  } else {
    state.controller.addressReceiver.value[index!] = data;
  }

  completeAddressFetchPrice(context, onSuccess: onSuccess, state: state);
}

class AddressFormPage extends StatefulWidget {
  final AddressLocal? address;
  final LatLng? coordinateFromSearch;
  final int typeAddress;
  final int? index;
  const AddressFormPage(
      {Key? key,
      this.address,
      this.coordinateFromSearch,
      required this.typeAddress,
      this.index})
      : super(key: key);

  static const String routeName = "/address/form";
  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressNameController = TextEditingController();

  final TextEditingController _catatanController = TextEditingController();

  TextEditingController _controllerPhoneNumber = TextEditingController();
  TextEditingController _controllerName = TextEditingController();

  bool savedLocation = false;

  AddressLocal? _currentAddress;

  // SHOW LOADING
  bool _isLoading = false;
  int _waitingTime = 2;

  // INITIAL MARKER IMAGE
  BitmapDescriptor _pinLocationIcon = BitmapDescriptor.defaultMarker;

  // GET MARKER IMAGE AS BYTE
  static Future<Uint8List> _getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);

    return data.buffer.asUint8List();
  }

  // GOOGLE MAP CONTROLLER
  final Completer<GoogleMapController> _controller = Completer();

  // INITIAL CAMERA POSITION
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2623194, 106.9780988),
    zoom: 16.00,
  );

  LatLng _myPosition = const LatLng(
    -6.262925265888677,
    106.97823701355428,
  );

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isLoading) {
        setState(() {
          _waitingTime = _waitingTime - 1;
        });
        if (_waitingTime == 0) {
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              _myPosition.latitude,
              _myPosition.longitude,
            );

            Placemark placeMark = placemarks[0];
            String? street = placeMark.street;
            String? subLocality = placeMark.subLocality;
            String? locality = placeMark.locality;
            String? administrativeArea = placeMark.administrativeArea;
            String? postalCode = placeMark.postalCode;
            String? country = placeMark.country;

            setState(() {
              _currentAddress = AddressLocal(
                name: '',
                phoneNumber: '',
                latitude: _myPosition.latitude,
                longitude: _myPosition.longitude,
                address:
                    "$street, $subLocality, $locality, $administrativeArea $postalCode, $country",
              );

              _addressController.text =
                  "$street, $subLocality, $locality, $administrativeArea $postalCode, $country";
            });
          } catch (e) {
            showSnackbar(context, title: 'Mohon Cek Koneksi Internet Anda');
          }

          _isLoading = false;
        }
      }
    });

    // INIT USER MARKER IMAGE
    _getBytesFromAsset("assets/images/Titik Awal.png").then((onValue) {
      setState(() {
        _pinLocationIcon = BitmapDescriptor.fromBytes(onValue);
      });
    });

    // INIT POSITION TO ADDRESS CONTROLLER

    if (widget.coordinateFromSearch != null) {
      setState(() {
        _myPosition = LatLng(widget.coordinateFromSearch!.latitude,
            widget.coordinateFromSearch!.longitude);
        _initialCameraPosition = CameraPosition(
          target: _myPosition,
          zoom: 16.00,
        );
        _isLoading = true;
      });
    }

    //INIT EXISTING ADDRESS
    if (widget.address != null) {
      setState(() {
        _controllerName.text = widget.address!.name;
        _controllerPhoneNumber.text = widget.address!.phoneNumber;
        _currentAddress = widget.address;
        _addressController.text = widget.address!.address;
        _myPosition =
            LatLng(widget.address!.latitude!, widget.address!.longitude!);
        _initialCameraPosition = CameraPosition(
          target: _myPosition,
          zoom: 16.00,
        );
        _catatanController.text = widget.address!.catatan ?? '';
        _addressNameController.text = widget.address!.addressName.toString();
      });
    } else {
      setState(() {
        _isLoading = true;
        _waitingTime = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.baseWhite,
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Column(
          children: [
            HeaderBar(title: 'Alamat'),

            /// SECTION: GOOGLE MAPS
            SizedBox(
              height: isKeyboardVisible ? 0 : 40.0.h,
              child: Stack(
                children: [
                  /// WIDGET: GOOGLE MAPS VIEWER
                  GoogleMap(
                    mapType: MapType.normal,
                    indoorViewEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    trafficEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    markers: <Marker>{
                      Marker(
                          draggable: false,
                          markerId: const MarkerId("Marker"),
                          anchor: const Offset(1, 1),
                          position: _myPosition,
                          icon: _pinLocationIcon,
                          onDragEnd: (newPosition) async {})
                    },
                    onLongPress: (argument) async {
                      setState(() {
                        _myPosition =
                            LatLng(argument.latitude, argument.longitude);
                      });
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        argument.latitude,
                        argument.longitude,
                      );

                      Placemark placeMark = placemarks[0];
                      String? street = placeMark.street;
                      String? subLocality = placeMark.subLocality;
                      String? locality = placeMark.locality;
                      String? administrativeArea = placeMark.administrativeArea;
                      String? postalCode = placeMark.postalCode;
                      String? country = placeMark.country;

                      setState(() {
                        _currentAddress = AddressLocal(
                          name: '',
                          phoneNumber: '',
                          latitude: argument.latitude,
                          longitude: argument.longitude,
                          address:
                              "$street, $subLocality, $locality, $administrativeArea $postalCode, $country",
                        );

                        _addressController.text =
                            "$street, $subLocality, $locality, $administrativeArea $postalCode, $country";
                      });
                    },
                    onCameraMove: (cameraPosition) async {
                      setState(() {
                        _myPosition = LatLng(cameraPosition.target.latitude,
                            cameraPosition.target.longitude);
                        _isLoading = true;
                        _waitingTime = 2;
                      });
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    // gestureRecognizers: <
                    //     Factory<OneSequenceGestureRecognizer>>{
                    //   Factory<OneSequenceGestureRecognizer>(
                    //     () => EagerGestureRecognizer(),
                    //   ),
                    // },
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
                            Position myPosition =
                                await Geolocator.getCurrentPosition();

                            setState(() {
                              _myPosition = LatLng(
                                myPosition.latitude,
                                myPosition.longitude,
                              );
                            });

                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(myPosition.latitude,
                                      myPosition.longitude),
                                  zoom: 17.00,
                                ),
                              ),
                            );

                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                              myPosition.latitude,
                              myPosition.longitude,
                            );

                            Placemark placeMark = placemarks[0];
                            String? street = placeMark.street;
                            String? subLocality = placeMark.subLocality;
                            String? locality = placeMark.locality;
                            String? administrativeArea =
                                placeMark.administrativeArea;
                            String? postalCode = placeMark.postalCode;
                            String? country = placeMark.country;

                            setState(() {
                              _currentAddress = AddressLocal(
                                name: '',
                                phoneNumber: '',
                                latitude: myPosition.latitude,
                                longitude: myPosition.longitude,
                                address:
                                    "$street, $subLocality, $locality, $administrativeArea $postalCode, $country",
                              );

                              _addressController.text =
                                  "$street, $subLocality, $locality, $administrativeArea $postalCode, $country";
                            });
                          } catch (_) {
                            showSnackbar(context,
                                title: 'Gagal Mendapatkan Posisi',
                                customColor: Colors.orange);
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

                  Positioned(
                    top: 3.0.w,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddressSearchPage(
                                    type: widget.typeAddress, fromForm: true)),
                          ).then((result) async {
                            if (result != null) {
                              final GoogleMapController controller =
                                  await _controller.future;

                              setState(() {
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: result as LatLng,
                                      zoom: 17.00,
                                    ),
                                  ),
                                );

                                _myPosition = result;
                                _isLoading = true;
                                _waitingTime = 2;
                              });
                            }
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0.w, vertical: 2.0.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black38)),
                            child: Row(
                              children: [
                                const Icon(Icons.search),
                                SizedBox(width: 2.0.w),
                                Text(
                                  'Cari Alamat..',
                                  style: FontTheme.regularBaseFont.copyWith(
                                      fontSize: 11.0.sp, color: Colors.black54),
                                )
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0.w),
                      Text(
                        "Silahkan tahan dan lepas pin point pada lokasi untuk mendapatkan alamat",
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.sp,
                          color: ColorPallette.baseGrey,
                        ),
                      ),
                      SizedBox(
                        height: 5.0.w,
                      ),
                      Text(
                        "Nama Alamat",
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 3.0.w),
                      InputField(
                        hintText: "Contoh : Rumah, Kantor dll",
                        onChanged: (value) {},
                        controller: _addressNameController,
                        borderType: "solid",
                        verticalPadding: 4.0.w,
                        maxLines: 1,
                      ),

                      SizedBox(height: 5.0.w),
                      Text(
                        "Alamat",
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: 3.0.w),

                      /// WIDGET: ADDRESS TEXT FIELD
                      InputField(
                        hintText: "Alamat Lokasi",
                        onChanged: (value) {},
                        controller: _addressController,
                        borderType: "solid",
                        verticalPadding: 4.0.w,
                        maxLines: 3,
                      ),

                      SizedBox(height: 5.0.w),
                      Text(
                        "Petunjuk Alamat / Detail Alamat",
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 3.0.w),
                      InputField(
                        hintText: "Petunjuk Alamat / Detail Alamat",
                        onChanged: (value) {},
                        controller: _catatanController,
                        borderType: "solid",
                        verticalPadding: 4.0.w,
                        maxLines: 3,
                      ),

                      SizedBox(height: 5.0.w),
                      Text(
                        "Nama",
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 3.0.w),
                      InputField(
                        hintText: "Masukkan Nama Anda",
                        controller: _controllerName,
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            try {
                              PhoneContact contact =
                                  await FlutterContactPicker.pickPhoneContact();
                              setState(() {
                                _controllerName.text = contact.fullName!;
                                _controllerPhoneNumber.text =
                                    contact.phoneNumber!.number!;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Icon(
                            Icons.contacts_rounded,
                            color: Colors.black54,
                          ),
                        ),
                        borderType: "solid",
                        verticalPadding: 4.0.w,
                        onChanged: (value) {
                          // checkoutProvider.setSenderName(value ?? "");
                        },
                      ),
                      SizedBox(height: 5.0.w),
                      Text(
                        "Nomor Telepon",
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: 3.0.w),
                      InputField(
                        hintText: "Masukkan Nomor Telepon Anda",
                        controller: _controllerPhoneNumber,
                        inputFormatter: MaskedInputFormatter(
                          '####-####-#####',
                          allowedCharMatcher: RegExp(r'[0-9]'),
                        ),
                        borderType: "solid",
                        verticalPadding: 4.0.w,
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            try {
                              PhoneContact contact =
                                  await FlutterContactPicker.pickPhoneContact();
                              setState(() {
                                _controllerName.text = contact.fullName!;
                                _controllerPhoneNumber.text =
                                    contact.phoneNumber!.number!;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Icon(
                            Icons.contacts_rounded,
                            color: Colors.black54,
                          ),
                        ),
                        onChanged: (value) {
                          // checkoutProvider.setSenderName(value ?? "");
                        },
                      ),
                      SizedBox(height: 5.0.w),
                      widget.address != null
                          ? Container()
                          : Row(
                              children: [
                                SizedBox(
                                  width: 7.0.w,
                                  height: 7.0.w,
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: ColorPallette.baseBlack,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    value: savedLocation,
                                    activeColor: ColorPallette.baseBlack,
                                    focusColor: ColorPallette.baseBlack,
                                    onChanged: (value) {
                                      setState(() {
                                        savedLocation = value!;
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
                                      savedLocation = !savedLocation;
                                    });
                                  },
                                  child: Text(
                                    "Simpan Alamat",
                                    style: FontTheme.regularBaseFont.copyWith(
                                      color: ColorPallette.baseBlack,
                                      fontSize: 12.0.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),

                      SizedBox(height: 10.0.w),

                      /// WIDGET: SAVE ADDRESS BUTTON
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                width: 6.0.w,
                                height: 6.0.w,
                                child: const CircularProgressIndicator(
                                  color: ColorPallette.baseBlue,
                                ),
                              ),
                            )
                          : CustomButton(
                              onTap: () async {
                                if (_currentAddress != null) {
                                  bool isSuccessRequest = true;
                                  AddressLocal data = AddressLocal(
                                      id: widget.address == null
                                          ? 0
                                          : widget.address!.id,
                                      addressName: _addressNameController.text,
                                      catatan: _catatanController.text,
                                      address: _addressController.text,
                                      name: _controllerName.text,
                                      phoneNumber: _controllerPhoneNumber.text,
                                      latitude: _myPosition.latitude,
                                      longitude: _myPosition.longitude);

                                  //validasi kuy
                                  String validation = '';
                                  if (_controllerPhoneNumber.text.isEmpty) {
                                    validation =
                                        'Mohon Mengisi Nomor telepon Pemilik Alamat';
                                  }

                                  if (_controllerName.text.isEmpty) {
                                    validation =
                                        'Mohon Mengisi Nama Pemilik Alamat';
                                  }

                                  if (_addressNameController.text.isEmpty) {
                                    validation = 'Mohon Mengisi Nama Alamat';
                                  }

                                  if (data.latitude.toString() == '0' ||
                                      data.latitude.toString().isEmpty) {
                                    validation =
                                        'Koordinat tidak valid silahkan geser pin untuk refresh data koordinat';
                                  }

                                  if (data.longitude.toString() == '0' ||
                                      data.longitude.toString().isEmpty) {
                                    validation =
                                        'Koordinat tidak valid silahkan geser pin untuk refresh data koordinat';
                                  }

                                  if (validation.isEmpty) {
                                    if (widget.address != null) {
                                      EasyLoading.show(
                                          status: 'Mohon Tunggu..');
                                      UserState userState =
                                          BlocProvider.of<UserCubit>(context)
                                              .state;
                                      if (userState is UserLogged) {
                                        UserState userState =
                                            BlocProvider.of<UserCubit>(context)
                                                .state;
                                        if (userState is UserLogged) {
                                          EasyLoading.show(
                                              status: 'Mohon Tunggu..');
                                          ApiReturnValue<dynamic>? value =
                                              await AddressService
                                                  .updateAddress(
                                            address: data.address,
                                            type: widget.typeAddress.toString(),
                                            id: widget.address!.id.toString(),
                                            addressName:
                                                _addressNameController.text,
                                            lat: data.latitude.toString(),
                                            lon: data.longitude.toString(),
                                            note: _catatanController.text,
                                            owner: _controllerName.text,
                                            phoneNumber:
                                                _controllerPhoneNumber.text,
                                          );
                                          EasyLoading.dismiss();
                                          if (value.status !=
                                              RequestStatus.successRequest) {
                                            showSnackbar(context,
                                                title: 'Gagal Update Alamat',
                                                customColor: Colors.orange);
                                          } else {
                                            Navigator.pop(context);
                                            showSnackbar(context,
                                                title: 'Berhasil Update Alamat',
                                                customColor: Colors.green);
                                          }
                                        }
                                      }
                                    } else {
                                      if (savedLocation) {
                                        UserState userState =
                                            BlocProvider.of<UserCubit>(context)
                                                .state;
                                        if (userState is UserLogged) {
                                          EasyLoading.show(
                                              status: 'Mohon Tunggu..');
                                          ApiReturnValue<dynamic>? value =
                                              await AddressService.postAddress(
                                            address: data.address,
                                            type: widget.typeAddress.toString(),
                                            idUser:
                                                userState.user.id.toString(),
                                            addressName:
                                                _addressNameController.text,
                                            lat: data.latitude.toString(),
                                            lon: data.longitude.toString(),
                                            note: _catatanController.text,
                                            owner: _controllerName.text,
                                            phoneNumber:
                                                _controllerPhoneNumber.text,
                                          );
                                          EasyLoading.dismiss();
                                          if (value.status !=
                                              RequestStatus.successRequest) {
                                            isSuccessRequest = false;
                                            showSnackbar(context,
                                                title: 'Gagal Menyimpan Alamat',
                                                customColor: Colors.orange);
                                          } else {
                                            showSnackbar(context,
                                                title:
                                                    'Berhasil Menyimpan Alamat',
                                                customColor: Colors.green);
                                          }
                                        }
                                      }

                                      if (isSuccessRequest) {
                                        OrderFormstate state =
                                            BlocProvider.of<OrderFormCubit>(
                                                    context)
                                                .state;

                                        if (state is OrderForm) {
                                          onSelectedAddress(context, data: data,
                                              onSuccess: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                              state: state,
                                              typeAddress: widget.typeAddress,
                                              index: widget.index);
                                        }
                                      }
                                    }
                                  } else {
                                    showSnackbar(context,
                                        title: validation,
                                        customColor: Colors.orange);
                                  }
                                } else {
                                  showSnackbar(context,
                                      title:
                                          "Harap Tentukan Lokasi Terlebih Dahulu",
                                      customColor: Colors.orange);
                                }
                              },
                              pressAble: true,
                              text: widget.address != null
                                  ? 'Update Alamat'
                                  : "Simpan Alamat",
                            ),
                      SizedBox(height: 10.0.w),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
