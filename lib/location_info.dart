import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserLocationText extends StatefulWidget {
  const UserLocationText({super.key});

  @override
  State<UserLocationText> createState() => _UserLocationTextState();
}

class _UserLocationTextState extends State<UserLocationText> {
  String _location = "Getting location...";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _location = "Getting location...";
    });

    try {
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) throw Exception("Permission denied");

      Position? position = await _getLastKnownPosition();
      position ??= await _getCurrentPosition();

      if (position == null) throw Exception("Position unavailable");

      final address = await _getAddress(position.latitude, position.longitude);

      setState(() {
        _location = "location: $address";
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _location = "location: Unable to fetch";
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (_) {
      return false;
    }
  }

  Future<Position?> _getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  Future<Position> _getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 30),
    );
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    try {
      return await _getAddressFromNominatim(latitude, longitude);
    } catch (_) {
      return await _getAddressFromBigDataCloud(latitude, longitude);
    }
  }

  Future<String> _getAddressFromNominatim(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&addressdetails=1');
    final response = await http.get(url, headers: {'User-Agent': 'Flutter App'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];

      String city = address['city'] ?? address['town'] ?? address['village'] ?? 'Unknown City';
      String state = address['state'] ?? address['province'] ?? 'Unknown State';
      String pincode = address['postcode'] ?? 'Unknown';

      return "$city, $state - $pincode";
    } else {
      throw Exception('Nominatim failed');
    }
  }

  Future<String> _getAddressFromBigDataCloud(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      String city = data['city'] ?? data['locality'] ?? 'Unknown City';
      String state = data['principalSubdivision'] ?? 'Unknown State';
      String pincode = data['postcode'] ?? 'Unknown';

      return "$city, $state - $pincode";
    } else {
      throw Exception('BigDataCloud failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          _location,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
