part of 'widgets.dart';

class HeaderBar extends StatelessWidget {
  final String title;
  final double? height;
  final void Function()? onTap;
  final Widget? suffix;

  const HeaderBar(
      {Key? key, required this.title, this.height, this.onTap, this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 5.0.w,
            bottom: 5.0.w,
            left: 5.0.w,
            right: 5.0.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              ColorPallette.baseBlue,
              Color(0xFFBAC8DE),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                title,
                style: FontTheme.semiBoldBaseFont.copyWith(
                  fontSize: 15.sp,
                  color: ColorPallette.baseWhite,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if (onTap == null) {
                    Navigator.pop(context);
                  } else {
                    onTap!();
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Image.asset(
                  "assets/images/Arrow12.png",
                  width: 7.0.w,
                  height: 7.0.w,
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerRight, child: suffix ?? Container())
          ],
        ));
  }
}
