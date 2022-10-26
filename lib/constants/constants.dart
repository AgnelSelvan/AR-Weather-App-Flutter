class Constants {
  ///Model DIR
  static const modelDir = "model.scnassets/";

  /// Models
  static const clear = "clear";
  static const partiallyCloud = "partially_cloud";
  static const cloudy = "cloudy";
  static const rain = "rain";
  static const snow = "snow";
  static const thunder = "thunder";
  static const sunny = "sunny";

  static String getModelsByWeatherCategory(String category) {
    final categoryName = category.toLowerCase();
    String modelPath = modelDir;
    if (categoryName.contains("mist") ||
        categoryName.contains("cloudy") ||
        categoryName.contains("cloud")) {
      modelPath += cloudy;
    } else if (categoryName.contains("clear")) {
      modelPath += clear;
    } else if (categoryName.contains("partial")) {
      modelPath += partiallyCloud;
    } else if (categoryName.contains("rain")) {
      modelPath += rain;
    } else if (categoryName.contains("winter") ||
        categoryName.contains("snow")) {
      modelPath += snow;
    } else if (categoryName.contains("thunder") ||
        categoryName.contains("storm")) {
      modelPath += thunder;
    } else if (categoryName.contains("sunny") ||
        categoryName.contains("summer")) {
      modelPath += sunny;
    }

    return "$modelPath.dae";
  }
}
