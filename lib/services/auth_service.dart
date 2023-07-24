part of 'services.dart';

class AuthService {
  static Future<ApiReturnValue> checkRegion(
      {required String lat, required String lon, required String id}) async {
    late ApiReturnValue returnValue;
    String apiUrl =
        'https://bigexpress.co.id/API/big/API/driver/check_region.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'id': id, 'lat': lat, 'lon': lon},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'Failed') {
          returnValue =
              ApiReturnValue(data: false, status: RequestStatus.successRequest);
        } else {
          returnValue =
              ApiReturnValue(data: true, status: RequestStatus.successRequest);
        }
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failedParsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> getProfile({
    required String id,
  }) async {
    late ApiReturnValue returnValue;
    String apiURL = baseUrl + 'customer/fetch_profile.php';

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        body: {
          'id': id,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        returnValue = ApiReturnValue(
            data: User.fromJson(data['data']),
            status: RequestStatus.successRequest);
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failedParsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue<List<String>?>> sendOTP(
      {required String phoneNumber}) async {
    ApiReturnValue<List<String>?> apiReturnValue;

    const String url = baseUrl + "customer/create_otp.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'phone': phoneNumber},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<String> dataFinal = [];
        dataFinal.add(dataRaw['data']['otp_key_id'].toString());
        dataFinal.add(dataRaw['data']['otp_key']);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest, data: dataFinal);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.serverError);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue<User?>> register(
      {required String phoneNumber,
      required String email,
      required String name,
      required String city,
      required String token}) async {
    ApiReturnValue<User?> apiReturnValue;

    const String url = baseUrl + "customer/register.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {
          'phone': phoneNumber,
          'email': email,
          'name': name,
          'city': city,
          'token': token
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest,
            data: User.fromJson(dataRaw['data']));
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.serverError);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateProfile(
      {required String email,
      required String name,
      required String city,
      required String id}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/update_profile.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'email': email, 'name': name, 'city': city, 'id': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.serverError);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateToken({
    required String id,
    required String token,
  }) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/update_token.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'token': token, 'id': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.serverError);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue<List<dynamic>?>> checkOTP(
      {required String phoneNumber,
      required String otpKeyId,
      required String otpKey}) async {
    ApiReturnValue<List<dynamic>?> apiReturnValue;

    const String url = baseUrl + "customer/cek_otp.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'phone': phoneNumber, 'otp_key': otpKey, 'otp_key_id': otpKeyId},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<dynamic> dataFinal = [];
        bool isNew = dataRaw['is_new'];

        dataFinal.add(isNew);
        dataFinal.add(
            dataRaw['data'] == null ? null : User.fromJson(dataRaw['data']));

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest, data: dataFinal);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.serverError);
    }

    return apiReturnValue;
  }
}
