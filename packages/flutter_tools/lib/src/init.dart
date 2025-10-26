// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library sky_tools.init;

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:mustache4dart/mustache4dart.dart' as mustache;
import 'package:path/path.dart' as p;

import 'common.dart';

class InitCommandHandler extends CommandHandler {
  InitCommandHandler() : super('init', 'Create a new sky project.');

  ArgParser get parser {
    // TODO: Add a --template option for template selection when we have more than one.
    ArgParser parser = new ArgParser();
    parser.addFlag('help',
        abbr: 'h', negatable: false, help: 'Display this help message.');
    parser.addOption('out', abbr: 'o', help: 'The output directory.');
    parser.addFlag('pub', defaultsTo: true,
        help: 'Whether to run pub after the project has been created.');
    return parser;
  }

  Future processArgResults(ArgResults results) async {
    if (results['help']) {
      printUsage();
      return new Future.value();
    }

    if (!results.wasParsed('out')) {
      printUsage('No option specified for the output directory.');
      return new Future.value();
    }

    // TODO: Confirm overwrite of an existing directory with the user.
    Directory out = new Directory(results['out']);

    new SkySimpleTemplate().generateInto(out);

    print('');

    String message = '''All done! To run your application:

  cd ${out.path}
  ./packages/sky/sky_tool start

Or if the Sky APK is not already on your device, run:

  ./packages/sky/sky_tool start --install

  ''';

    if (results['pub']) {
      print("Running pub get...");
      Process process = await Process.start('pub', ['get'], workingDirectory: out.path);
      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);
      int code = await process.exitCode;
      if (code == 0) {
        print('\n${message}');
      }
    } else {
      print(message);
    }
  }
}

abstract class Template {
  final String name;
  final String description;

  Map<String, String> files = {};

  Template(this.name, this.description);

  void generateInto(Directory dir) {
    String projectName = _normalizeProjectName(p.basename(dir.path));
    print('Creating ${p.basename(projectName)}...');
    dir.createSync(recursive: true);

    files.forEach((String path, String contents) {
      Map m = {
        'projectName': projectName,
        'description': description
      };
      contents = mustache.render(contents, m);
      File file = new File(p.join(dir.path, path));
      file.parent.createSync();
      file.writeAsStringSync(contents);
      print(file.path);
    });
  }

  String toString() => name;
}

class SkySimpleTemplate extends Template {
  SkySimpleTemplate() : super('sky-simple', 'A minimal Sky project.') {
    files['.gitignore']= _gitignore;
    files['pubspec.yaml']= _pubspec;
    files['README.md']= _readme;
    files['lib/main.dart']= _libMain;
  }
}

String _normalizeProjectName(String name) {
  name = name.replaceAll('-', '_').replaceAll(' ', '_');
  // Strip any extension (like .dart).
  if (name.contains('.')) {
    name = name.substring(0, name.indexOf('.'));
  }
  return name;
}

const _gitignore = r'''
.DS_Store
.idea
.packages
.pub/
build/
packages
pubspec.lock
''';

const _readme = r'''
# {{projectName}}

{{description}}

## Getting Started

For help getting started with Sky, view our online
[documentation](https://github.com/domokit/sky_engine/blob/master/sky/packages/sky/README.md).
''';

const _pubspec = r'''
name: {{projectName}}
description: {{description}}
dependencies:
  sky: any
  sky_tools: any
''';

const _libMain = r'''
import 'package:sky/widgets.dart';

void main() => runApp(new HelloWorldApp());

class HelloWorldApp extends App {
  Widget build() {
    return new Scaffold(
        toolbar: new ToolBar(center: new Text("Sky Demo")),
        body: new Material(child: new Center(child: new Text("Hello world!"))),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(type: 'content/add', size: 24)));
  }
}
''';
