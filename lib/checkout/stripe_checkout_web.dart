import 'dart:js';
import 'dart:js_interop';

import 'package:farmapp/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void redirectToCheckout() {
  context.callMethod('redirectToCheckout', [
    CheckoutOptions(
      lineItems: [
        LineItem(
          price: 'someIdOftheProductFromStripeDashboard',
          quantity: 1,
        )
      ],
      mode: 'payment',
      successUrl: 'http://localhost:8080/#/success',
      cancelUrl: 'http://localhost:8080/#/cancel',
    )
  ]);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external String get sessionId;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
