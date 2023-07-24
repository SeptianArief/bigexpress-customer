part of 'models.dart';

enum PendingPaymentType { VirtualAccount, CStore, emoney }

class PendingPayment {
  late String token;
  late PendingPaymentType type;
  late String number;
  late String expDate;
  late double amount;
  late String assetImage;
  String? companyCode;
  String? bankCode;

  PendingPayment(
      {required this.token,
      required this.type,
      required this.number,
      required this.expDate,
      required this.amount,
      required this.assetImage,
      this.companyCode,
      this.bankCode});

  PendingPayment.fromBCAToVA(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.VirtualAccount;
    this.number = jsonMap['result']['bca_va_number'];
    this.expDate = jsonMap['result']['bca_expiration'];
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.assetImage = 'assets/images/bca_logo.png';
  }

  PendingPayment.fromBNIToVA(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.VirtualAccount;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['bni_va_number'];
    this.expDate = jsonMap['result']['bni_expiration'];
    this.assetImage = 'assets/images/bni_logo.png';
  }

  PendingPayment.fromBRIToVA(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.VirtualAccount;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['bri_va_number'];
    this.expDate = jsonMap['result']['bri_expiration'];
    this.assetImage = 'assets/images/bri_logo.png';
  }

  PendingPayment.fromPermataToVA(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.VirtualAccount;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['permata_va_number'];
    this.expDate = jsonMap['result']['permata_expiration'];
    this.assetImage = 'assets/images/permata_logo.png';
  }

  PendingPayment.fromMandiriToVA(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.VirtualAccount;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['bill_key'];
    this.expDate = jsonMap['result']['billpayment_expiration'];
    this.companyCode = jsonMap['result']['biller_code'];
    this.assetImage = 'assets/images/mandiri_logo.png';
  }

  PendingPayment.fromIndomaret(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.CStore;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['payment_code'];
    this.assetImage = 'assets/images/indomaret_logo.png';
    this.expDate = jsonMap['result']['indomaret_expire_time'];
  }

  PendingPayment.fromAlfamart(Map<String, dynamic> jsonMap) {
    this.token = jsonMap['token'];
    this.type = PendingPaymentType.CStore;
    this.amount = double.parse(jsonMap['transaction_details']['gross_amount']);
    this.number = jsonMap['result']['payment_code'];
    this.assetImage = 'assets/images/alfamart_logo.png';
    this.expDate = jsonMap['result']['alfamart_expire_time'];
  }
}
