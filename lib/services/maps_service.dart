part of 'services.dart';

class MapsService {
  static Future<List<Suggestion>> getSuggestions(
      String input, String lang) async {
    try {
      final String apiKey = googleAPIKey;

      final String apiBaseURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&components=country:id&key=$apiKey";

      final response = await http.get(Uri.parse(apiBaseURL));

      final data = jsonDecode(response.body);

      return data['status'] == 'OK'
          ? data['predictions']
              .map<Suggestion>(
                (value) => Suggestion(value['place_id'], value['description']),
              )
              .toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDetailSuggestion(
      String placeID) async {
    String apiKey = googleAPIKey;

    final String apiBaseURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&fields=geometry&key=$apiKey";

    final response = await http.get(Uri.parse(apiBaseURL));

    final data = jsonDecode(response.body);

    return data['result']['geometry']['location'] as Map<String, dynamic>;
  }
}
