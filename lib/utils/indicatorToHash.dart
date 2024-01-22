import 'dart:convert';

int indicatorToHash(String indicator, Map<String, int> colours) {
  int _sum = 0;

  var foo = utf8.encode(indicator);
  for (var k in foo) {
    _sum += k;
  }
  colours[indicator] = _sum;
  return _sum;
}
