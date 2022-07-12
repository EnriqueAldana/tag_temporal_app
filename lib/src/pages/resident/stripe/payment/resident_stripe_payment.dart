import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class ResidentStripePayment extends GetConnect{

  Map<String,dynamic>? paymentIntentData;


  Future<void> makePayment(BuildContext context) async {
    try {
      print('Entrando a hacer pago Stripe - contexto ${context}');
      paymentIntentData = await createPaymentIntent('15', 'MXN');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        applePay: true,
        googlePay: true,
        testEnv: true,
        style: ThemeMode.dark,
        merchantCountryCode: 'MX',
        merchantDisplayName: 'tagTemporal App'
      )
      ).then((value) => {

      });

      showPaymentSheet(context);
    }catch(er){
      print('Error: ${er}');
    }
  }

  showPaymentSheet(BuildContext context) async {
    try {
        await Stripe.instance.presentPaymentSheet().then((value) => {
          Get.snackbar('Transacción exitosa', 'Tu pago fué procesado exitosamente..'),
          paymentIntentData= null
        });
    }on StripeException catch(err){
      print('Error Stripe ${err}');
      showDialog(context: context, builder: (value) => AlertDialog(
        content: Text('Operación cancelada'),
      ));
    }
  }
  createPaymentIntent(String amount, String currency ) async {

    try {
      Map<String, dynamic> body= {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('http://api.stripe.com/v1/payment_instents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51LK7jTGOZgTCxUsd5sMgFmghSRBFS9bDTsYFSTDfm2OItmjWqATJudstcusnftPfP833tgCg4SejqyreYOrG0Pdo00rZ45cwvn',
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      );
      
      return jsonDecode(response.body);
      
    }catch(err){
      print('Error: ${err}');

    }
  }

  calculateAmount(String amount){
    final a = int.parse(amount) * 100;
    return a.toString();
  }
}