class ConfigKeys {
  static const token = 'token';
  static const projectName = 'project_name';
  static const artifact = 'artifact';
}

class Config {
  Config({required this.android, required this.ios});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      android: ConfigParameters.fromJson(json['android']),
      ios: ConfigParameters.fromJson(json['ios']),
    );
  }

  final ConfigParameters android;
  final ConfigParameters ios;

  @override
  String toString() {
    return 'Config(android: $android, ios: $ios)';
  }
}

class ConfigParameters {
  ConfigParameters({
    required this.token,
    required this.projectName,
    required this.artifact,
  });

  factory ConfigParameters.fromJson(Map<String, dynamic> json) {
    return ConfigParameters(
      token: json[ConfigKeys.token],
      projectName: json[ConfigKeys.projectName],
      artifact: json[ConfigKeys.artifact],
    );
  }

  final String token;
  final String projectName;
  final String artifact;

  @override
  String toString() {
    return 'ConfigParameters(token: $token, projectName: $projectName, bundlePath: $artifact)';
  }
}
