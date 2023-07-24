part of 'services.dart';

class ItemService {
  static Future<ApiReturnValue<List<ItemModel>?>> listItem(String id) async {
    ApiReturnValue<List<ItemModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_item.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {'id_user': id});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<ItemModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(ItemModel.fromJson(dataRaw['data'][i]));
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

  static Future<ApiReturnValue> postItem(
      {required String idUser,
      required String nameItem,
      required String weightItem}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/create_item.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url),
          body: {'id_user': idUser, 'name': nameItem, 'weight': weightItem});

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

  static Future<ApiReturnValue> updateItem(
      {required String id,
      required String nameItem,
      required String weightItem}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/update_item.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url),
          body: {'id': id, 'name': nameItem, 'weight': weightItem});

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

  static Future<ApiReturnValue> deleteItem({
    required String id,
  }) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/delete_item.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id': id,
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
