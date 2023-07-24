part of 'models.dart';

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class CityModel {
  late int id;
  late String name;

  CityModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
  }
}

class BankOwnerModel {
  late int id;
  late String bankName;
  late String accountNumber;
  late String holderName;

  BankOwnerModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    bankName = jsonMap['bank_name'];
    accountNumber = jsonMap['account_number'];
    holderName = jsonMap['holder_name'];
  }
}

class BannerModel {
  late int id;
  late String url;
  late String name;
  late String description;
  late String photo;

  BannerModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    url = jsonMap['url'];
    name = jsonMap['name'];
    description = jsonMap['desc'];
    photo = jsonMap['photo'];
  }
}

class PromoModel {
  late int id;
  late String photo;
  late String title;
  late String desc;
  late String promoCode;
  late String expired;
  late String createdAt;
  late int discountRate;
  late double maxDiscount;

  PromoModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    photo = jsonMap['photo'];
    title = jsonMap['title'];
    desc = jsonMap['desc'];
    promoCode = jsonMap['promo_code'];
    expired = jsonMap['expired'];
    createdAt = jsonMap['created_at'];
    discountRate = jsonMap['discount_rate'];
    maxDiscount = double.parse(jsonMap['max_discount'].toString());
  }
}

class ServiceModel {
  late int id;
  late String logo;
  late String name;
  late String desc;

  ServiceModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    logo = jsonMap['logo'];
    name = jsonMap['name'];
    desc = jsonMap['desc'];
  }
}

class DriverPreview {
  late int id;
  late String name;
  late String photo;
  late double lat;
  late double lon;
  late double rating;
  late String platNumber;
  late String vehicleName;
  late String phoneNumber;
  late int isValidate;

  DriverPreview.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    photo = jsonMap['photo'];
    lat = double.parse(jsonMap['lat'].toString());
    lon = double.parse(jsonMap['lon'].toString());
    rating = double.parse(jsonMap['rating'].toString());
    platNumber = jsonMap['plat_number'];
    vehicleName = jsonMap['vehicle_name'];
    isValidate = jsonMap['is_validate'];

    try {
      phoneNumber = jsonMap['phone'];
    } catch (e) {
      phoneNumber = '';
    }
  }
}

class TopupModel {
  late int id;
  late double amount;
  late String evidence;
  late String requestedAt;
  late int status;
  late String orderId;
  late String paymentMethod;

  TopupModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    amount = double.parse(jsonMap['amount'].toString());
    evidence = jsonMap['evidence'];
    requestedAt = jsonMap['request'];
    status = jsonMap['status'];
    paymentMethod = jsonMap['payment_method'];
    orderId = jsonMap['order_id'];
  }
}

class TransactionPreview {
  late int id;
  late Map<String, dynamic> addressSender;
  late Map<String, dynamic> addressReceiver1;
  late Map<String, dynamic>? addressReceiver2;
  late Map<String, dynamic>? addressReceiver3;
  late Map<String, dynamic> item;
  late double price;
  late double discount;
  late String createdAt;
  late int transactionStatus;
  late String service;
  late int serviceId;

  TransactionPreview.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    addressSender = json.decode(jsonMap['address_sender']);
    addressReceiver1 = json.decode(jsonMap['address_receiver_1']);
    addressReceiver2 = jsonMap['address_receiver_2'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_2']);
    addressReceiver3 = jsonMap['address_receiver_3'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_3']);
    transactionStatus = jsonMap['transaction_status'];
    service = jsonMap['service'];
    price = double.parse(jsonMap['price'].toString());
    discount = double.parse(jsonMap['discount'].toString());
    createdAt = jsonMap['created_at'];
    serviceId = jsonMap['service_id'];
    item = json.decode(jsonMap['item']);
  }
}

class EvidenceModel {
  late int id;
  late String photo;
  late String timestamp;
  late int indexLocation;

  EvidenceModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    photo = jsonMap['photo'];
    timestamp = jsonMap['timestamp'];
    indexLocation = jsonMap['index_location'];
  }
}

class TransactionDetail {
  late int id;
  late Map<String, dynamic> addressSender;
  late Map<String, dynamic> addressReceiver1;
  late Map<String, dynamic>? addressReceiver2;
  late Map<String, dynamic>? addressReceiver3;
  late Map<String, dynamic> item;
  late double price;
  late double discount;
  late String createdAt;
  late int transactionStatus;
  late String service;
  late int? driverSelected;
  late int runningStatus;
  late int isWallet;
  late int billIndex;
  late DriverPreview? driver;
  late int review;
  late String reason;
  late List<EvidenceModel> dataEvidence = [];

  TransactionDetail.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    addressSender = json.decode(jsonMap['address_sender']);
    addressReceiver1 = json.decode(jsonMap['address_receiver_1']);
    item = json.decode(jsonMap['item']);
    addressReceiver2 = jsonMap['address_receiver_2'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_2']);
    addressReceiver3 = jsonMap['address_receiver_3'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_3']);
    transactionStatus = jsonMap['transaction_status'];
    service = jsonMap['service'];
    price = double.parse(jsonMap['price'].toString());
    discount = double.parse(jsonMap['discount'].toString());
    createdAt = jsonMap['created_at'];
    driverSelected = jsonMap['driver_selected'];
    runningStatus = jsonMap['running_status'];
    driver = jsonMap['driver'] == null
        ? null
        : DriverPreview.fromJson(jsonMap['driver']);
    isWallet = jsonMap['is_wallet'];
    billIndex = jsonMap['bill_index'];
    review = jsonMap['review'];
    reason = jsonMap['reason'];

    for (var i = 0; i < jsonMap['evidence'].length; i++) {
      dataEvidence.add(EvidenceModel.fromJson(jsonMap['evidence'][i]));
    }
  }
}

class Notifications {
  late int id;
  late int type;
  late String title;
  late String desc;
  late String createdAt;
  late int amount;

  Notifications.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    type = jsonMap['type'];
    title = jsonMap['title'];
    desc = jsonMap['desc'] ?? '';
    createdAt = jsonMap['created_at'];
    amount = jsonMap['amount'];
  }
}
