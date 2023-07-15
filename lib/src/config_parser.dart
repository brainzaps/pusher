import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:pusher/pusher.dart';

class ConfigParser {
  Future<Config> parse({
    required String flavour,
    required String configName,
  }) async {
    final docContent = await File(configName).readAsString();

    final yml = loadYaml(docContent);

    final map = json.decode(json.encode(yml[flavour]));

    final config = Config.fromJson(map);
    return config;
  }
}
