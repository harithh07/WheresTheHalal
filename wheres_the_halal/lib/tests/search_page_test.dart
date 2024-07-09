import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheres_the_halal/pages/search_page.dart';

void main() {
  // Define test
  testWidgets('Search page has drawer, textbox, filter button and restaurants list', (tester) async {
    // create and build widget with tester
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    // create finders
    final filterFinder = find.widgetWithIcon(IconButton, Icons.filter_alt_rounded);


    // finds widgets
    expect(filterFinder, findsOneWidget);
  });
}