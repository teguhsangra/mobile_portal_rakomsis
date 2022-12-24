import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://178.128.126.205:3014/api/';
  // 192.168.1.2 is my IP, change with your IP address
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString("token") ?? "\"\"");
  }

  auth(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }


  postUrl(apiURL, data) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),headers: _setHeaders());
  }


  putUrl(apiURL, data) async {
    var fullUrl = _url + apiURL;
    await _getToken();
    return await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }



  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}