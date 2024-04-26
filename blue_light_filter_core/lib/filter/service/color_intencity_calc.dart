import 'dart:math';
import 'dart:ui';

class ColorIntencityCalc {
  // Функція для перетворення інтенсивності кольору у RGB значення
Color intensityToColor(Color color, int intensityPercent) {
  // Перетворюємо відсоток інтенсивності в діапазон від 0 до 255
  int intensity = (255 * intensityPercent / 100).round();

  // Для заданого кольору з вказаною інтенсивністю
  int red = min(color.red + intensity, 255);
  int green = min(color.green + intensity, 255);
  int blue = min(color.blue + intensity, 255);
  Color resultColor = Color.fromARGB(255, red, green, blue);

  // Повертаємо результат
  return resultColor;
}
}
