import 'package:pusher/pusher.dart';

Future<void> main(List<String> args) async {
  final parsed = await ArgumentParser().parse(args);

  final flavour = parsed[Arguments.flavour];
  final configName = parsed[Arguments.configName];

  final config = await ConfigParser().parse(
    flavour: flavour,
    configName: configName,
  );

  await Bundler.run(config: config);
}
