part of 'pages.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Future<Timer> _splashToHomeScreen() async {
    return Timer(const Duration(seconds: 2), () async {
      BlocProvider.of<UserCubit>(context).loadSession();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    });
  }

  @override
  void initState() {
    _splashToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/Logo.png",
          width: 70.0.w,
          height: 70.0.w,
        ),
      ),
    );
  }
}
