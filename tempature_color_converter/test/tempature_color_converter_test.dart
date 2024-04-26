import 'package:flutter_test/flutter_test.dart';

import 'package:tempature_color_converter/tempature_color_converter.dart';

void main() {
  test('adds one to input values', () {
    final color = TempatureColorConverter.temperatureToColor(1000);
    print(color);
  });
}
