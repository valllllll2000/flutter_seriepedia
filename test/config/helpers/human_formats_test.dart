import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing HumanFormats class', () {
    test('Format should use correct decimals', () {
      var formatted = HumanFormats.number(10.5555, 1);
      expect(formatted, '10.6');
    });
    test('Format should use correct format', () {
      var formatted = HumanFormats.number(10000, 0);
      expect(formatted, '10K');
    });
  });
}
