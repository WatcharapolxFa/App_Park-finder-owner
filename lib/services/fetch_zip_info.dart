import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class FetchZipInfoService {
  final Logger logger = Logger();

  Future getfetchZipInfo(String postalCode) async {
    final url = 'https://api.zippopotam.us/th/$postalCode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> places = data['places'];
        return places[0];

        // for (var place in places) {
        //   logger.i(
        //       "Place Name: ${place['place name']}, State: ${place['state']}");
        // }
      } else {
        logger.w('Failed to load zip info.');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  Future<String> translateEngToThai(String word) async {
    final url =
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=th&dt=t&ie=UTF-8&oe=UTF-8&q=$word';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data[0][0][0] == "กรุงเทพฯ") {
          return "กรุงเทพมหานคร";
        }
        return data[0][0][0];
      } else {
        logger.w('Failed to load zip info.');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
    return "";
  }
}
