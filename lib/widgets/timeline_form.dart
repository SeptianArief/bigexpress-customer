part of 'widgets.dart';

class TimelineForm extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isActive;
  final bool isChecked;
  final int index;
  final Widget child;

  const TimelineForm({
    Key? key,
    this.isFirst = false,
    this.isLast = false,
    this.isActive = false,
    this.isChecked = false,
    required this.index,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        thickness: 2,
        color: isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
      ),
      afterLineStyle: LineStyle(
        thickness: 2,
        color: isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
      ),
      indicatorStyle: IndicatorStyle(
        width: 5.0.w,
        height: 5.0.w,
        indicatorXY: 0.0,
        padding: EdgeInsets.symmetric(
          vertical: 2.0.w,
        ),
        indicator: Container(
          width: 7.0.w,
          height: 7.0.w,
          decoration: BoxDecoration(
            color: isActive ? ColorPallette.baseBlue : ColorPallette.baseGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isChecked
                ? Icon(
                    Icons.check,
                    color: ColorPallette.baseYellow,
                    size: 5.0.w,
                  )
                : Text(
                    "$index",
                    style: FontTheme.semiBoldBaseFont.copyWith(
                      fontSize: 12.sp,
                      color: isActive
                          ? ColorPallette.baseYellow
                          : ColorPallette.baseWhite,
                    ),
                  ),
          ),
        ),
      ),
      endChild: child,
    );
  }
}
