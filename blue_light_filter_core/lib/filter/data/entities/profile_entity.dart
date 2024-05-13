class ProfileEntity {
  int id;
  String name;
  int colorTemperature;
  int colorIntensity;
  int screenDim;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.colorTemperature,
    required this.colorIntensity,
    required this.screenDim,
  });

  factory ProfileEntity.create({
    required String name,
    required int colorTemperature,
    required int colorIntensity,
    required int screenDim,
  }) {
    return ProfileEntity(
      id: 0,
      name: name,
      colorTemperature: colorTemperature,
      colorIntensity: colorIntensity,
      screenDim: screenDim,
    );
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      id: map['id'],
      name: map['name'],
      colorTemperature: map['color_temperature'],
      colorIntensity: map['color_intensity'],
      screenDim: map['screen_dim'],
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      //'id': id,
      'name': name,
      'color_temperature': colorTemperature,
      'color_intensity': colorIntensity,
      'screen_dim': screenDim,
    };
  }
}
