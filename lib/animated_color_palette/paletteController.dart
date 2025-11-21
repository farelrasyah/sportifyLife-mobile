import 'package:get/get.dart';

import 'dart:math';
import 'package:flutter/material.dart';

class PaletteController extends GetxController {
  var currentPalette = <Color>[].obs;

  @override
  void onInit() {
    super.onInit();
    regeneratePalette();
  }

  void regeneratePalette() {
    final random = Random();
    currentPalette.value = List.generate(
      5,
          (_) => Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      ),
    );
  }
}