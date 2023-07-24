part of 'widgets.dart';

class FailedRequest extends StatelessWidget {
  final Function onTap;
  final bool usingImage;
  final double verticalMargin;
  const FailedRequest(
      {Key? key,
      this.verticalMargin = 0,
      this.usingImage = true,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          usingImage
              ? Container(
                  width: 30.0.w,
                  height: 30.0.w,
                  child: Image.asset('assets/images/emoji-sad.png',
                      fit: BoxFit.cover),
                )
              : Container(),
          SizedBox(height: usingImage ? 5.0.w : 0),
          Text(
            'Gagal Memuat Data',
            style: FontTheme.regularBaseFont.copyWith(
                fontSize: 13.0.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.0.w),
          Text(
            'Silahkan untuk mencoba kembali',
            style: FontTheme.regularBaseFont
                .copyWith(fontSize: 11.0.sp, color: Colors.black54),
          ),
          SizedBox(height: 5.0.w),
          SizedBox(
              width: 70.0.w,
              child: CustomButton(
                  sizeText: 10.0.sp,
                  onTap: () {
                    onTap();
                  },
                  padding: EdgeInsets.symmetric(vertical: 3.0.w),
                  text: 'Coba Lagi',
                  pressAble: true))
        ],
      ),
    );
  }
}
