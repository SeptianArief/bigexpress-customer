part of 'widgets.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final void Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final String borderType;
  final TextInputFormatter? inputFormatter;
  final double? verticalPadding;
  final int? maxLines;
  final Color? fillColor;
  final Color? hintTextColor;
  final Widget? suffixIcon;
  final bool isError;
  final FocusNode? focus;
  final bool enabled;

  const InputField({
    Key? key,
    this.hintText,
    required this.controller,
    this.focus,
    required this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.borderType = "none",
    this.inputFormatter,
    this.verticalPadding,
    this.maxLines,
    this.fillColor,
    this.hintTextColor,
    this.suffixIcon,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      focusNode: focus,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: (maxLines != null) ? maxLines : 1,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      inputFormatters: (inputFormatter != null) ? [inputFormatter!] : null,
      style: FontTheme.regularBaseFont.copyWith(
        fontSize: 11.sp,
      ),
      decoration: InputDecoration(
        filled: true,
        errorStyle: FontTheme.regularBaseFont
            .copyWith(fontSize: 11.sp, color: Colors.red),
        isCollapsed: true,
        fillColor: fillColor ?? ColorPallette.baseWhite,
        hintText: hintText,
        hintStyle: FontTheme.regularBaseFont.copyWith(
          fontSize: 11.sp,
          color: hintTextColor ?? ColorPallette.baseGrey,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.0.w,
          vertical: verticalPadding ?? 2.5.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: borderType == "none"
              ? BorderSide.none
              : BorderSide(
                  color: isError
                      ? Colors.red
                      : ColorPallette.baseBlack.withOpacity(0.75),
                  width: 1,
                ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: borderType == "none"
              ? BorderSide.none
              : BorderSide(
                  color: isError
                      ? Colors.red
                      : ColorPallette.baseBlack.withOpacity(0.75),
                  width: 1,
                ),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
