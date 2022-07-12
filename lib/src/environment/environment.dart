import 'package:tag_temporal_app/src/utils/constants.dart';

class Environment {

  static const String API_URL = "http://192.168.1.66:3000/";
  static const String API_URL_OLD = "192.168.1.66:3000";
  static const String API_MERCADO_PAGO = "https://api.mercadopago.com/v1";
  static const String ACCESS_TOKEN_MERCADO_PAGO = "TEST-3528176840473483-070618-069af9a0a8b90efeea7a35750d39c7bd-212447326";
  static const String PUBLIC_KEY_MERCADO_PAGO = "TEST-370982b6-f95f-4555-a51f-b7e84e62c1a2";

  static const String API_KEY_MAPS= "AIzaSyBxs-Om5x9C24izgx1JWYBWtCOIj6hi0wg";
  static const double HOME_LATITUDE= Constants.APP_HOME_LAT;
  static const double HOME_LONGITUD=-Constants.APP_HOME_LNG;
  static const double METERS_TO_ARRIVE=5.0;

  static const bool APP_PAYMENTS_APPLY= true;
  static const bool APP_MERCADO_PAGO_PAYMENT= true;




}