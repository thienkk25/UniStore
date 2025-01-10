import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:uni_store/keys.dart';

class StripeService {
  Future<String> makePayment(double amount) async {
    try {
      final paymentIntent = await createPaymentIntent(amount.ceil());
      if (paymentIntent == "Error") {
        return "Error";
      }
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: true,
              merchantDisplayName: "Thien Nguyen",
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: "US",
                  currencyCode: "USD",
                  testEnv: true)));
      final display = await displayPaymentSheet();
      if (display == "Error") {
        return "Error";
      }
      return display;
    } catch (e) {
      return "Error";
    }
  }

  createPaymentIntent(int amount) async {
    try {
      amount = amount * 100;
      Map<String, dynamic> body = {
        "amount": amount.toString(),
        "currency": "usd",
        "payment_method_types[]": "card"
      };
      final response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }

  Future<String> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          await Stripe.instance.confirmPaymentSheetPayment();
        },
      );
      return "Success payment";
    } on StripeException {
      return "Cancel payment";
    } catch (e) {
      return "Error";
    }
  }
}
