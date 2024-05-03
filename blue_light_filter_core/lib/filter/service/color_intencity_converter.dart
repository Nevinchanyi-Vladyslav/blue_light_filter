import 'dart:ui';

class ColorIntencityConverter {
  Color convertColorIntensity(Color color, double intensity) {
    //final alpha = color.alpha;
    final red = color.red;
    final green = color.green;
    final blue = color.blue;

    final newAlpha = (intensity * 255).round();
    // final newRed = (red * intensity + (1 - intensity) * 255).round();
    // final newGreen = (green * intensity + (1 - intensity) * 255).round();
    // final newBlue = (blue * intensity + (1 - intensity) * 255).round();

    return Color.fromARGB(
      newAlpha.clamp(0, 255),
      red,
      green,
      blue,
      // newRed.clamp(0, 255),
      // newGreen.clamp(0, 255),
      // newBlue.clamp(0, 255),
    );
  }
}
