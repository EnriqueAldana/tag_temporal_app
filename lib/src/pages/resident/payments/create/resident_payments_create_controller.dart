import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/environment/environment.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/providers/mercado_pago_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class ResidentPaymentsCreateController extends GetxController {

  TextEditingController documentNumberController = TextEditingController();
  Order order = Order.fromJson(Get.arguments[Constants.ORDER]);
  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = false.obs;

  GlobalKey<FormState> keyForm = GlobalKey();

  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();

  MercadoPagoCardToken? mercadoPagoCardToken= MercadoPagoCardToken();
  ResidentPaymentsCreateController(){
  }

  void createCardToken() async {

    if (Environment.APP_PAYMENTS_APPLY ){

      if (isValidForm()) {
        cardNumber.value = cardNumber.value.replaceAll(RegExp(' '), '');
        List<String> list = expireDate.split('/');
        int month = int.parse(list[0]);
        String year = '20${list[1]}';

        mercadoPagoCardToken= await mercadoPagoProvider.createCardToken(
          cvvCode.value,
          year,
          month,
          cardNumber.value,
          cardHolderName.value,
        );

        if(mercadoPagoCardToken!= null){
          print('Mercado Pago: ${mercadoPagoCardToken!.toJson()}');
          print('Orden enviada a pago ${order.toJson()}');
          Get.toNamed('/resident/payments/installments', arguments: {
            'card_token': mercadoPagoCardToken!.toJson(),
            Constants.ORDER: order.toJson(),

          });
        }

      }
    }
    else {
      print('Mercado Pago: ${mercadoPagoCardToken!.toJson()}');
      Get.toNamed('/resident/payments/installments', arguments: {
        'card_token': mercadoPagoCardToken!.toJson(),
        Constants.ORDER: order.toJson(),

      });
    }


  }

  bool isValidForm () {
    if (cardNumber.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el numero de la tarjeta');
      return false;
    }
    if (expireDate.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa la fecha de vencimiento de la tarjeta');
      return false;
    }
    if (cvvCode.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el codigo de seguridad');
      return false;
    }
    if (cardHolderName.value.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del titular');
      return false;
    }


    return true;
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expireDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }



}