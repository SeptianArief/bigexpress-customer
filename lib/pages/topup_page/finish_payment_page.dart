part of '../pages.dart';

class FinishPaymentPage extends StatefulWidget {
  const FinishPaymentPage({Key? key}) : super(key: key);

  @override
  State<FinishPaymentPage> createState() => _FinishPaymentPageState();
}

class _FinishPaymentPageState extends State<FinishPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                width: 100.0.w,
                height: 100.0.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 100.0.w,
                        height: 50.0.w,
                        child: Center(
                            child: Container(
                                width: 70.0.w,
                                child: Image.asset(
                                    'assets/images/gopay_logo.png')))),
                    SizedBox(height: 2.0.w),
                    Text(
                      'Selesaikan Pembayaran',
                      style: TextStyle(
                          fontSize: 16.0.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0.w),
                    SizedBox(
                      width: 90.0.w,
                      child: Text(
                          'Jika Anda Sudah Melakukan Pembayaran, Silahkan Keluar Dari Halaman Ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.black87.withOpacity(0.5))),
                    ),
                    SizedBox(height: 5.0.w),
                  ],
                )),
            Positioned(
                top: 3.0.w,
                right: 3.0.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, color: Colors.black54),
                ))
          ],
        ),
      ),
    );
  }
}
