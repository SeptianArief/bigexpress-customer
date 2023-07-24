part of '../pages.dart';

Future<void> showBottomSignInSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return const SignInContentWidget();
      });
}

class SignInContentWidget extends StatefulWidget {
  const SignInContentWidget({Key? key}) : super(key: key);

  @override
  State<SignInContentWidget> createState() => _SignInContentWidgetState();
}

class _SignInContentWidgetState extends State<SignInContentWidget> {
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                height: isKeyboardVisible ? 80.0.h : 50.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0.w),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(vertical: 5.0.w),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ColorPallette.baseBlue,
                      ),
                    ),
                    SizedBox(height: 3.0.w),
                    Expanded(
                        child: ListView(
                      children: [
                        Text(
                          'Selamat Datang\nBiggerians',
                          style: FontTheme.boldBaseFont.copyWith(
                              fontSize: 14.0.sp,
                              color: ColorPallette.baseBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0.w),
                        Text(
                          'Masukkan Nomor Handphone Anda',
                          style: FontTheme.semiBoldBaseFont.copyWith(
                            color: ColorPallette.baseYellow,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(height: 2.0.w),
                        InputField(
                          borderType: 'solid',
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {},
                          hintText: 'Nomor Handphone',
                          controller: _phoneNumberController,
                          // isError: validationProvider.errorPhoneNumber.isNotEmpty,
                          inputFormatter: MaskedInputFormatter(
                            '####-####-#####',
                            allowedCharMatcher: RegExp(r'[0-9]'),
                          ),
                        )
                      ],
                    )),
                    BlocBuilder<UserCubit, UserState>(
                        bloc: BlocProvider.of<UserCubit>(context),
                        builder: (context, state) {
                          return state is UserLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 5.0.w,
                                    height: 5.0.w,
                                    child: const CircularProgressIndicator(
                                      color: ColorPallette.baseBlue,
                                      strokeWidth: 5,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state is UserLoading
                                        ? null
                                        : () {
                                            EasyLoading.show(
                                                status: 'Mohon Tunggu');
                                            AuthService.sendOTP(
                                                    phoneNumber:
                                                        _phoneNumberController
                                                            .text
                                                            .replaceAll(
                                                                '-', ''))
                                                .then((value) {
                                              EasyLoading.dismiss();
                                              if (value.status ==
                                                  RequestStatus
                                                      .successRequest) {
                                                showSnackbar(context,
                                                    title:
                                                        'Berhasil Mengirim OTP',
                                                    customColor: Colors.green);
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => OTPPage(
                                                            phoneNumber:
                                                                _phoneNumberController
                                                                    .text
                                                                    .replaceAll(
                                                                        '-',
                                                                        ''),
                                                            otpKeyId: value
                                                                .data![0])));
                                              } else {
                                                showSnackbar(context,
                                                    title: 'Gagal Mengirim OTP',
                                                    customColor: Colors.orange);
                                              }
                                            });
                                            // FocusScopeNode currentFocus =
                                            //     FocusScope.of(context);

                                            // if (!currentFocus.hasPrimaryFocus) {
                                            //   currentFocus.unfocus();
                                            // }

                                            // BlocProvider.of<UserCubit>(context)
                                            //     .createOTP(context, onSuccesFunction: () {
                                            //   Navigator.pop(context);
                                            //   showBottomOTPSheet(context);
                                            // }, phoneNumber: _phoneNumberController.text);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      primary: ColorPallette.baseBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3.0.w),
                                      child: Text(
                                        "Masuk",
                                        style:
                                            FontTheme.semiBoldBaseFont.copyWith(
                                          fontSize: 13.sp,
                                          color: ColorPallette.baseWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        }),
                    SizedBox(height: 5.0.w)
                  ],
                ),
              )),
    );
  }
}
