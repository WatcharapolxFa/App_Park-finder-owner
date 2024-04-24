import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parking_finder_app_provider/models/profile_modal.dart';

class ProfileService {
  final FlutterSecureStorage _storage;
  final String? _apiHost;

  ProfileService()
      : _storage = const FlutterSecureStorage(),
        _apiHost = dotenv.env['HOST'];

  Future<Profile?> getProfile() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      Profile profile;
      try {
        final url = Uri.parse('$_apiHost/provider/profile');
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
        );
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body)['profile'];
          profile = Profile.fromJson(json);
          await updateProfile(profile);
          return profile;
        }
      } catch (e) {
        // Handle error
      }
    }
    return null;
  }

  Future<void> updateProfile(Profile profileData) async {
    String? firstName = await _storage.read(key: 'firstName');
    String? lastName = await _storage.read(key: 'lastName');
    String? email = await _storage.read(key: 'email');
    String? pictureURL = await _storage.read(key: 'pictureURL');

    if (profileData.firstName != firstName) {
      await _storage.write(key: 'firstName', value: profileData.firstName);
    }
    if (profileData.lastName != lastName) {
      await _storage.write(key: 'lastName', value: profileData.lastName);
    }
    if (profileData.email != email) {
      await _storage.write(key: 'email', value: profileData.email);
    }
    if (profileData.profilePictureURL != pictureURL) {
      await _storage.write(
          key: 'pictureURL', value: profileData.profilePictureURL);
    }
  }

  Future<void> clearAccessToken() async {
    await _storage.delete(key: 'accessToken');
  }

  Future uploadBankIMG(
      String profileID, String imgPath) async {
    var formData = http.MultipartRequest(
        'POST', Uri.parse('http://34.125.122.199:3100/api/aws_s3'));

    formData.fields.addAll({
      'fileName': "accountBookIMG",
      'folderName': 'profile',
      'subFolderName': profileID,
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
          'https://parkingadmindata.s3.ap-southeast-1.amazonaws.com/profile/$profileID/accountBookIMG';
      return imgURL;
    } else {
      // ignore: avoid_print
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  Future<bool> updateBankAccount(String accountBookImageUrl, String bankName,
      String accountName, String accountNumber) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      try {
        Map data = {
          "account_book_image_url": accountBookImageUrl,
          "bank_name": bankName,
          "account_name": accountName,
          "account_number": accountNumber,
        };
        String body = json.encode(data);
        final url = Uri.parse('$_apiHost/provider/bank_account');
        final response = await http.patch(url,
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken'
            },
            body: body);
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      } catch (e) {
        // Handle error
        return false;
      }
    }
    return false;
  }
}
