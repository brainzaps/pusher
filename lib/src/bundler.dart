import 'dart:io';

import 'package:pusher/pusher.dart';

class Bundler {
  static Future<void> run({required Config config}) async {
    final dir = File(Platform.script.toFilePath()).parent;
    final script = '${dir.path}/scripts/distribute.sh';

    final androidArgs = [
      '--android_token',
      config.android.token,
      '--android_project',
      config.android.projectName,
      '--apk',
      config.android.artifact
    ];

    final iosArgs = [
      '--ios_token',
      config.ios.token,
      '--ios_project',
      config.ios.projectName,
      '--ipa',
      config.ios.artifact
    ];

    await Process.run('chmod', ['+x', script]);

    final arguments = iosArgs + androidArgs;

    final process =
        await Process.start('bash', [script] + arguments, runInShell: true);

    process.stdout.pipe(stdout);
    process.stderr.pipe(stderr);
  }
}
