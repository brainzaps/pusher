import 'package:args/args.dart';

enum Flavour { dev, prod, stg }

const _kConfigName = 'pusher_config.yaml';

class Arguments {
  static const configName = 'config_name';
  static const flavour = 'flavour';
}

class ArgumentParser {
  Future<ArgResults> parse(List<String> args) async {
    final parser = ArgParser()
      ..addOption(Arguments.configName, abbr: 'p', defaultsTo: _kConfigName)
      ..addOption(Arguments.flavour, abbr: 'f', defaultsTo: Flavour.dev.name);

    return parser.parse(args);
  }
}
