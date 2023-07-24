part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UtilCubit bannerCubit = UtilCubit();
  UtilCubit promoCubit = UtilCubit();

  PageController carouselController = PageController();
  int selectedIndexBanner = 0;

  @override
  void initState() {
    bannerCubit.fetchBanner();
    promoCubit.fetchPromo();
    BlocProvider.of<UtilCubit>(context).fetchService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: BlocProvider.of<UserCubit>(context),
      builder: (context, stateUser) {
        return RefreshIndicator(
          onRefresh: () async {
            UserState userState = BlocProvider.of<UserCubit>(context).state;
            if (userState is UserLogged) {
              BlocProvider.of<UserCubit>(context)
                  .refreshProfile(id: userState.user.id.toString());
            }
          },
          child: ListView(
            children: [
              BlocBuilder<UtilCubit, UtilState>(
                  bloc: bannerCubit,
                  builder: (context, state) {
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 2,
                          child: state is UtilLoading
                              ? PlaceHolder(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white,
                                  ),
                                )
                              : state is BannerLoaded
                                  ? PageView(
                                      controller: carouselController,
                                      onPageChanged: (index) {
                                        setState(() {
                                          selectedIndexBanner = index;
                                        });
                                      },
                                      children: List.generate(state.data.length,
                                          (index) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image.network(
                                            baseUrl +
                                                'asset/banner/' +
                                                state.data[index].photo,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: FailedRequest(
                                        usingImage: false,
                                        onTap: () {
                                          bannerCubit.fetchBanner();
                                        },
                                      )),
                        ),
                        state is BannerLoaded
                            ? Positioned(
                                bottom: 3.0.w,
                                child: Container(
                                    width: 100.0.w,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(state.data.length,
                                          (index) {
                                        return DotIndicator(
                                          currentIndex: selectedIndexBanner,
                                          index: index,
                                        );
                                      }),
                                    )),
                              )
                            : const SizedBox(),
                        Positioned(
                          top: 3.0.w,
                          right: 3.0.w,
                          child: GestureDetector(
                            onTap: () {
                              UserState userState =
                                  BlocProvider.of<UserCubit>(context).state;
                              if (userState is UserLogged) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NotificationPage()));
                              } else {
                                showBottomSignInSheet(context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.0.w),
                              decoration: BoxDecoration(
                                color: ColorPallette.baseWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/Notifikasi.png",
                                  width: 6.0.w,
                                  height: 6.0.w,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
              _buildInformationSection(stateUser),
              _buildServiceSection(),
              _buildRewardSection(),
              SizedBox(height: 10.0.w)
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: Column(
        children: [
          SizedBox(height: 5.0.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reward',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 13.0.sp, color: ColorPallette.baseBlue),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RewardListPage()));
                },
                child: Text(
                  'Lihat Semua',
                  style: FontTheme.regularBaseFont.copyWith(
                      fontSize: 11.0.sp, color: ColorPallette.baseYellow),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.0.w),
          BlocBuilder<UtilCubit, UtilState>(
              bloc: promoCubit,
              builder: (context, state) {
                if (state is UtilLoading) {
                  return Column(
                    children: List.generate(3, (index) {
                      return PlaceHolder(
                        child: Container(
                          width: 90.0.w,
                          height: 30.0.w,
                          margin:
                              EdgeInsets.only(top: index == 0 ? 3.0.w : 2.0.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                        ),
                      );
                    }),
                  );
                } else if (state is PromoLoaded) {
                  return Column(
                    children: List.generate(state.data.length, (index) {
                      return index > 2
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(
                                  top: index == 0 ? 3.0.w : 2.0.w),
                              child:
                                  RewardPreviewWidget(data: state.data[index]));
                    }),
                  );
                } else {
                  return FailedRequest(
                    usingImage: false,
                    onTap: () {
                      promoCubit.fetchPromo();
                    },
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _buildServiceSection() {
    return BlocBuilder<UtilCubit, UtilState>(
        bloc: BlocProvider.of<UtilCubit>(context),
        builder: (context, state) {
          if (state is UtilLoading) {
            return Column(
              children: List.generate(3, (index) {
                return PlaceHolder(
                  child: Container(
                    width: 90.0.w,
                    height: 25.0.w,
                    margin: EdgeInsets.only(top: index == 0 ? 5.0.w : 2.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                );
              }),
            );
          } else if (state is ServiceLoaded) {
            return Column(
              children: List.generate(state.data.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      Position myPosition =
                          await Geolocator.getCurrentPosition();

                      EasyLoading.show(status: 'Mohon Tunggu..');
                      AuthService.checkRegion(
                              lat: myPosition.latitude.toString(),
                              lon: myPosition.longitude.toString(),
                              id: userState.user.id.toString())
                          .then((valueAPI) {
                        EasyLoading.dismiss();
                        if (valueAPI.status == RequestStatus.successRequest) {
                          if (valueAPI.data) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => OrderPage(
                                        idService: state.data[index].id)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AppLockedPage()));
                          }
                        } else {
                          showSnackbar(context,
                              title: 'Gagal Melakukan Pengecekan Lokasi',
                              customColor: Colors.orange);
                        }
                      });
                    } else {
                      showBottomSignInSheet(context);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 5.0.w,
                        right: 5.0.w,
                        top: index == 0 ? 5.0.w : 2.0.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0.w,
                      vertical: 2.0.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPallette.secondaryGrey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorPallette.baseGrey,
                        width: 0.3,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.network(baseUrl +
                                    'asset/other/' +
                                    state.data[index].logo)),
                          ),
                        ),
                        SizedBox(width: 5.0.w),
                        Flexible(
                          flex: 8,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.data[index].name,
                                  style: FontTheme.boldUbuntuFont.copyWith(
                                    fontSize: 12.sp,
                                    color: ColorPallette.baseBlue,
                                  ),
                                ),
                                SizedBox(height: 1.0.w),
                                Text(
                                  state.data[index].desc,
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                  style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 9.sp,
                                    color: ColorPallette.baseBlack
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            return FailedRequest(
              usingImage: false,
              verticalMargin: 5.0.w,
              onTap: () {
                BlocProvider.of<UtilCubit>(context).fetchService();
              },
            );
          }
        });
  }

  Widget _buildInformationSection(UserState state) {
    Widget _informationData(
        {required String assetImage,
        required String title,
        required bool isBoldTitle,
        required String data}) {
      return Flexible(
        flex: 4,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(assetImage),
                    ),
                  )),
              SizedBox(width: 2.0.w),
              Flexible(
                flex: 9,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 8.0.sp,
                          fontWeight:
                              isBoldTitle ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        data,
                        style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 8.sp,
                          color: ColorPallette.baseBlue,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: ColorPallette.secondaryGrey,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
      child: Row(
        children: [
          _informationData(
              assetImage: "assets/images/User.png",
              title: 'Selamat Datang',
              isBoldTitle: false,
              data: state is UserLogged ? state.user.name : 'Biggerians'),
          SizedBox(width: 5.0.w),
          _informationData(
              assetImage: "assets/images/Saldo.png",
              data: state is UserLogged
                  ? moneyChanger(double.parse(state.user.saldo.toString()))
                  : 'Silahkan Login',
              isBoldTitle: true,
              title: 'Saldo'),
          SizedBox(width: 2.0.w),
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                UserState userState = BlocProvider.of<UserCubit>(context).state;
                if (userState is UserLogged) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TopupListPage()));
                } else {
                  showBottomSignInSheet(context);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.0.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: state is UserLogged
                        ? ColorPallette.baseYellow
                        : ColorPallette.baseBlue),
                alignment: Alignment.center,
                child: Text(
                  state is UserLogged ? 'Top Up' : 'Sign In',
                  style: FontTheme.regularBaseFont.copyWith(
                      fontSize: 9.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
