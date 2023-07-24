part of '../pages.dart';

class RewardPreviewWidget extends StatelessWidget {
  final PromoModel data;
  const RewardPreviewWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RewardDetailPage(
                      data: data,
                    )));
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
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              baseUrl + 'asset/promo/' + data.photo))),
                ),
              ),
            ),
            Flexible(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(3.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.0.w),
                    Text(
                      'Berakhir Pada',
                      style: FontTheme.boldBaseFont.copyWith(
                        fontSize: 8.0.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      dateToReadable(data.expired.substring(0, 10)),
                      style: FontTheme.boldBaseFont.copyWith(
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
    );
  }
}
