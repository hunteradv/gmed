// ignore: file_names
import 'measure.dart';

class DrugDto {
  String? name;
  String? leaflet;
  Measure? measure;
  DateTime? initialDate;
  DateTime? finalDate;
  String? note;
  String? drugId;
  String? date;

  DrugDto(
      {this.name,
      this.leaflet,
      this.measure,
      this.initialDate,
      this.finalDate,
      this.note,
      this.drugId,
      this.date});
}
