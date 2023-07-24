part of '../pages.dart';

class RewardListPage extends StatefulWidget {
  const RewardListPage({Key? key}) : super(key: key);

  @override
  State<RewardListPage> createState() => _RewardListPageState();
}

class _RewardListPageState extends State<RewardListPage> {
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
        const HeaderBar(title: 'Reward'),
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
                        return Container(
                            margin: EdgeInsets.only(
                                top: index == 0 ? 3.0.w : 2.0.w),
                            child:
                                RewardPreviewWidget(data: state.data[index]));
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
