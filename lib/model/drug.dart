import 'package:gmed/model/measure.dart';

class Drug {
  final String name;
  final String? leaflet;
  final DateTime initialDate;
  final DateTime finaldate;
  final Measure measure;
  final String? note;

  Drug(
      {required this.name,
      required this.leaflet,
      required this.initialDate,
      required this.finaldate,
      required this.measure,
      required this.note});
}
