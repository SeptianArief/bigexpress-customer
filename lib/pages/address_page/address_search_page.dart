part of '../pages.dart';

class AddressSearchPage extends StatefulWidget {
  final int type;
  final bool fromForm;
  final int? index;
  const AddressSearchPage(
      {Key? key, required this.type, this.index, required this.fromForm})
      : super(key: key);

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  // ignore: unused_field
  String _currentKeyword = "";
  FocusNode searchFocusNode = FocusNode();
  List<Suggestion> _suggestions = [];

  bool _showLoad = false;

  @override
  void initState() {
    setState(() {
      searchFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.baseWhite,
      body: Column(
        children: [
          HeaderBar(title: 'Cari Alamat'),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: InputField(
                          hintText: "Cari Alamat",
                          focus: searchFocusNode,
                          controller: _searchController,
                          borderType: "solid",
                          onChanged: (value) {
                            MapsService.getSuggestions(value ?? "", "id")
                                .then((suggestions) {
                              setState(() {
                                _currentKeyword = value!;
                                _suggestions = suggestions;
                              });
                            });
                          },
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController.text = "";
                                      _currentKeyword = "";
                                      _suggestions = [];
                                    });
                                  },
                                  child: RotationTransition(
                                    turns:
                                        const AlwaysStoppedAnimation(45 / 360),
                                    child: Icon(
                                      Icons.add_circle,
                                      size: 6.0.w,
                                      color: ColorPallette.baseBlack
                                          .withOpacity(0.75),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      /// WIDGET: SEARCH FIELD

                      /// WIDGET: PICK LOCATION BUTTON
                      // TouchableOpacity(
                      //   child: Container(
                      //     width: 46.r,
                      //     height: 46.r,
                      //     decoration: BoxDecoration(
                      //       color: ColorPallette.baseBlue,
                      //       borderRadius: BorderRadius.circular(10.r),
                      //     ),
                      //     child: Center(
                      //       child: Icon(
                      //         Icons.location_on_outlined,
                      //         color: ColorPallette.baseWhite,
                      //         size: 24.r,
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () async {
                      //     if (await Geolocator.isLocationServiceEnabled()) {
                      //       Navigator.pushNamed(
                      //         context,
                      //         PickLocationScreen.routeName,
                      //         arguments: widget.type,
                      //       );
                      //     } else {
                      //       Fluttertoast.showToast(
                      //         msg: "Harap Nyalakan GPS Anda",
                      //         gravity: ToastGravity.BOTTOM,
                      //       );
                      //     }
                      //   },
                      // ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5.w,
                      ),

                      /// WIDGET: LIST TITLE
                      if (_suggestions.isNotEmpty)
                        Text(
                          "Alamat Yang Disarankan",
                          style: FontTheme.semiBoldBaseFont.copyWith(
                            fontSize: 13.sp,
                            color: ColorPallette.baseBlue,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_showLoad)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: const CircularProgressIndicator(
                            color: ColorPallette.baseBlue,
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  )
                else
                  Column(
                    children: _suggestions
                        .map(
                          (value) => RecommendAddressCard(
                            address: value.description,
                            onSelect: () async {
                              _onAddressSelected(value);
                            },
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAddressSelected(Suggestion address) async {
    setState(() {
      _showLoad = true;
    });

    final Map<String, dynamic> coordinate =
        await MapsService.getDetailSuggestion(
      address.placeId,
    );

    if (!widget.fromForm) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AddressFormPage(
                    index: widget.index,
                    typeAddress: widget.type,
                    coordinateFromSearch:
                        LatLng(coordinate['lat'], coordinate['lng']),
                  )));
    } else {
      Navigator.pop(context, LatLng(coordinate['lat'], coordinate['lng']));
    }

    // if (widget.id != null) {
    //   OrderService.updateAdress(
    //     type: widget.type.toLowerCase(),
    //     contactPerson: "",
    //     address: Address(
    //       id: widget.id,
    //       address: address.description,
    //       latitude: coordinate['lat'],
    //       longitude: coordinate['lng'],
    //     ),
    //   ).then((_) {
    //     Navigator.pop(context);

    //     Navigator.pushReplacementNamed(
    //       context,
    //       AddressListScreen.routeName,
    //     );
    //   });
    // } else {
    //   OrderService.storeAdress(
    //     type: widget.type.toLowerCase(),
    //     contactPerson: "",
    //     address: Address(
    //       address: address.description,
    //       latitude: coordinate['lat'],
    //       longitude: coordinate['lng'],
    //     ),
    //   ).then((_) {
    //     Navigator.pop(context);

    //     Navigator.pushReplacementNamed(
    //       context,
    //       AddressListScreen.routeName,
    //     );
    //   });
    // }
  }
}

class RecommendAddressCard extends StatelessWidget {
  final String address;
  final void Function()? onSelect;

  const RecommendAddressCard({
    Key? key,
    required this.address,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 3.0.w,
          ),

          /// WIDGET: ADDRESS TEXT
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0.w,
            ),
            child: Text(
              address,
              style: FontTheme.regularBaseFont.copyWith(
                fontSize: 10.sp,
              ),
            ),
          ),
          SizedBox(
            height: 3.0.w,
          ),

          /// WIDGET: BOTTOM DIVIDER
          Container(width: double.infinity, height: 1, color: Colors.black12)
        ],
      ),
    );
  }
}
