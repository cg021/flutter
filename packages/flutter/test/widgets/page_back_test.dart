// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class TestBack extends StatefulWidget {
  TestBack({Key key}) : super(key: key);

  @override
  _TestBackState createState() => _TestBackState();
}

class _TestBackState extends State<TestBack> {
  Future<void> _openUrl(String url, {Brightness statusBarBrightness}) async {
    if (url == null || !(await canLaunch(url))) {
      return;
    }

    await launch(
      url,
      forceWebView: true,
      statusBarBrightness: statusBarBrightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _openUrl(
                'https://flutter.dev',
                statusBarBrightness: Brightness.light,
              ),
              child: const Text('withBrightness'),
            ),
            RaisedButton(
              onPressed: () => _openUrl('https://flutter.dev'),
              child: const Text('withoutBrightness'),
            ),
            BackButton(),
          ],
        ),
      ),
    );
  }
}

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.resetEpoch();
  });

  testWidgets('Checks automatic system ui adjustment', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: TestBack()
        )
    );

    await tester.tap(find.text('withBrightness'));
    await tester.pageBack();

    final RenderView brightView = WidgetsBinding.instance.renderView;
    expect(brightView.automaticSystemUiAdjustment, true);
    await tester.pump();

    await tester.tap(find.text('withoutBrightness'));
    await tester.pageBack();

    final RenderView noBrightView = WidgetsBinding.instance.renderView;
    expect(noBrightView.automaticSystemUiAdjustment, true);
  });
}
