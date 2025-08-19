import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_zoom_reset/auto_zoom_reset.dart';

void main() {
  group('AutoZoomReset Widget Tests', () {
    testWidgets('AutoZoomReset renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('AutoZoomReset with zoom indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              showZoomIndicator: true,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('AutoZoomReset callbacks work', (WidgetTester tester) async {
      bool zoomStarted = false;
      bool zoomEnded = false;
      double currentScale = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              onZoomStart: () => zoomStarted = true,
              onZoomEnd: () => zoomEnded = true,
              onResetStart: () {}, // Test callback exists
              onResetComplete: () {}, // Test callback exists
              onScaleChanged: (scale) => currentScale = scale,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      // Initial state
      expect(zoomStarted, false);
      expect(zoomEnded, false);
      expect(currentScale, 1.0);
    });

    testWidgets('AutoZoomReset with custom configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              resetDuration: const Duration(milliseconds: 200),
              resetDelay: const Duration(milliseconds: 300),
              resetCurve: Curves.bounceOut,
              minScale: 0.5,
              maxScale: 5.0,
              constrained: false,
              zoomEnabled: true,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.purple,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('AutoZoomReset with zoom disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              zoomEnabled: false,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('AutoZoomReset with immediate reset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              resetDelay: Duration.zero,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.cyan,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
    });
  });

  group('SimpleAutoZoomReset Widget Tests', () {
    testWidgets('SimpleAutoZoomReset renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleAutoZoomReset(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SimpleAutoZoomReset), findsOneWidget);
      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('SimpleAutoZoomReset with indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleAutoZoomReset(
              showIndicator: true,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.amber,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SimpleAutoZoomReset), findsOneWidget);
      expect(find.byType(AutoZoomReset), findsOneWidget);
    });

    testWidgets('SimpleAutoZoomReset without indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleAutoZoomReset(
              showIndicator: false,
              child: Container(
                width: 120,
                height: 120,
                color: Colors.pink,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SimpleAutoZoomReset), findsOneWidget);
      expect(find.byType(AutoZoomReset), findsOneWidget);
    });
  });

  group('Widget Integration Tests', () {
    testWidgets('AutoZoomReset with Image widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              showZoomIndicator: true,
              child: Image.asset(
                'test_assets/test_image.png',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('AutoZoomReset with Text widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              child: const Text(
                'This is a test text that can be zoomed',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(
          find.text('This is a test text that can be zoomed'), findsOneWidget);
    });

    testWidgets('AutoZoomReset with complex child widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              showZoomIndicator: true,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ),
                  const Text('Complex Widget'),
                  const Icon(Icons.star),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.text('Complex Widget'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('Edge Cases and Error Handling', () {
    testWidgets('AutoZoomReset with null callbacks',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              onZoomStart: null,
              onZoomEnd: null,
              onResetStart: null,
              onResetComplete: null,
              onScaleChanged: null,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
    });

    testWidgets('AutoZoomReset with extreme scale values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              minScale: 0.1,
              maxScale: 10.0,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
    });

    testWidgets('AutoZoomReset with very short durations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoZoomReset(
              resetDuration: const Duration(milliseconds: 1),
              resetDelay: const Duration(milliseconds: 1),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AutoZoomReset), findsOneWidget);
    });
  });
}
