part of 'models.dart';

class PriceModel {
  late bool isValid;
  late String data;
  late String totalDistance;

  PriceModel(
      {required this.isValid, required this.data, required this.totalDistance});
}

class AddressLocal {
  final int? id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String phoneNumber;
  final String? catatan;
  final String? addressName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'owner': name,
        'address_name': addressName,
        'phone': phoneNumber,
        'lat': latitude,
        'lon': longitude,
        'note': catatan
      };

  AddressLocal(
      {this.id,
      required this.address,
      required this.name,
      required this.phoneNumber,
      this.latitude,
      this.addressName,
      this.longitude,
      this.catatan});

  factory AddressLocal.fromJson(Map<String, dynamic> json) => AddressLocal(
      id: json['id'],
      address: json['address'],
      name: json['owner'],
      addressName: json['address_name'],
      phoneNumber: json['phone'],
      latitude: json['lat'] != "" ? double.parse(json['lat'].toString()) : null,
      longitude:
          json['lon'] != "" ? double.parse(json['lon'].toString()) : null,
      catatan: json['note']);
}
