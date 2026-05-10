import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mighty_delivery/extensions/colors.dart';

void main() {
  test('createMaterialColor retourne un swatch cohérent', () {
    final MaterialColor swatch = createMaterialColor(const Color(0xFF334155));

    expect(swatch[500], isNotNull);
    expect(swatch.toARGB32(), const Color(0xFF334155).toARGB32());
  });
}

