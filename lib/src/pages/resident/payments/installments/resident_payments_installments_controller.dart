import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/environment/environment.dart';
import 'package:tag_temporal_app/src/models/address.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_installment.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_payment.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_payment_method_installments.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/models/user.dart';



import 'package:tag_temporal_app/src/providers/mercado_pago_provider.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class ResidentPaymentsInstallmentsController extends GetxController {

  List<Product> selectedProducts = <Product>[].obs;
  MercadoPagoPaymentMethodInstallments? paymentMethodInstallments;
  List<MercadoPagoInstallment> installmentsList = <MercadoPagoInstallment>[].obs;
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  OrdersProvider ordersProvider= OrdersProvider();
  var total = 0.0.obs;
  var installments = ''.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(Get.arguments['card_token']);
  Order order = Order.fromJson(Get.arguments[Constants.ORDER]);
  MercadoPagoPayment mercadoPagoPayment= MercadoPagoPayment();


  ResidentPaymentsInstallmentsController () {

    if (GetStorage().read(Constants.SHOPPING_BAG_KEY) != null) {

      if (GetStorage().read(Constants.SHOPPING_BAG_KEY) is List<Product>) {
        var result = GetStorage().read(Constants.SHOPPING_BAG_KEY);
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      else {
        var result = Product.fromJsonList(GetStorage().read(Constants.SHOPPING_BAG_KEY));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }

      getTotal();
      getInstallments();
    }
  }

  void createPayment() async {

    if (Environment.APP_PAYMENTS_APPLY ){
      if (installments.value.isEmpty) {
        Get.snackbar('Formulario no valido', 'Selecciona el numero de pagos');
        return;
      }
      print('Orden enviada a efectuar el pago ${order.toJson()}');

      Response response = await mercadoPagoProvider.createPayment(
          token: cardToken.id,
          paymentMethodId: paymentMethodInstallments!.paymentMethodId,
          paymentTypeId: paymentMethodInstallments!.paymentTypeId,
          issuerId: paymentMethodInstallments!.issuer!.id,
          transactionAmount: total.value,
          installments: int.parse(installments.value),
          emailCustomer: user.email,
          order: order
      );

      if (response.statusCode == 201) {
        ResponseApi responseApi = ResponseApi.fromJson(response.body);
        mercadoPagoPayment= MercadoPagoPayment.fromJson(responseApi.data);

        Get.offNamedUntil('/resident/payments/status', (route) => false, arguments: {
          'mercado_pago_payment':  mercadoPagoPayment.toJson(),
          Constants.ORDER: order.toJson()
        });
      }
      else if (response.statusCode == 501){
        print('RESPONSE BODY 501: ${response.body}');

        if (response.body['error']['status'] == 400) {
          print('BODY ERROR: ${response.body['error']}');
          badRequestProcess(response.body['error']);
        }
        else {
          badTokenProcess(response.body['error']['status'], paymentMethodInstallments!);
        }
      }
    }  // Si estan habilitados los pagos
    else{
      print('Mercado pago pago ${mercadoPagoPayment.toJson() }');
      Get.offNamedUntil('/resident/payments/status', (route) => false, arguments: {
        'mercado_pago_payment':  mercadoPagoPayment.toJson(),
        Constants.ORDER: order.toJson()
      });
    }


   }

  void getInstallments() async {

    if (cardToken.firstSixDigits != null) {
      var result = await mercadoPagoProvider.getInstallments(
          cardToken.firstSixDigits!,
          total.value
      );
      paymentMethodInstallments = result;
      print('RESULT: ${result}');

      if (result.payerCosts != null) {
        installmentsList.clear();
        installmentsList.addAll(result.payerCosts!);
      }
    }
  }

  void getTotal() {
    total.value = 0.0;
    selectedProducts.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

  void badRequestProcess(dynamic data){
    Map<String, String> paymentErrorCodeMap = {
      '3034' : 'Informacion de la tarjeta invalida',
      '3033' : 'La longitud de digitos de tu tarjeta es erroneo',
      '3032' : 'La longitud de digitos de validacion es erroneo',
      '205' : 'Ingresa el número de tu tarjeta',
      '208' : 'Digita un mes de expiración',
      '209' : 'Digita un año de expiración',
      '212' : 'Ingresa tu documento',
      '213' : 'Ingresa tu documento',
      '214' : 'Ingresa tu documento',
      '220' : 'Ingresa tu banco emisor',
      '221' : 'Ingresa el nombre y apellido',
      '224' : 'Ingresa el código de seguridad',
      'E301' : 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302' : 'Revisa el código de seguridad',
      '316' : 'Ingresa un nombre válido',
      '322' : 'Revisa tu documento',
      '323' : 'Revisa tu documento',
      '324' : 'Revisa tu documento',
      '325' : 'Revisa la fecha',
      '326' : 'Revisa la fecha'
    };
    String? errorMessage;
    print('CODIGO ERROR ${data['cause'][0]['code']}');

    if(paymentErrorCodeMap.containsKey('${data['cause'][0]['code']}')){
      print('ENTRO IF');
      errorMessage = paymentErrorCodeMap['${data['cause'][0]['code']}'];
    }else{
      errorMessage = 'No pudimos procesar tu pago';
    }
    Get.snackbar('Error con tu informacion', errorMessage ?? '');
    // Navigator.pop(context);
  }

  void badTokenProcess(String status, MercadoPagoPaymentMethodInstallments installments){
    Map<String, String> badTokenErrorCodeMap = {
      '106' : 'No puedes realizar pagos a usuarios de otros paises.',
      '109' : '${installments.paymentMethodId} no procesa pagos en ${this.installments.value} cuotas',
      '126' : 'No pudimos procesar tu pago.',
      '129' : '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145' : 'No pudimos procesar tu pago',
      '150' : 'No puedes realizar pagos',
      '151' : 'No puedes realizar pagos',
      '160' : 'No pudimos procesar tu pago',
      '204' : '${installments.paymentMethodId} no está disponible en este momento.',
      '801' : 'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
      '501' : 'Servicio de pago no disponible. Intenta nuevamente en unos minutos',
    };
    String? errorMessage;
    if(badTokenErrorCodeMap.containsKey(status.toString())){
      errorMessage =  badTokenErrorCodeMap[status];
    }else{
      errorMessage =  'No pudimos procesar tu pago';
    }
    Get.snackbar('Error en la transaccion', errorMessage ?? '');
    // Navigator.pop(context);
  }

}