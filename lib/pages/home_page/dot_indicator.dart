part of '../pages.dart';

class DotIndicator extends StatelessWidget {
  final int index;
  final int currentIndex;

  const DotIndicator({
    Key? key,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 2.0.w,
      duration: const Duration(
        milliseconds: 200,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 1.0.w,
      ),
      width: (currentIndex == index) ? 7.0.w : 2.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: (currentIndex == index)
            ? ColorPallette.baseYellow
            : ColorPallette.secondaryGrey,
      ),
    );
  }
}
