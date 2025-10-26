// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/src/executable.dart' as executable;
import 'package:sky_tools/src/test/loader.dart' as loader;

main(List<String> args) {
  loader.installHook();
  return executable.main(args);
}
