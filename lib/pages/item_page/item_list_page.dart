part of '../pages.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key}) : super(key: key);

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  ItemCubit itemCubit = ItemCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      itemCubit.fetchItem(userState.user.id.toString());
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
        HeaderBar(title: 'Item'),
        BlocBuilder<ItemCubit, ItemState>(
            bloc: itemCubit,
            builder: (context, state) {
              if (state is ItemLoading) {
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
              } else if (state is ItemLoaded) {
                return Expanded(
                    child: state.data.isEmpty
                        ? Center(
                            child: Text(
                              'Item Kosong',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 12.0.sp, color: Colors.black54),
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            children: List.generate(state.data.length, (index) {
                              return PickItem(
                                  name: state.data[index].name,
                                  onSelect: () {
                                    OrderFormstate stateOrder =
                                        BlocProvider.of<OrderFormCubit>(context)
                                            .state;

                                    if (stateOrder is OrderForm) {
                                      stateOrder.controller.selectedItem.value =
                                          state.data[index];
                                      Navigator.pop(context);
                                    }
                                  },
                                  onDelete: () {
                                    yesOrNoDialog(context,
                                            title: 'Hapus Item',
                                            desc:
                                                'Apakah Anda yakin untuk menghapus item ini?')
                                        .then((value) {
                                      if (value) {
                                        EasyLoading.show(
                                            status: 'Mohon Tunggu');
                                        ItemService.deleteItem(
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
                                              itemCubit.fetchItem(
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
                                    bool? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ItemFormPage(
                                                  data: state.data[index],
                                                )));

                                    if (result != null) {
                                      UserState userState =
                                          BlocProvider.of<UserCubit>(context)
                                              .state;
                                      if (userState is UserLogged) {
                                        itemCubit.fetchItem(
                                            userState.user.id.toString());
                                      }
                                    }
                                  },
                                  category: '',
                                  weight: state.data[index].weight.toString(),
                                  capacity: '');
                            })));
              } else {
                return Expanded(
                  child: FailedRequest(
                    verticalMargin: 20.0.w,
                    onTap: () {
                      UserState userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if (userState is UserLogged) {
                        UserState userState =
                            BlocProvider.of<UserCubit>(context).state;
                        if (userState is UserLogged) {
                          itemCubit.fetchItem(userState.user.id.toString());
                        }
                      }
                    },
                  ),
                );
              }
            }),
        GestureDetector(
          onTap: () async {
            bool? result = await Navigator.push(
                context, MaterialPageRoute(builder: (_) => ItemFormPage()));

            if (result != null) {
              UserState userState = BlocProvider.of<UserCubit>(context).state;
              if (userState is UserLogged) {
                itemCubit.fetchItem(userState.user.id.toString());
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 4.0.w,
            ),
            width: double.infinity,
            color: ColorPallette.baseBlue,
            alignment: Alignment.center,
            child: Text('+ Tambah Item Baru',
                style: FontTheme.regularBaseFont.copyWith(
                  fontSize: 12.0.sp,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}

class PickItem extends StatelessWidget {
  final String name;
  final String category;
  final String weight;
  final String capacity;
  final void Function()? onSelect;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const PickItem({
    Key? key,
    required this.name,
    required this.category,
    required this.weight,
    required this.capacity,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
      margin: EdgeInsets.only(
        top: 3.0.w,
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
          GestureDetector(
            onTap: onSelect,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// WIDGET: ITEM NAME
                Text(
                  name,
                  style: FontTheme.boldBaseFont.copyWith(
                    fontSize: 11.sp,
                    color: ColorPallette.baseBlue,
                  ),
                ),
                SizedBox(
                  height: 3.0.w,
                ),

                /// WIDGET: ITEM WEIGHT
                Text(
                  weight + ' KG',
                  style: FontTheme.regularBaseFont.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Row(
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
                    Icon(
                      Icons.edit_outlined,
                      color: ColorPallette.baseWhite,
                      size: 11.0.sp,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),

                    /// WIDGET: EDIT TEXT
                    Text(
                      "Edit",
                      style: FontTheme.boldBaseFont.copyWith(
                        fontSize: 9.sp,
                        color: ColorPallette.baseWhite,
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                width: 3.w,
              ),

              /// WIDGET: DELETE BUTTON
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  primary: ColorPallette.baseWhite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.0.w,
                    vertical: 2.0.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: ColorPallette.baseBlue, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    /// WIDGET: DELETE ICON
                    Icon(
                      Icons.delete_forever,
                      color: ColorPallette.baseBlue,
                      size: 11.0.sp,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),

                    /// WIDGET: DELETE TEXT
                    Text(
                      "Hapus",
                      style: FontTheme.boldBaseFont.copyWith(
                        fontSize: 9.sp,
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
    );
  }
}
