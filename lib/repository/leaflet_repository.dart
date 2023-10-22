import 'dart:convert';

import 'package:http/http.dart' as http;

class LeafletRepository {
  Future<String> getLeafletLink(String leafletId) async {
    var url = "https://bula.vercel.app/bula?id=$leafletId";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    var leaflet = jsonData["pdf"];

    return leaflet;
  }
}
