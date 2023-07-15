import 'dart:convert';
import 'dart:io';

import 'package:pusher/pusher.dart';

const _kScriptName = 'distribution.sh';

const _kScriptUrl =
    'https://raw.githubusercontent.com/lollipox/pusher/main/bin/scripts/distribute.sh';

class Bundler {
  HttpClient client = HttpClient();

  Future<String> downloadScript() async {
    final request = await client.getUrl(Uri.parse(_kScriptUrl));
    final response = await request.close();
    final script = await response.transform(utf8.decoder).join();
    final file = File(_kScriptName);
    await file.writeAsString(script);
    return file.path;
  }

  Future<void> run({required Config config}) async {
    final file = File(_kScriptName);
    var path = file.path;

    if (!file.existsSync()) {
      path = await downloadScript();
    }

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

    await Process.run('chmod', ['+x', path]);

    final arguments = iosArgs + androidArgs;

    final process =
        await Process.start('bash', [path] + arguments, runInShell: true);

    process.stdout.pipe(stdout);
    process.stderr.pipe(stderr);
  }
}
