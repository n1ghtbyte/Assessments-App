import 'dart:io';

String getCompetencesPath() {
  String locale = Platform.localeName.toUpperCase().substring(0, 2);
  final comp = "Competences";
  if (locale == "EN") return comp;
  if (locale == "ES") return comp + "ES";
  if (locale == "PT") return comp + "PT";
  if (locale == "EL") return comp + "EL";
  print(locale);
  return locale;
}
