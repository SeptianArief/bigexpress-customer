part of 'services.dart';

class AddressService {
  static Future<ApiReturnValue<List<AddressLocal>?>> fetchAddress(
      {required String type, required String id}) async {
    ApiReturnValue<List<AddressLocal>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_address.php";

    print('POST REQUEST TO $url');

    try {
      var request =
          await http.post(Uri.parse(url), body: {'type': type, 'id_user': id});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<AddressLocal> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(AddressLocal.fromJson(dataRaw['data'][i]));
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

  static Future<ApiReturnValue<PriceModel?>> fetchPrice(
      {required String totalDistance, required String id}) async {
    ApiReturnValue<PriceModel?> apiReturnValue;

    const String url = baseUrl + "customer/check_price.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url),
          body: {'total_distance': totalDistance, 'id_service': id});

      print(totalDistance);
      print(id);

      print('--------------response--------------');
      print(request.body);

      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest,
            data: PriceModel(
                isValid: dataRaw['data']['is_valid'],
                data: dataRaw['data']['price'].toString(),
                totalDistance: totalDistance));
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

  static Future<ApiReturnValue> deleteAddress(
      {required String type, required String id}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/delete_address.php";

    print('POST REQUEST TO $url');

    try {
      var request =
          await http.post(Uri.parse(url), body: {'type': type, 'id': id});

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

  static Future<ApiReturnValue> postAddress(
      {required String idUser,
      required String address,
      required String lat,
      required String lon,
      required String phoneNumber,
      required String addressName,
      required String note,
      required String owner,
      required String type}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/create_address.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id_user': idUser,
        'address': address,
        'lat': lat,
        'lon': lon,
        'phone_number': phoneNumber,
        'address_name': addressName,
        'note': note,
        'owner_name': owner,
        'type': type
      });

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

  static Future<ApiReturnValue> updateAddress(
      {required String id,
      required String address,
      required String lat,
      required String lon,
      required String phoneNumber,
      required String addressName,
      required String note,
      required String owner,
      required String type}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/update_address.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id': id,
        'address': address,
        'lat': lat,
        'lon': lon,
        'phone_number': phoneNumber,
        'address_name': addressName,
        'note': note,
        'owner_name': owner,
        'type': type
      });

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
}
