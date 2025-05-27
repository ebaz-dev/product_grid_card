import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_grid_card/product_grid_card.dart';

void main() {
  testWidgets('ProductGridCardV2 renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ProductGridCardV2(
              image: 'https://example.com/product.jpg',
              title: 'Test Product',
              subtitle: 'Test Description',
              price: 100.0,
              discountPercent: 20,
              productId: 'test123',
            ),
          ),
        ),
      ),
    );

    // Шалгах зүйлс
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('\$80.00'), findsOneWidget); // 20% off from 100
    expect(find.text('\$100.00'), findsOneWidget);
    expect(find.text('-20%'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Tapping the card navigates using GoRouter', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: ProductGridCardV2(
              image: '',
              title: 'Click Me',
              subtitle: '',
              price: 100,
              discountPercent: 0,
              productId: 'click',
            ),
          ),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            return Text('Product ID: ${state.pathParameters['id']}');
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // click
    await tester.tap(find.byType(ProductGridCardV2));
    await tester.pumpAndSettle();

    expect(find.text('Product ID: click'), findsOneWidget);
  });
}
