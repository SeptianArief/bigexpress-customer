part of '../pages.dart';

class AddressListPage extends StatefulWidget {
  final int type;
  final bool onSelectActive;
  final int? index;
  const AddressListPage(
      {Key? key, this.index, required this.type, this.onSelectActive = false})
      : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  AddressCubit addressCubit = AddressCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      addressCubit.fetchAddress(
          widget.type.toString(), userState.user.id.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: [
        HeaderBar(
            title:
                widget.type == 0 ? 'Alamat Pengambilan' : 'Alamat Pengiriman'),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddressSearchPage(
                                type: widget.type,
                                fromForm: false,
                                index: widget.index)));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: 3.0.w, horizontal: 5.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black38)),
                    child: Text(
                      'Cari Alamat..',
                      style: FontTheme.regularBaseFont
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.0.w),
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(status: 'Mohon Tunggu..');
                  Position myPosition = await Geolocator.getCurrentPosition();
                  EasyLoading.dismiss();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddressFormPage(
                                typeAddress: widget.type,
                                index: widget.index,
                                coordinateFromSearch: LatLng(
                                    myPosition.latitude, myPosition.longitude),
                              )));
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 3.0.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorPallette.baseBlue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 5.0.w),
                      SizedBox(width: 1.0.w),
                      Text(
                        'Peta',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<AddressCubit, AddressState>(
            bloc: addressCubit,
            builder: (context, state) {
              if (state is AddressLoading) {
                return Expanded(
                    child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  children: List.generate(8, (index) {
                    return PlaceHolder(
                      child: Container(
                        width: 90.0.w,
                        height: 20.0.w,
                        margin:
                            EdgeInsets.only(top: index == 0 ? 3.0.w : 2.0.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      ),
                    );
                  }),
                ));
              } else if (state is AddressLoaded) {
                return Expanded(
                    child: state.data.isEmpty
                        ? Center(
                            child: Text(
                              'Alamat Kosong',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 12.0.sp, color: Colors.black54),
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            children: List.generate(state.data.length, (index) {
                              return PickAddress(
                                  address: state.data[index].address,
                                  onSelect: () {
                                    OrderFormstate stateOrder =
                                        BlocProvider.of<OrderFormCubit>(context)
                                            .state;

                                    if (stateOrder is OrderForm) {
                                      onSelectedAddress(context,
                                          data: state.data[index],
                                          onSuccess: () {
                                        Navigator.pop(context);
                                      },
                                          state: stateOrder,
                                          typeAddress: widget.type,
                                          index: widget.index);
                                    }
                                  },
                                  onDelete: () {
                                    yesOrNoDialog(context,
                                            title: 'Hapus Alamat',
                                            desc:
                                                'Apakah Anda yakin untuk menghapus Alamat ini?')
                                        .then((value) {
                                      if (value) {
                                        EasyLoading.show(
                                            status: 'Mohon Tunggu');

                                        print(state.data[index].id.toString());
                                        print(widget.type);
                                        AddressService.deleteAddress(
                                                type: widget.type.toString(),
                                                id: state.data[index].id
                                                    .toString())
                                            .then((value) {
                                          EasyLoading.dismiss();
                                          if (value.status ==
                                              RequestStatus.successRequest) {
                                            showSnackbar(context,
                                                title:
                                                    'Berhasil Menghapus Item',
                                                customColor: Colors.green);
                                            UserState userState =
                                                BlocProvider.of<UserCubit>(
                                                        context)
                                                    .state;
                                            if (userState is UserLogged) {
                                              addressCubit.fetchAddress(
                                                  widget.type.toString(),
                                                  userState.user.id.toString());
                                            }
                                          } else {
                                            showSnackbar(context,
                                                title: 'Gagal Menghapus Item',
                                                customColor: Colors.orange);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  onEdit: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AddressFormPage(
                                                  typeAddress: widget.type,
                                                  address: state.data[index],
                                                )));

                                    UserState userState =
                                        BlocProvider.of<UserCubit>(context)
                                            .state;
                                    if (userState is UserLogged) {
                                      addressCubit.fetchAddress(
                                          widget.type.toString(),
                                          userState.user.id.toString());
                                    }
                                  },
                                  name: state.data[index].addressName ?? '-',
                                  id: state.data[index].id == null
                                      ? ''
                                      : state.data[index].id.toString());
                            })));
              } else {
                return FailedRequest(
                  onTap: () {
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      addressCubit.fetchAddress(
                          widget.type.toString(), userState.user.id.toString());
                    }
                  },
                );
              }
            })
        // Expanded(child: )
      ],
    );
  }
}

class PickAddress extends StatelessWidget {
  final String address;
  final String name;
  final String id;
  final void Function()? onSelect;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const PickAddress({
    Key? key,
    required this.address,
    required this.name,
    required this.id,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.fromLTRB(24 17 24 12.r),
      padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
      margin: EdgeInsets.only(
        top: 3.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0.4,
          color: ColorPallette.baseBlack.withOpacity(0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// WIDGET: ADDRESS TEXT
          Expanded(
            child: GestureDetector(
              onTap: onSelect,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 1.0.w),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// WIDGET: EDIT BUTTON
                      ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          primary: ColorPallette.baseBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w,
                            vertical: 2.0.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            /// WIDGET: EDIT ICON
                            Icon(Icons.edit_outlined,
                                color: ColorPallette.baseWhite, size: 10.0.sp),
                            SizedBox(
                              width: 1.0.w,
                            ),

                            /// WIDGET: EDIT TEXT
                            Text(
                              "Edit",
                              style: FontTheme.boldBaseFont.copyWith(
                                fontSize: 10.sp,
                                color: ColorPallette.baseWhite,
                              ),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),

                      /// WIDGET: DELETE BUTTON
                      ElevatedButton(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          primary: ColorPallette.baseWhite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0.w, vertical: 2.0.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: ColorPallette.baseBlue, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            /// WIDGET: DELETE ICON
                            Icon(Icons.delete_forever,
                                color: ColorPallette.baseBlue, size: 10.0.sp),
                            SizedBox(
                              width: 1.w,
                            ),

                            /// WIDGET: DELETE TEXT
                            Text(
                              "Hapus",
                              style: FontTheme.boldBaseFont.copyWith(
                                fontSize: 10.sp,
                                color: ColorPallette.baseBlue,
                              ),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
