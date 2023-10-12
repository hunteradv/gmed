import '../model/measure.dart';

class DrugMeasureRepository {
  String getTranslatedMeasure(Measure measure) {
    switch (measure) {
      case Measure.capsule:
        return "cápsula(s)";
      case Measure.milliliter:
        return "mililitro(s)";
      case Measure.teaspoon:
        return "colher(es) de Chá";
      case Measure.pill:
        return "comprimido(s)";
      default:
        return "desconhecido";
    }
  }

  String getAbrevTranslatedMeasure(Measure measure) {
    switch (measure) {
      case Measure.capsule:
        return "cap(s)";
      case Measure.milliliter:
        return "ml(s)";
      case Measure.teaspoon:
        return "col(s)";
      case Measure.pill:
        return "comp(s)";
      default:
        return "desc";
    }
  }
}
