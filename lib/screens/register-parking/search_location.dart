import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/screens/register-parking/parking_document.dart';
import '../../assets/colors/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({
    super.key,
    required this.currentPosition,
    required this.houseNumber,
    required this.group,
    required this.village,
    required this.alley,
    required this.road,
    required this.postCode,
    required this.subDistrict,
    required this.district,
    required this.province,
    required this.nearbyPlaces,
    required this.nameParking,
  });

  final Position currentPosition;
  final String houseNumber;
  final String group;
  final String village;
  final String alley;
  final String road;
  final String postCode;
  final String subDistrict;
  final String district;
  final String province;
  final String nearbyPlaces;
  final String nameParking;

  @override
  SearchLocationState createState() => SearchLocationState();
}

class SearchLocationState extends State<SearchLocationScreen> {
  final storage = const FlutterSecureStorage();
  final _controller = FloatingSearchBarController();
  late GoogleMapController mapController;
  List<dynamic> placesList = [];
  final List<Marker> markers = [];
  late Map placeLocation;
  Position? _currentPosition;
  late LatLng selectPosition;
  bool isSelectPosition = false;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
      }).catchError((e) {
        debugPrint(e);
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 18)));
    } catch (e) {
      //Failed to get data from Geocoding
    }
  }

  void getSuggestion(String input) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&language=th&location=13.736717,100.523186&radius=50000&key=${dotenv.env['placeAPIkey']}';

      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          placesList = jsonDecode(response.body.toString())['predictions'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      //Failed to load data from Google Place API
    }
  }

  void searchLocation(String placeId) async {
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request =
          '$baseURL?fields=geometry&place_id=$placeId&key=${dotenv.env['placeAPIkey']}';
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          placeLocation = jsonDecode(response.body.toString())['result']
              ['geometry']['location'];
        });
      } else {
        throw Exception('Failed to load data');
      }

      final Position searchPosition = Position(
          longitude: placeLocation['lng'],
          latitude: placeLocation['lat'],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0);

      setState(() {
        isSelectPosition = true;
        selectPosition =
            LatLng(searchPosition.latitude, searchPosition.longitude);
      });
      changeCameraGoogleMap(searchPosition);
    } catch (e) {
      //Failed to load data from Google Place API
    }
  }

  void changeCameraGoogleMap(Position latlang) {
    if (markers.isNotEmpty) {
      markers.clear();
    }
    addMakerPress(LatLng(latlang.latitude, latlang.longitude));
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latlang.latitude, latlang.longitude), zoom: 18)));
  }

  void addMakerPress(LatLng latlang) {
    setState(() {
      markers.add(
          Marker(markerId: MarkerId(latlang.toString()), position: latlang));
    });
  }

  void handleRegistration() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      EasyLoading.show();
      Map data = {
        "parking_name": widget.nameParking,
        "address_text":
            "${widget.houseNumber} ${widget.group} ${widget.village} ${widget.alley} ${widget.road}",
        "sub_district": widget.subDistrict,
        "district": widget.district,
        "province": widget.province,
        "postal_code": widget.postCode,
        "tag": widget.nearbyPlaces.replaceAll(" ", "").split(","),
        "latitude": selectPosition.latitude,
        "longitude": selectPosition.longitude,
      };
      String body = json.encode(data);

      final url =
          Uri.parse('${dotenv.env['HOST']}/provider/register_area_location');

      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: body,
        );
        EasyLoading.dismiss();
        if (!mounted) return;
        
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          // ส่ง OTP ใหม่สำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('กรอกข้อมูลสถานที่จอดเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ParkingDocumentScreen(parkingID: json['parking_id'])));
        } else {
          // การส่งไม่สำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('กรอกข้อมูลสถานที่ไม่สำเร็จ')),
          );
        }
      } catch (e) {
        // การเชื่อมต่อมีปัญหา
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('เกิดข้อผิดพลาดในการติดต่อกับเซิร์ฟเวอร์')),
        );
      }
    } else {
      // ไม่มี accessToken
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('แผนที่'),
        centerTitle: true,
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.currentPosition.latitude,
                  widget.currentPosition.longitude),
              zoom: 18,
            ),
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: false,
            markers: markers.toSet(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (latlang) async {
              if (markers.isNotEmpty) {
                markers.clear();
              }

              setState(() {
                isSelectPosition = true;
                selectPosition = latlang;
              });

              addMakerPress(latlang);
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: latlang,
                      zoom: 18)));
            },
          ),
          FloatingSearchBar(
              hint: 'ค้นหาที่จอดรถ',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 500),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              openAxisAlignment: 0.0,
              width: MediaQuery.of(context).size.width - 80,
              debounceDelay: const Duration(milliseconds: 500),
              controller: _controller,
              automaticallyImplyBackButton: false,
              onQueryChanged: (query) {
                getSuggestion(query);
              },
              clearQueryOnClose: false,
              transition: CircularFloatingSearchBarTransition(),
              leadingActions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(
                      Icons.place,
                      color: Color(0xFFA6AAB4),
                    ),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.back(
                  showIfClosed: false,
                )
              ],
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: true,
                  child: CircularButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFFA6AAB4),
                    ),
                    onPressed: () {
                      if (markers.isNotEmpty) {
                        markers.clear();
                      }
                      _controller.clear();
                    },
                  ),
                ),
              ],
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: placesList.map((location) {
                        if (location.containsKey('description')) {
                          return InkWell(
                            onTap: () async {
                              searchLocation(location['place_id']);
                              _controller.close();
                              setState(() {
                                _controller.query = location['description'];
                                // _showLocationList = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    color: Color(0xFFA6AAB4),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      location['description'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    ),
                  ),
                );
              }),
          Visibility(
            visible: isSelectPosition,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 95,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: BlueButton(
                    label: "ต่อไป",
                    onPressed: () {
                      handleRegistration();
                    },
                  )),
            ),
          )
        ],
      )),
      floatingActionButton: Visibility(
          visible: !isSelectPosition,
          child: FloatingActionButton(
            backgroundColor: AppColor.appPrimaryColor,
            onPressed: () {
              getCurrentPosition();
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          )),
    );
  }
}
