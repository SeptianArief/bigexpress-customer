part of '../pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // CURRENT BOTTOM BAR INDEX
  int _currentNavBottomBarIndex = 0;

  // NAVIGATION PAGE CONTROLLER
  final PageController _pageController = PageController();

  List<Widget> dataScreen = [
    HomePage(),
    TransactionListPage(),
    HelpScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // SHOW BACK STATUS BAR
    // ignore: deprecated_member_use
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    // SET STATUS BAR COLOR
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorPallette.baseBlue,
    ));

    return Scaffold(
        backgroundColor: ColorPallette.baseWhite,
        body: dataScreen[_currentNavBottomBarIndex],
        bottomNavigationBar: BlocBuilder<UserCubit, UserState>(
          bloc: BlocProvider.of<UserCubit>(context),
          builder: (context, state) {
            return BottomNavbar(
              currentIndex: _currentNavBottomBarIndex,
              onTap: (index) {
                if (state is UserLogged) {
                  setState(() {
                    _currentNavBottomBarIndex = index;
                  });
                } else {
                  showBottomSignInSheet(context);
                }
              },
            );
          },
        ));
  }
}
