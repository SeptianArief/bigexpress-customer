part of 'services.dart';

class UtilService {
  static Future<ApiReturnValue<List<BannerModel>?>> listBanner() async {
    ApiReturnValue<List<BannerModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_banner.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<BannerModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(BannerModel.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<TransactionPreview>?>> listTransaction(
      {required String id}) async {
    ApiReturnValue<List<TransactionPreview>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_transaction.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {'id_user': id});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TransactionPreview> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TransactionPreview.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<PromoModel>?>> listPromo() async {
    ApiReturnValue<List<PromoModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_promo.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<PromoModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(PromoModel.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<PromoModel?>> listPromoByCode(
      {required String code}) async {
    ApiReturnValue<PromoModel?> apiReturnValue;

    const String url = baseUrl + "customer/check_promo.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {'code': code});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest,
            data: dataRaw['data'] == null
                ? null
                : PromoModel.fromJson(dataRaw['data']));
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

  static Future<ApiReturnValue> reviewTransaction(
      {required String id, required String rating}) async {
    ApiReturnValue<PromoModel?> apiReturnValue;

    const String url = baseUrl + "customer/review_transaction.php";

    print('GET REQUEST TO $url');

    try {
      var request =
          await http.post(Uri.parse(url), body: {'id': id, 'rating': rating});

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

  static Future<ApiReturnValue<List<TopupModel>?>> listTopup(
      {required String id}) async {
    ApiReturnValue<List<TopupModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_topup.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http
          .post(Uri.parse(url), body: {'id_user': id, 'user_type': '0'});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TopupModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TopupModel.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<DriverPreview>?>> listDriver(
      {required String lat, required String lon}) async {
    ApiReturnValue<List<DriverPreview>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_driver.php";

    print('POST REQUEST TO $url');

    try {
      var request =
          await http.post(Uri.parse(url), body: {'lat': lat, 'lon': lon});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<DriverPreview> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(DriverPreview.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<Notifications>?>> notificationList({
    required String id,
  }) async {
    ApiReturnValue<List<Notifications>?> apiReturnValue;

    const String url = baseUrl + "driver/fetch_notif.php";

    print('POST REQUEST TO $url');

    try {
      var request =
          await http.post(Uri.parse(url), body: {'id': id, 'type': '0'});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<Notifications> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(Notifications.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<BankOwnerModel>?>> listBankOwner() async {
    ApiReturnValue<List<BankOwnerModel>?> apiReturnValue;

    String url = baseUrl + "dashboard/fetch_owner_bank.php";

    var request = http.MultipartRequest('GET', Uri.parse(url));

    print(request.fields);

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(response.body);
      print('------------------------------------------');

      if (response.statusCode == 200) {
        var dataRaw = json.decode(response.body);

        List<BankOwnerModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(BankOwnerModel.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<ServiceModel>?>> listService() async {
    ApiReturnValue<List<ServiceModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_service.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<ServiceModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(ServiceModel.fromJson(dataRaw['data'][i]));
        }

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

  static Future<ApiReturnValue<List<CityModel>?>> listCity() async {
    ApiReturnValue<List<CityModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_city.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<CityModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(CityModel.fromJson(dataRaw['data'][i]));
        }

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
