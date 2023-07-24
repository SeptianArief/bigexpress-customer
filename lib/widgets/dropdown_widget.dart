part of 'widgets.dart';

class DropdownWidget extends StatelessWidget {
  final String? value;
  final String hintText;
  const DropdownWidget({Key? key, required this.value, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 5.0.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black87)),
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            width: double.infinity,
            child: Text(
              value ?? hintText,
              style: FontTheme.regularBaseFont.copyWith(
                  fontSize: 10.0.sp,
                  color: value == null ? Colors.black54 : Colors.black87),
            ),
          )),
          SizedBox(width: 3.0.w),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.black87,
            size: 5.0.w,
          )
        ],
      ),
    );
  }
}
