
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/environment/environment.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_document_type.dart';
import 'package:tag_temporal_app/src/models/mercado_pago/mercado_pago_payment_method_installments.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/user.dart';

class MercadoPagoProvider extends GetConnect{
String url = Environment.API_MERCADO_PAGO;
User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<MercadoPagoDocumentType>> gerAll() async {
    List<MercadoPagoDocumentType> documents=[];
    Response response = await get(
        '$url/identification_types',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Environment.ACCESS_TOKEN_MERCADO_PAGO}'
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de categorías');
      return [];
    }

    if(response.body == null){
      Get.snackbar('Algo salió mal ...','trayendo la lista de categorías');
    }
    else{
      documents = MercadoPagoDocumentType.fromJsonList(response.body);
    }
    return documents;
  }

Future<MercadoPagoCardToken?> createCardToken(
    String? cvv,
    String? expirationYear,
    int? expirationMonth,
    String? cardNumber,
    String? cardHolderName
    ) async {
  Response response = await post(
      '$url/card_tokens',
      {
        'security_code': cvv,
        'expiration_year': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'cardholder':{
          'name': cardHolderName
        }
      },
      headers: {
        'Content-Type': 'application/json',
      },
    query: {
        'public_key': Environment.PUBLIC_KEY_MERCADO_PAGO
    }
  ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
  print('RESPUESTA BODY creando token: ${response.body}');
  print('RESPUESTA STATUS creando token : ${response.statusCode}');
  if(response.statusCode != 201){
    Get.snackbar('Error', 'No se pudo validar la tarjeta , asegurese de usar una tarjeta válida.');
    return null;
  }
  MercadoPagoCardToken res = MercadoPagoCardToken.fromJson(response.body);
  return res;
}

Future<Response> createPayment({
  @required String? token,
  @required String? paymentMethodId,
  @required String? paymentTypeId,
  @required String? emailCustomer,
  @required String? issuerId,
  @required double? transactionAmount,
  @required int? installments,
  @required Order? order,
}) async {

  Response response = await post(
    '${Environment.API_URL}api/payments/create',
    {
      'token': token,
      'issuer_id': issuerId,
      'payment_method_id': paymentMethodId,
      'transaction_amount': transactionAmount,
      'installments': installments,
      'payer': {
        'email': emailCustomer,
      },
      'order': order!.toJson()
    },
    headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    },
  );

  print('RESPUESTA create payment BODY: ${response.body}');
  print('RESPUESTA create payment STATUS: ${response.statusCode}');

  return response;
}

Future<MercadoPagoPaymentMethodInstallments> getInstallments(String bin, double amount) async {
  Response response = await get(
      '$url/payment_methods/installments',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Environment.ACCESS_TOKEN_MERCADO_PAGO}'
      },
      query: {
        'bin': bin,
        'amount': '${amount}'
      }
  ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

  print('RESPONSE: ${response}');
  print('RESPONSE Status code: ${response.statusCode}');
  print('RESPONSE BODY: ${response.body}');

  if (response.statusCode == 401) {
    Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
    return MercadoPagoPaymentMethodInstallments();
  }

  if (response.statusCode != 200) {
    Get.snackbar('Error', 'No se pudo obtener las coutas de la tarjeta');
    return MercadoPagoPaymentMethodInstallments();
  }

  MercadoPagoPaymentMethodInstallments data = MercadoPagoPaymentMethodInstallments.fromJson(response.body[0]);

  return data;
}


}

