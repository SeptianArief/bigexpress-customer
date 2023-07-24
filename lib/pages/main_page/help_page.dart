part of '../pages.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with AutomaticKeepAliveClientMixin<HelpScreen> {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLogged) {
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .doc(state.user.id.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot<Object?>? dataRaw = snapshot.data;

                if (dataRaw!.exists) {
                  return ChatRoomPage(
                    dataChat: dataRaw,
                  );
                } else {
                  return Scaffold(
                    body: Stack(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 40.0.h,
                              padding: EdgeInsets.only(
                                top: 5.0.w +
                                    MediaQuery.of(context).viewPadding.top,
                              ),
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
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0.w),
                                  child: Text(
                                    "Bantuan",
                                    style: FontTheme.semiBoldBaseFont.copyWith(
                                      fontSize: 24.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 40.0.w,
                                  height: 40.0.w,
                                  child: Image.asset(
                                    "assets/images/Motor Backdrop.png",
                                  ),
                                ))
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.all(5.0.w),
                            margin: EdgeInsets.only(
                              top: 30.0.h,
                              left: 5.0.w,
                              right: 5.0.w,
                            ),
                            decoration: BoxDecoration(
                              color: ColorPallette.baseWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 0.2,
                                  color:
                                      ColorPallette.baseBlack.withOpacity(0.15),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    /// WIDGET: PEOPLE PHOTO 1
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Image.asset(
                                        "assets/images/People01.png",
                                        width: 12.0.w,
                                        height: 12.0.w,
                                      ),
                                    ),

                                    /// WIDGET: PEOPLE PHOTO 2
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.0.w),
                                      child: Image.asset(
                                        "assets/images/People02.png",
                                        width: 12.0.w,
                                        height: 12.0.w,
                                      ),
                                    ),

                                    /// WIDGET: PEOPLE PHOTO 3
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0.w),
                                      child: Image.asset(
                                        "assets/images/People03.png",
                                        width: 12.0.w,
                                        height: 12.0.w,
                                      ),
                                    ),

                                    /// WIDGET: PEOPLE PHOTO 4
                                    Padding(
                                      padding: EdgeInsets.only(left: 18.0.w),
                                      child: Image.asset(
                                        "assets/images/People04.png",
                                        width: 12.0.w,
                                        height: 12.0.w,
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.w,
                                ),

                                /// WIDGET: GREETING TEXT
                                Text(
                                  "Hai Biggerians,",
                                  style: FontTheme.boldBaseFont.copyWith(
                                    fontSize: 18.sp,
                                    color: ColorPallette.baseBlue,
                                  ),
                                ),

                                SizedBox(
                                  height: 2.w,
                                ),

                                /// WIDGET: SERVICE TEXT
                                Text(
                                  "Hai Biggerians, Kami selalu siap membantu anda selama 24 jam",
                                  style: FontTheme.regularBaseFont.copyWith(
                                    height: 1.4,
                                    fontSize: 10.sp,
                                    color: ColorPallette.baseBlue,
                                  ),
                                ),

                                SizedBox(
                                  height: 5.w,
                                ),

                                CustomButton(
                                    onTap: () {
                                      UserState userState =
                                          BlocProvider.of<UserCubit>(context)
                                              .state;
                                      if (userState is UserLogged) {
                                        ChatService.openChat(
                                            user: userState.user);
                                      }
                                    },
                                    text: 'Kirim Pesan',
                                    pressAble: true),

                                /// WIDGET: GO TO CHAT LIST
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      } else {
        return Container();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
