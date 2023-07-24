part of '../pages.dart';

class PickVoucherPage extends StatefulWidget {
  const PickVoucherPage({Key? key}) : super(key: key);

  @override
  State<PickVoucherPage> createState() => _PickVoucherPageState();
}

class _PickVoucherPageState extends State<PickVoucherPage> {
  UtilCubit promoCubit = UtilCubit();

  @override
  void initState() {
    promoCubit.fetchPromo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const HeaderBar(title: 'Voucher'),
        Expanded(
            child: BlocBuilder<UtilCubit, UtilState>(
                bloc: promoCubit,
                builder: (context, state) {
                  if (state is UtilLoading) {
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      children: List.generate(8, (index) {
                        return PlaceHolder(
                          child: Container(
                            width: 90.0.w,
                            height: 30.0.w,
                            margin: EdgeInsets.only(
                                top: index == 0 ? 3.0.w : 2.0.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                          ),
                        );
                      }),
                    );
                  } else if (state is PromoLoaded) {
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      children: List.generate(state.data.length, (index) {
                        PromoModel data = state.data[index];

                        return Container(
                            margin: EdgeInsets.only(
                                top: index == 0 ? 3.0.w : 2.0.w),
                            child: GestureDetector(
                              onTap: () {
                                DateTime expTime =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .parse(data.expired);

                                if (DateTime.now().isBefore(expTime)) {
                                  Navigator.pop(context, data);
                                } else {
                                  showSnackbar(context,
                                      customColor: Colors.orange,
                                      title: 'Promosi Telah Berakhir');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorPallette.secondaryGrey,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: AspectRatio(
                                        aspectRatio: 3 / 2,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(baseUrl +
                                                      'asset/promo/' +
                                                      data.photo))),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 7,
                                      child: Container(
                                        padding: EdgeInsets.all(3.0.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontTheme.boldBaseFont
                                                  .copyWith(
                                                      fontSize: 10.0.sp,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(height: 2.0.w),
                                            Text(
                                              'Berakhir Pada',
                                              style: FontTheme.boldBaseFont
                                                  .copyWith(
                                                fontSize: 8.0.sp,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              dateToReadable(data.expired
                                                  .substring(0, 10)),
                                              style: FontTheme.boldBaseFont
                                                  .copyWith(
                                                fontSize: 8.0.sp,
                                                fontWeight: FontWeight.bold,
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
                            ));
                      }),
                    );
                  } else {
                    return Container();
                  }
                }))
      ],
    );
  }
}
