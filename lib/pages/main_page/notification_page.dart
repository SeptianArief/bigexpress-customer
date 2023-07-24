part of '../pages.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  UtilCubit utilCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      utilCubit.fetchNotification(id: userState.user.id.toString());
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
        HeaderBar(title: 'Notifikasi'),
        BlocBuilder<UtilCubit, UtilState>(
            bloc: utilCubit,
            builder: (context, state) {
              if (state is UtilLoading) {
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
              } else if (state is NotificationsLoaded) {
                return Expanded(
                    child: state.data.isEmpty
                        ? Center(
                            child: Text('Notifikasi Kosong',
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 13.0.sp, color: Colors.black54)))
                        : ListView(
                            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            children: List.generate(state.data.length, (index) {
                              return Container(
                                  margin: EdgeInsets.only(
                                      top: index == 0 ? 5.0.w : 2.0.w,
                                      bottom: index == state.data.length - 1
                                          ? 5.0.w
                                          : 0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                        padding: EdgeInsets.all(5.0.w),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 10.0.w,
                                              height: 10.0.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    spreadRadius: 0.2,
                                                    color: ColorPallette
                                                        .baseBlack
                                                        .withOpacity(0.15),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.center,
                                              child: Container(
                                                  width: 6.0.w,
                                                  height: 6.0.w,
                                                  child: Image.asset(state
                                                              .data[index]
                                                              .type ==
                                                          1
                                                      ? 'assets/images/Notifikasi.png'
                                                      : state.data[index]
                                                                  .type ==
                                                              2
                                                          ? 'assets/images/Saldo.png'
                                                          : 'assets/images/Order Sukses.png')),
                                            ),
                                            SizedBox(width: 3.0.w),
                                            Expanded(
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            dateToReadable(state
                                                                    .data[index]
                                                                    .createdAt
                                                                    .substring(
                                                                        0,
                                                                        10)) +
                                                                ' ' +
                                                                state
                                                                    .data[index]
                                                                    .createdAt
                                                                    .substring(
                                                                        11, 16),
                                                            style: FontTheme
                                                                .regularBaseFont
                                                                .copyWith(
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                        SizedBox(height: 1.0.w),
                                                        Text(
                                                            state.data[index]
                                                                .title,
                                                            style: FontTheme
                                                                .boldBaseFont
                                                                .copyWith(
                                                                    fontSize:
                                                                        11.0.sp,
                                                                    color: ColorPallette
                                                                        .baseBlue)),
                                                        Text(
                                                            state.data[index]
                                                                .desc,
                                                            style: FontTheme
                                                                .regularBaseFont
                                                                .copyWith(
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    color: ColorPallette
                                                                        .baseBlack)),
                                                      ],
                                                    )))
                                          ],
                                        )),
                                  ));
                            })));
              } else {
                return Expanded(
                  child: FailedRequest(
                    onTap: () {
                      UserState userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if (userState is UserLogged) {
                        utilCubit.fetchNotification(
                            id: userState.user.id.toString());
                      }
                    },
                  ),
                );
              }
            })
      ],
    );
  }
}
