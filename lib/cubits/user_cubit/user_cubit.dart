part of '../cubits.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(UserInitial());
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => MainPage()), (route) => false);
  }

  createSession(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', json.encode(user.toJson()));
  }

  register(
    BuildContext context, {
    required String phoneNumber,
    required String email,
    required String name,
    required String city,
    required String token,
  }) async {
    EasyLoading.show(status: 'Mohon Tunggu');
    String? tokenFCM = await FirebaseMessaging.instance.getToken();

    AuthService.register(
            phoneNumber: phoneNumber,
            email: email,
            name: name,
            city: city,
            token: token)
        .then((value) {
      EasyLoading.dismiss();
      if (value.status == RequestStatus.successRequest) {
        createSession(value.data!);
        AuthService.updateToken(
            token: tokenFCM.toString(), id: value.data!.id.toString());

        emit(UserLogged(value.data!));
        showSnackbar(context,
            title: 'Registrasi Berhasil', customColor: Colors.green);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainPage()), (route) => false);
      } else {
        showSnackbar(context,
            title: 'Gagal Melakukan Pendaftaran', customColor: Colors.orange);
      }
    });
  }

  login(BuildContext context,
      {required String phoneNumber,
      required String otpKeyId,
      required String otpKey}) async {
    EasyLoading.show(status: 'Mohon Tunggu');
    String? tokenFCM = await FirebaseMessaging.instance.getToken();

    AuthService.checkOTP(
            phoneNumber: phoneNumber, otpKeyId: otpKeyId, otpKey: otpKey)
        .then((value) {
      EasyLoading.dismiss();
      if (value.status == RequestStatus.successRequest) {
        if (value.data![0]) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileFormPage(
                        isNewMember: true,
                        phoneNumber: phoneNumber,
                      )));
        } else {
          createSession(value.data![1]);

          AuthService.updateToken(
              token: tokenFCM.toString(), id: value.data![1].id.toString());
          emit(UserLogged(value.data![1]));
          showSnackbar(context,
              title: 'Login Berhasil', customColor: Colors.green);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => MainPage()), (route) => false);
        }
      } else {
        showSnackbar(context,
            title: 'Kode OTP Salah', customColor: Colors.orange);
      }
    });
  }

  // refreshProfile({
  //   required String otpCode,
  //   required String otpKey,
  // }) {
  //   emit(UserLoading());
  //   UserService.getProfile(otpCode: otpCode, otpKey: otpKey).then((value) {
  //     if (value.status == RequestStatus.success_request) {
  //       emit(UserLogged(value.data));
  //     } else {
  //       emit(UserFailed(value));
  //     }
  //   });
  // }

  loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('login') != null) {
      User user = User.fromJson(json.decode(prefs.getString('login')!));
      emit(UserLogged(user));
      refreshProfile(id: user.id.toString());
    }
  }

  refreshProfile({required String id}) async {
    AuthService.getProfile(id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(UserLoading());
        emit(UserLogged(value.data!));
      }
    });
  }

  // createTokenSession(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   prefs.setString('token', token);
  // }

  // createUserSession(User data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('user', json.encode(data.toJson()));
  // }

  // checkOTP({
  //   required String phoneNumber,
  //   required String otp,
  //   required String otpKey,
  //   required Function() onSuccess,
  // }) {
  //   EasyLoading.show(status: 'Mohon Tunggu..');
  //   AuthService.checkOTP(phone: phoneNumber, otp: otp, otpKey: otpKey)
  //       .then((value) async {
  //     EasyLoading.dismiss();
  //     if (value.status == RequestStatus.success_request) {
  //       String token = value.data;
  //       await createTokenSession(token);
  //       EasyLoading.show(status: 'Mengambil Data..');
  //       UserService.getProfile(otpCode: otp, otpKey: otpKey)
  //           .then((value) async {
  //         EasyLoading.dismiss();
  //         print(value.status.toString());
  //         if (value.status == RequestStatus.success_request) {
  //           // isProfileGet = true;
  //           await createUserSession(value.data);
  //           emit(UserLogged(value.data));
  //           Fluttertoast.showToast(msg: 'Berhasil Login');
  //           onSuccess();
  //         } else {
  //           Fluttertoast.showToast(msg: value.data.toString());
  //         }
  //       });
  //     } else {
  //       Fluttertoast.showToast(msg: value.data.toString());
  //     }
  //   });
  // }

  // resendOTP(
  //     {required String phoneNumber,
  //     required Function() onSuccesFunction}) async {
  //   EasyLoading.show(status: 'Mohon Tunggu..');

  //   AuthService.requestOTP(phoneNumber.replaceAll('-', '')).then((value) {
  //     EasyLoading.dismiss();
  //     if (value.status == RequestStatus.success_request) {
  //       emit(UserLoading());

  //       emit(OTPSent(phoneNumber.replaceAll("-", ""),
  //           value.data["otp_key_id"].toString()));

  //       onSuccesFunction();
  //     } else {
  //       Fluttertoast.showToast(msg: 'Gagal Mengirimkan OTP');
  //     }
  //   });
  // }

  // createOTP(BuildContext context,
  //     {required String phoneNumber,
  //     required Function() onSuccesFunction}) async {
  //   emit(UserLoading());

  //   AuthService.requestOTP(
  //     phoneNumber.replaceAll("-", ""),
  //   ).then((value) {
  //     if (value.status == RequestStatus.success_request) {
  //       emit(OTPSent(phoneNumber.replaceAll("-", ""),
  //           value.data["otp_key_id"].toString()));

  //       onSuccesFunction();
  //     } else {
  //       Fluttertoast.showToast(msg: 'Gagal Mengirimkan OTP');
  //     }
  //   });
  // }
}
