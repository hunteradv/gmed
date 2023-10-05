import 'package:gmed/model/measure.dart';

class Drug {
  final String name;
  final String leaflet;
  final DateTime? initialDate;
  final DateTime? finaldate;
  final int? optionSelected;
  final Measure? measure;

  Drug(
      {required this.name,
      required this.leaflet,
      this.initialDate,
      this.finaldate,
      required this.optionSelected,
      required this.measure});
}
