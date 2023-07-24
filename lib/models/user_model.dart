part of 'models.dart';

class User {
  late int id;
  late String name;
  late String city;
  late String phoneNumber;
  late String email;
  late int saldo;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'phone': phoneNumber,
        'email': email,
        'saldo': saldo
      };

  User.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    city = jsonMap['city'];
    phoneNumber = jsonMap['phone'];
    email = jsonMap['email'];
    saldo = jsonMap['saldo'];
  }
}
