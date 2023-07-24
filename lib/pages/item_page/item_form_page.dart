part of '../pages.dart';

class ItemFormPage extends StatefulWidget {
  final ItemModel? data;
  const ItemFormPage({Key? key, this.data}) : super(key: key);

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerWeight = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      setState(() {
        _controllerName.text = widget.data!.name;
        _controllerWeight.text = widget.data!.weight.toString();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(children: [
      HeaderBar(
        title: "Item Form",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              children: [
            SizedBox(
              height: 5.0.w,
            ),
            Text(
              "Nama",
              style: FontTheme.boldBaseFont.copyWith(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3.0.w),
            InputField(
              hintText: "Masukkan Nama Item",
              controller: _controllerName,
              borderType: "solid",
              verticalPadding: 3.0.w,
              onChanged: (value) {
                // checkoutProvider.setSenderName(value ?? "");
              },
            ),
            SizedBox(
              height: 5.0.w,
            ),
            Text(
              "Berat",
              style: FontTheme.boldBaseFont.copyWith(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3.0.w),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    hintText: "Masukkan Berat Item",
                    keyboardType: TextInputType.number,
                    controller: _controllerWeight,
                    borderType: "solid",
                    verticalPadding: 3.0.w,
                    onChanged: (value) {
                      // checkoutProvider.setSenderName(value ?? "");
                    },
                  ),
                ),
                SizedBox(width: 3.0.w),
                const Text(
                  'KG',
                  style: FontTheme.boldBaseFont,
                )
              ],
            ),
            SizedBox(height: 10.0.w),
            CustomButton(
                onTap: () {
                  UserState userState =
                      BlocProvider.of<UserCubit>(context).state;
                  if (userState is UserLogged) {
                    yesOrNoDialog(context,
                            title: 'Simpan Item',
                            desc: 'Apakah Anda yakin untuk menyimpan Item?')
                        .then((value) {
                      if (value) {
                        if (widget.data == null) {
                          EasyLoading.show(status: 'Mohon Tunggu..');
                          ItemService.postItem(
                                  idUser: userState.user.id.toString(),
                                  nameItem: _controllerName.text,
                                  weightItem: _controllerWeight.text)
                              .then((value) {
                            EasyLoading.dismiss();
                            if (value.status == RequestStatus.successRequest) {
                              showSnackbar(context,
                                  title: 'Berhasil Menyimpan Item',
                                  customColor: Colors.green);
                              Navigator.pop(context, true);
                            } else {
                              showSnackbar(context,
                                  title: 'Gagal Menyimpan Item',
                                  customColor: Colors.orange);
                            }
                          });
                        } else {
                          EasyLoading.show(status: 'Mohon Tunggu..');
                          ItemService.updateItem(
                                  id: widget.data!.id.toString(),
                                  nameItem: _controllerName.text,
                                  weightItem: _controllerWeight.text)
                              .then((value) {
                            EasyLoading.dismiss();
                            if (value.status == RequestStatus.successRequest) {
                              showSnackbar(context,
                                  title: 'Berhasil Menyimpan Item',
                                  customColor: Colors.green);
                              Navigator.pop(context, true);
                            } else {
                              showSnackbar(context,
                                  title: 'Gagal Menyimpan Item',
                                  customColor: Colors.orange);
                            }
                          });
                        }
                      }
                    });
                  }
                },
                text: 'Simpan',
                pressAble: true),
            SizedBox(height: 10.0.w),
          ]))
    ]);
  }
}
