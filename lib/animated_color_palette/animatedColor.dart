
import 'package:sportifylife/animated_color_palette/paletteController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AnimatedColorPalette extends StatelessWidget {
  const AnimatedColorPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final PaletteController controller = Get.put(PaletteController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Palette Generator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (Color color in controller.currentPalette)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linearToEaseOut,
                  width: 100,
                  height: 100,
                  color: color,
                  margin: const EdgeInsets.all(8),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.regeneratePalette,
                child: const Text(
                  'Generate New Palette',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}