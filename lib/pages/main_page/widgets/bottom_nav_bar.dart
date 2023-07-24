part of '../../pages.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  final void Function(int)? onTap;

  const BottomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  BottomNavigationBarItem _buildBottomNavBarData(
      {required String label,
      required int index,
      required String assetOff,
      required String assetOn}) {
    return BottomNavigationBarItem(
      label: label,
      tooltip: '',
      backgroundColor: ColorPallette.baseWhite,
      icon: Padding(
        padding: EdgeInsets.only(bottom: 0.5.h),
        child: Image.asset(
          currentIndex != index ? assetOn : assetOff,
          width: 3.0.h,
          height: 3.0.h,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(-2, -2),
            blurRadius: 5,
            color: ColorPallette.baseBlack.withOpacity(0.15),
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        backgroundColor: ColorPallette.baseWhite,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        fixedColor: ColorPallette.baseBlue,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: ColorPallette.baseGrey,
        selectedLabelStyle: FontTheme.regularBaseFont.copyWith(
          fontSize: 10.sp,
          color: ColorPallette.baseBlue,
        ),
        unselectedLabelStyle: FontTheme.regularBaseFont.copyWith(
          fontSize: 10.sp,
          color: ColorPallette.baseGrey,
        ),
        items: [
          _buildBottomNavBarData(
              assetOff: "assets/images/Beranda01.png",
              assetOn: "assets/images/Beranda02.png",
              index: 0,
              label: 'Home'),
          _buildBottomNavBarData(
              assetOff: "assets/images/Transaksi01.png",
              assetOn: "assets/images/Transaksi02.png",
              index: 1,
              label: 'Transaksi'),
          _buildBottomNavBarData(
              assetOff: "assets/images/Bantuan01.png",
              assetOn: "assets/images/Bantuan02.png",
              index: 2,
              label: 'Bantuan'),
          _buildBottomNavBarData(
              assetOff: "assets/images/Akun01.png",
              assetOn: "assets/images/Akun02.png",
              index: 3,
              label: 'Akun'),
        ],
      ),
    );
  }
}
