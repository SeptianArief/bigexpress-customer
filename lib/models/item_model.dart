part of 'models.dart';

class ItemModel {
  late int id;
  late String name;
  late double weight;
  late String note;
  late bool isBrokenItem;

  ItemModel(
      {required this.id,
      required this.name,
      required this.weight,
      required this.note,
      required this.isBrokenItem});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weight': weight,
        'note': note,
        'isBrokenItem': isBrokenItem
      };

  ItemModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    weight = double.parse(jsonMap['weight'].toString());
    note = '';
    isBrokenItem = false;
  }
}
