part of '../pages.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with AutomaticKeepAliveClientMixin<AccountScreen> {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.baseWhite,
      body: Stack(
        children: [
          /// WIDGET: BACKDROP ILLUSTRATION
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Image.asset(
                "assets/images/Motor Backdrop.png",
                width: 140,
                height: 130,
              ),
            ),
          ),

          BlocBuilder<UserCubit, UserState>(
              bloc: BlocProvider.of<UserCubit>(context),
              builder: (context, state) {
                if (state is UserLogged) {
                  return ListView(
                    children: [
                      /// WIDGET: GRADIENT TOP BAR
                      Container(
                        width: 1,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              ColorPallette.baseBlue,
                              const Color(0xFFBAC8DE).withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: ColorPallette.baseWhite,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 25,
                        ),
                        child: Column(
                          children: [
                            /// WIDGET: USER INFORMATION
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/User.png",
                                  width: 12.0.w,
                                  height: 12.0.w,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.user.name,
                                      style: FontTheme.boldBaseFont.copyWith(
                                        fontSize: 14.sp,
                                        color: ColorPallette.baseBlue,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      state.user.phoneNumber
                                      // Storages.hasStorage('token') &&
                                      //         Provider.of<UserProvider>(
                                      //               context,
                                      //               listen: false,
                                      //             ).user.name !=
                                      //             null
                                      //     ? Storages.readStorage('phone') ??
                                      //         "xxxxxxxxxxxx"
                                      //     : "xxxxxxxxxxxx",
                                      ,
                                      style: FontTheme.regularBaseFont.copyWith(
                                        fontSize: 11.sp,
                                        color: ColorPallette.baseGrey,
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                                const SizedBox(),
                              ],
                            ),

                            SizedBox(
                              height: 10.w,
                            ),

                            /// WIDGET: ACCOUNT OPTION 1
                            AccountOption(
                              iconSize: 7.0.w,
                              iconPath: "assets/images/Akun.png",
                              title: "Profil Anda",
                              subtitle: "Atur Profil Anda",
                              currentValue: null,
                              onTap: () {
                                // if (Storages.hasStorage('token') &&
                                //     Provider.of<UserProvider>(
                                //           context,
                                //           listen: false,
                                //         ).user.name !=
                                //         null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProfileFormPage(
                                            isNewMember: false)));
                                // } else {
                                //   Fluttertoast.showToast(
                                //     msg: "Silahkan Login Terlebih Dahulu",
                                //     gravity: ToastGravity.BOTTOM,
                                //   );
                                // }
                              },
                            ),

                            /// WIDGET: ACCOUNT OPTION 3
                            AccountOption(
                              iconSize: 7.0.w,
                              iconPath: "assets/images/Daftar Item.png",
                              title: "Daftar Item",
                              subtitle: "Atur Daftar Item",
                              currentValue: null,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ItemListPage()));
                              },
                            ),

                            /// WIDGET: ACCOUNT OPTION 4
                            AccountOption(
                              iconSize: 7.0.w,
                              iconPath: "assets/images/Daftar Alamat.png",
                              title: "Daftar Alamat Pengambilan",
                              subtitle: "Atur Daftar Alamat Pengambilan",
                              currentValue: null,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AddressListPage(type: 0)));
                              },
                            ),

                            /// WIDGET: ACCOUNT OPTION 5
                            AccountOption(
                              iconSize: 7.0.w,
                              iconPath: "assets/images/Daftar Alamat.png",
                              title: "Atur Daftar Alamat Pengiriman",
                              subtitle: "Atur Daftar Alamat Pengiriman",
                              currentValue: null,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AddressListPage(type: 1)));
                              },
                            ),

                            /// WIDGET: Term
                            AccountOption(
                              iconSize: 7.0.w,
                              iconPath: "assets/images/Order Sukses.png",
                              title: "Syarat dan Ketentuan",
                              subtitle: "S&K Aplikasi Big Express",
                              currentValue: null,
                              onTap: () {
                                launch(
                                    'https://bigexpress.co.id/terms.customer.php');
                              },
                            ),
                            SizedBox(
                              height: 5.w,
                            ),

                            /// WIDGET: LOGOUT ACTION BUTTON
                            ///
                            CustomButton(
                                onTap: () {
                                  yesOrNoDialog(context,
                                          title: 'Keluar',
                                          desc:
                                              'Apakah Anda yakin untuk keluar dari akun Anda?')
                                      .then((value) {
                                    if (value) {
                                      BlocProvider.of<UserCubit>(context)
                                          .logout(context);
                                    }
                                  });
                                },
                                text: 'Keluar',
                                pressAble: true,
                                gradient: LinearGradient(
                                  colors: [
                                    ColorPallette.baseYellow,
                                    ColorPallette.baseYellow
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(),
                    ],
                  );
                } else {
                  return Container();
                }
              }),

          const SizedBox(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AccountOption extends StatelessWidget {
  final double iconSize;
  final String iconPath;
  final String title;
  final String subtitle;
  final String? currentValue;
  final void Function()? onTap;

  const AccountOption({
    Key? key,
    required this.iconSize,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.currentValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /// WIDGET: OPTION ICON
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset(
                      iconPath,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// WIDGET: OPTION TITLE
                      Text(
                        title,
                        style: FontTheme.semiBoldPoppinsFont.copyWith(
                          fontSize: 12.sp,
                          color: ColorPallette.baseBlue,
                        ),
                      ),
                      SizedBox(
                        height: 1.0.w,
                      ),

                      /// WIDGET: OPTION SUBTITLE
                      Text(
                        subtitle,
                        style: FontTheme.mediumPoppinsFont.copyWith(
                          fontSize: 10.sp,
                          color: ColorPallette.baseGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  /// WIDGET: CURRENT VALUE
                  Text(
                    currentValue ?? "",
                    style: FontTheme.semiBoldPoppinsFont.copyWith(
                      fontSize: 11.sp,
                      color: ColorPallette.baseBlue,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),

                  /// WIDGET: OPEN BUTTON
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 4.0.w,
                    color: ColorPallette.baseBlue,
                  ),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
      ],
    );
  }
}
