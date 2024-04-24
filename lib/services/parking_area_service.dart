import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';

class ParkingAreaService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future uploadParkingIMG(
      String subFolderName, String fileName, String imgPath) async {
    var formData = http.MultipartRequest(
        'POST', Uri.parse('http://34.125.122.199:3100/api/aws_s3'));

    formData.fields.addAll({
      'fileName': fileName,
      'folderName': 'parkingarea',
      'subFolderName': subFolderName,
    });

    formData.files.add(await http.MultipartFile.fromPath(
      'file',
      imgPath,
    ));

    // Send the request
    var response = await formData.send();

    // Check the response
    if (response.statusCode == 200) {
      String imgURL =
          'https://parkingadmindata.s3.ap-southeast-1.amazonaws.com/parkingarea/$subFolderName/$fileName';
      return imgURL;
    } else {
      // ignore: avoid_print
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  Future<bool> registerAreaDocument(
      String parkingID,
      String parkingPictureURL,
      String titleDeedURL,
      String landCertificateURL,
      String idCardURL,
      int totalParkingCount,
      int price,
      List overViewPictureURL,
      List measurementPictureURL) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      Map data = {
        "parking_picture_url": parkingPictureURL,
        "title_deed_url": titleDeedURL,
        "land_certificate_url": landCertificateURL,
        "id_card_url": idCardURL,
        "total_parking_count": totalParkingCount,
        "price": price,
        "over_view_picture_url": overViewPictureURL,
        "measurement_picture_url": measurementPictureURL,
      };
      String body = json.encode(data);
      final url = Uri.parse(
          '${dotenv.env['HOST']}/provider/register_area_document?parking_id=$parkingID');
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
          body: body);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<List<ParkingSpot>> getMyArea() async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    List<ParkingSpot> parkingList = [];
    try {
      final url = Uri.parse('${dotenv.env['HOST']}/provider/my_area');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['data'];

        parkingList =
            jsonList.map((json) => ParkingSpot.fromJson(json)).toList();
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return parkingList;
  }

  double calculateAverageReviewScore(reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }

    double totalScore = 0.0;
    for (var review in reviews) {
      totalScore += review['review_score'];
    }

    return totalScore / reviews.length;
  }

  Future<bool> updateParkingAreaPrice(String parkingID, int price) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final url = Uri.parse(
          '${dotenv.env['HOST']}/provider/update_price?parking_id=$parkingID&price=$price');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return false;
  }

  Future<bool> updateParkingAreaOpenStatus(
      String parkingID, int timeClose, String status) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      Map data = {
        "_id": parkingID,
        "type": "normal",
        "range": timeClose,
        "status": status,
      };
      String body = json.encode(data);
      final url =
          Uri.parse('${dotenv.env['HOST']}/provider/area_quick_open_status');
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
          body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return false;
  }

  Future<bool> updateParkingAreaDailyOpenStatus(
      String parkingID, List daySelect, int openTime, int closeTime) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      Map data = {
        "_id": parkingID,
        "type": "normal",
      };
      Map<String, Map<String, int>> dayTimes = {};

      for (String day in daySelect) {
        dayTimes[day] = {"open_time": openTime, "close_time": closeTime};
      }
      data.addAll(dayTimes);
      String body = json.encode(data);
      final url =
          Uri.parse('${dotenv.env['HOST']}/provider/area_daily_open_status');
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
          body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return false;
  }

  Future getProfit(String type, String parkingIDList) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final url = Uri.parse(
          '${dotenv.env['HOST']}/provider/profit?query_type=$type&list_parking_id=$parkingIDList');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json;
      } else {
        return {};
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return {};
  }

  String sumAllParkingAreaID(List<ParkingSpot> parkingAreaList) {
    String idsAsString =
        parkingAreaList.map((map) => map.parkingID.toString()).join(',');
    return idsAsString;
  }

  int sumAllParkingArea(Map<dynamic, dynamic> profit) {
    int totalSum = 0;
    for (var entry in profit['date']) {
      totalSum += entry['sum'] as int;
    }
    return totalSum;
  }

  Future<bool> approveReseveInAdvance(String callBackUrl) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final url = Uri.parse(callBackUrl);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print("Error getting history: $e");
    }
    return false;
  }
}
