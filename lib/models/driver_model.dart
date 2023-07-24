part of 'models.dart';

class Driver {
  late String id;
  late String name;
  late String photo;
  late String phoneNumber;
  late String rating;
  late String kendaraan;
  late String lat;
  late String lon;
  late String bearing;
  late double distance;

  Driver.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['nama_driver'];
    photo = jsonMap['foto_ktp'];
    phoneNumber = jsonMap['no_telepon'];
    rating = jsonMap['rating'];
    kendaraan = jsonMap['kendaraan'];
    lat = jsonMap['latitude'];
    lon = jsonMap['longitude'];
    bearing = jsonMap['bearing'];
    distance = double.parse(jsonMap['distance'].toString());
  }
}
