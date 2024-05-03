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
      colorTemperature: map['colorTemperature'],
      colorIntensity: map['colorIntensity'],
      screenDim: map['screenDim'],
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      //'id': id,
      'name': name,
      'colorTemperature': colorTemperature,
      'colorIntensity': colorIntensity,
      'screenDim': screenDim,
    };
  }
}
