part of 'services.dart';

class FinanceAPI {
  static Future<ApiReturnValue<DetailPayment?>> detailPayment(
      {required String id,
      required String name,
      required String amount,
      required String trxId,
      required bool isVA,
      required String phone}) async {
    ApiReturnValue<DetailPayment?> apiReturnValue;

    String url = baseUrl +
        (isVA
            ? 'payment_gateway/bcavirtualaccount.php'
            : "payment_gateway/bcatrfrekening.php");

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id_user': id,
        'name': name,
        'type': '0',
        'amount': amount,
        'trxid': trxId,
        'phone': phone
      });

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest,
            data: DetailPayment.fromJson(dataRaw));
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

  static Future<ApiReturnValue<PaymentListMaster?>> paymentList(
      {required String id,
      required String name,
      required String amount,
      required String tempId,
      required String phone}) async {
    ApiReturnValue<PaymentListMaster?> apiReturnValue;

    const String url = baseUrl + "payment_gateway/listpayment.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id_user': id,
        'temp_id': tempId,
        'name': name,
        'type': '0',
        'amount': amount,
        'phone': phone
      });

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest,
            data: PaymentListMaster.fromJson(dataRaw));
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

  static Future<ApiReturnValue> virtualAccountDetail(
      String url, String type) async {
    ApiReturnValue apiReturnValue;

    var request = http.MultipartRequest('GET', Uri.parse(url));
    print(url);

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);

      if (response.statusCode != 200) {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
      } else {
        //parsing html
        var document = parse(response.body);
        String paramCompare = 'transactionData';
        bool listen = false;
        int? startListening;
        String dcoument = document.body!.innerHtml;
        String finalData = '';
        for (var i = 0; i < dcoument.length; i++) {
          if (listen) {
            if (dcoument[i + 1] == "<") {
              listen = false;
            }
            if (startListening != null && i >= startListening) {
              finalData = finalData + dcoument[i];
            }
          } else {
            if (startListening == null) {
              if (dcoument.substring(i, i + 15) == paramCompare) {
                startListening = i + 17;
              }
            } else {
              if (startListening == i) {
                listen = true;
              }
            }
          }
        }

        final jsonMap = json.decode(finalData);
        print(jsonMap);
        PendingPayment? pendingPayment;

        if (type == 'bca-va-number') {
          pendingPayment = PendingPayment.fromBCAToVA(jsonMap);
        } else if (type == 'bni-va-number') {
          pendingPayment = PendingPayment.fromBNIToVA(jsonMap);
        } else if (type == 'bri-va-number') {
          pendingPayment = PendingPayment.fromBRIToVA(jsonMap);
        } else if (type == 'permata-va-number') {
          pendingPayment = PendingPayment.fromPermataToVA(jsonMap);
        } else if (type == 'mandiri-bill-number') {
          pendingPayment = PendingPayment.fromMandiriToVA(jsonMap);
        } else if (type == 'all-bank-va-number') {
          pendingPayment = PendingPayment.fromBNIToVA(jsonMap);
        } else if (type == 'payment-code') {
          if (jsonMap['result']['charge_type'] == 'indomaret') {
            pendingPayment = PendingPayment.fromIndomaret(jsonMap);
          } else {
            pendingPayment = PendingPayment.fromAlfamart(jsonMap);
          }
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.successRequest, data: pendingPayment);
      }
    } on SocketException {
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(status: RequestStatus.serverError, data: null);
    }

    return apiReturnValue;
  }
}
