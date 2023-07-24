part of 'services.dart';

class OrderService {
  static Future<ApiReturnValue> cancelOrder(
      {required String id, required String reason}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/cancel_transaction.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['reason'] = reason;
    requestSend.fields['id'] = id;

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.successRequest, data: null);
        } else {
          apiReturnValue = ApiReturnValue(
              status: RequestStatus.failedRequest,
              data: json.decode(request.body)['msg']);
        }
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

  static Future<ApiReturnValue> checkout(
      {required String idUser,
      required String serviceId,
      required String addressSender,
      required String addressReceiver1,
      required String addressReceiver2,
      required String addressReceiver3,
      required String items,
      required String price,
      required String discount,
      required String discountName,
      required String driver1,
      required String driver2,
      required String driver3,
      required String isWallet,
      required String billIndex,
      required String timeStamp}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "customer/create_transaction.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id_user': idUser,
        'service_id': serviceId,
        'address_sender': addressSender,
        'address_receiver_1': addressReceiver1,
        'address_receiver_2': addressReceiver2,
        'address_receiver_3': addressReceiver3,
        'item': items,
        'price': price,
        'discount': discount,
        'discount_name': discountName,
        'driver_1': driver1,
        'driver_2': driver2,
        'driver_3': driver3,
        'is_wallet': isWallet,
        'bill_index': billIndex,
        'timestamp': timeStamp
      });

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        if (dataRaw['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.successRequest, data: null);
        } else {
          if (dataRaw['data'] == null) {
            apiReturnValue =
                ApiReturnValue(status: RequestStatus.failedRequest, data: null);
          } else {
            String validationCaught =
                "Terdapat ${dataRaw['data']['total'].toString()} Transaksi menggantung dengan saldo yang menggantung sebesar ${moneyChanger(double.parse(dataRaw['data']['saldo'].toString()))}";
            apiReturnValue = ApiReturnValue(
                status: RequestStatus.failedRequest, data: validationCaught);
          }
        }
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

  static Future<ApiReturnValue<TransactionDetail?>> fetchTransaction(
      {required String id}) async {
    ApiReturnValue<TransactionDetail?> apiReturnValue;

    const String url = baseUrl + "customer/detail_transaction.php";

    print('POST REQUEST TO $url');

    // try {
    var request = await http.post(
      Uri.parse(url),
      body: {'id': id},
    );

    print('--------------response--------------');
    print(request.body);
    print('------------------------------------');

    if (request.statusCode == 200) {
      var dataRaw = json.decode(request.body);

      apiReturnValue = ApiReturnValue(
          status: RequestStatus.successRequest,
          data: TransactionDetail.fromJson(dataRaw['data']));
    } else {
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.failedRequest);
    }
    // } catch (e) {
    //   print(e);
    //   apiReturnValue =
    //       ApiReturnValue(data: null, status: RequestStatus.serverError);
    // }

    return apiReturnValue;
  }
}
