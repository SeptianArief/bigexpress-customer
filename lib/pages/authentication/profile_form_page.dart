part of '../pages.dart';

class ProfileFormPage extends StatefulWidget {
  final bool isNewMember;
  final String phoneNumber;
  const ProfileFormPage(
      {Key? key, required this.isNewMember, this.phoneNumber = ''})
      : super(key: key);

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? cityController;
  String? idUser;
  TextEditingController emailController = TextEditingController();
  UtilCubit cityCubit = UtilCubit();

  @override
  void initState() {
    cityCubit.fetchCity();
    setState(() {
      phoneNumberController.text = widget.phoneNumber;
    });

    if (widget.isNewMember == false) {
      UserState userState = BlocProvider.of<UserCubit>(context).state;
      if (userState is UserLogged) {
        setState(() {
          idUser = userState.user.id.toString();
          phoneNumberController.text = userState.user.phoneNumber;
          nameController.text = userState.user.name;
          cityController = userState.user.city;
          emailController.text = userState.user.email;
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UtilCubit, UtilState>(
        bloc: cityCubit,
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                HeaderBar(
                    title:
                        widget.isNewMember ? 'Daftar Pengguna baru' : 'Profil'),
                Expanded(
                    child: state is UtilLoading
                        ? Center(child: CircularProgressIndicator())
                        : state is CityLoaded
                            ? ListView(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5.0.w),
                                children: [
                                  SizedBox(height: 5.0.w),
                                  Text(
                                    'Nomor Handphone',
                                    style: FontTheme.semiBoldBaseFont.copyWith(
                                      color: ColorPallette.baseYellow,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 2.0.w),
                                  InputField(
                                    borderType: 'solid',
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {},
                                    hintText: 'Nomor Handphone',
                                    controller: phoneNumberController,
                                    enabled: false,
                                    // isError: validationProvider.errorPhoneNumber.isNotEmpty,
                                    inputFormatter: MaskedInputFormatter(
                                      '####-####-#####',
                                      allowedCharMatcher: RegExp(r'[0-9]'),
                                    ),
                                  ),
                                  SizedBox(height: 5.0.w),
                                  Text(
                                    'Email',
                                    style: FontTheme.semiBoldBaseFont.copyWith(
                                      color: ColorPallette.baseYellow,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 2.0.w),
                                  InputField(
                                    borderType: 'solid',
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {},
                                    hintText: 'Email',
                                    controller: emailController,
                                  ),
                                  SizedBox(height: 5.0.w),
                                  Text(
                                    'Nama',
                                    style: FontTheme.semiBoldBaseFont.copyWith(
                                      color: ColorPallette.baseYellow,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 2.0.w),
                                  InputField(
                                    borderType: 'solid',
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {},
                                    hintText: 'Nama',
                                    controller: nameController,
                                  ),
                                  SizedBox(height: 5.0.w),
                                  Text(
                                    'Kota',
                                    style: FontTheme.semiBoldBaseFont.copyWith(
                                      color: ColorPallette.baseYellow,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 2.0.w),
                                  GestureDetector(
                                    onTap: () async {
                                      String? result =
                                          await showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20))),
                                              builder: (context) {
                                                return CityDialog(
                                                  dataCity: state.data,
                                                );
                                              });

                                      if (result != null) {
                                        setState(() {
                                          cityController = result;
                                        });
                                      }
                                    },
                                    child: DropdownWidget(
                                        hintText: 'Kota Anda',
                                        value: cityController),
                                  ),
                                  SizedBox(height: 10.0.w),
                                  CustomButton(
                                      onTap: () {
                                        if (widget.isNewMember) {
                                          yesOrNoDialog(context,
                                                  title: 'Registrasi',
                                                  desc:
                                                      'Apakah Anda yakin untuk melakukan registrasi?')
                                              .then((value) {
                                            if (value) {
                                              BlocProvider.of<UserCubit>(
                                                      context)
                                                  .register(context,
                                                      phoneNumber:
                                                          phoneNumberController
                                                              .text,
                                                      email:
                                                          emailController.text,
                                                      name: nameController.text,
                                                      city: cityController!,
                                                      token: '123123123');
                                            }
                                          });
                                        } else {
                                          yesOrNoDialog(context,
                                                  title: 'Update Profile',
                                                  desc:
                                                      'Apakah Anda yakin untuk menyimpan data profil?')
                                              .then((value) {
                                            if (value) {
                                              UserState userState =
                                                  BlocProvider.of<UserCubit>(
                                                          context)
                                                      .state;
                                              if (userState is UserLogged) {
                                                EasyLoading.show(
                                                    status: 'Mohon Tunggu');
                                                AuthService.updateProfile(
                                                        email: emailController
                                                            .text,
                                                        name:
                                                            nameController.text,
                                                        city: cityController!,
                                                        id: userState.user.id
                                                            .toString())
                                                    .then((valueAPI) {
                                                  EasyLoading.dismiss();
                                                  if (valueAPI.status ==
                                                      RequestStatus
                                                          .successRequest) {
                                                    BlocProvider.of<UserCubit>(
                                                            context)
                                                        .refreshProfile(
                                                            id: userState
                                                                .user.id
                                                                .toString());
                                                    showSnackbar(context,
                                                        title:
                                                            'Berhasil Update Profil');
                                                    Navigator.pop(context);
                                                  } else {
                                                    showSnackbar(context,
                                                        title:
                                                            'Gagal Update Profil',
                                                        customColor:
                                                            Colors.orange);
                                                  }
                                                });
                                              }
                                            }
                                          });
                                        }
                                      },
                                      text: 'Simpan',
                                      pressAble: true),
                                  SizedBox(height: 10.0.w)
                                ],
                              )
                            : Container())
              ],
            ),
          );
        });
  }
}

class CityDialog extends StatefulWidget {
  final List<CityModel> dataCity;
  const CityDialog({Key? key, required this.dataCity}) : super(key: key);

  @override
  State<CityDialog> createState() => _CityDialogState();
}

class _CityDialogState extends State<CityDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Kota',
                style: FontTheme.boldBaseFont.copyWith(
                    fontSize: 13.0.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
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
          children: List.generate(widget.dataCity.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, widget.dataCity[index].name);
              },
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                padding:
                    EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
                child: Text(
                  widget.dataCity[index].name,
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 12.0.sp, color: Colors.black87),
                ),
              ),
            );
          }),
        ))
      ],
    );
  }
}
