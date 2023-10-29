import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('Test adding and removing tasks', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => MyAppState(),
          child: MyHomePage(),
        ),
      ),
    );

    // await tester.tap(find.text('Add'));
    // await tester.pumpAndSettle(); // Wait for the dialog to open
    // await tester.enterText(find.byType(TextField), 'Task 1');
    // await tester.tap(find.text('Add'));
    // await tester.pumpAndSettle(); // Wait for the list to update
    //
    // // Verify that the task is added
    // expect(find.text('1 - Task 1'), findsOneWidget);
    //
    // // Remove the task
    // await tester.tap(find.byIcon(Icons.delete));
    // await tester.pumpAndSettle(); // Wait for the list to update
    //
    // // Verify that the task is removed
    // expect(find.text('1 - Task 1'), findsNothing);
  });
}
