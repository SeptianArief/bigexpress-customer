part of '../pages.dart';

class RewardDetailPage extends StatefulWidget {
  final PromoModel data;
  const RewardDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends State<RewardDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const HeaderBar(title: 'Detail Reward'),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          children: [
            SizedBox(height: 5.0.w),
            Container(
              width: 90.0.w,
              height: 60.0.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          baseUrl + 'asset/promo/' + widget.data.photo))),
            ),
            SizedBox(
              height: 5.0.w,
            ),
            Text(
              widget.data.title,
              style: FontTheme.boldBaseFont.copyWith(
                  fontSize: 14.0.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.0.w,
            ),
            Text(
              widget.data.desc,
              style: FontTheme.regularBaseFont.copyWith(
                fontSize: 11.0.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 10.0.w,
            ),
            Text('Kode Voucher',
                style: FontTheme.boldBaseFont.copyWith(
                    fontSize: 12.0.sp,
                    color: ColorPallette.baseBlue,
                    fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPallette.secondaryGrey),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Flexible(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 3.0.w, horizontal: 5.0.w),
                        child: Text(
                          widget.data.promoCode,
                          style: FontTheme.boldBaseFont.copyWith(
                              fontSize: 14.0.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.data.promoCode));
                          showSnackbar(context,
                              title: 'Berhasil Menyalin Kode Promo');
                        },
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorPallette.baseYellow),
                          alignment: Alignment.center,
                          child: Text(
                            'Salin',
                            style: FontTheme.regularBaseFont.copyWith(
                                fontSize: 12.0.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0.w,
            ),
          ],
        ))
      ],
    );
  }
}
