import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

/// Page indicator widget with animated dots
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentPage == index ? 32.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: currentPage == index
                ? ColorPalette.kPrimary
                : ColorPalette.kMediumGray,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
