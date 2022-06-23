import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../environment/environment.dart';
import '../models/user.dart';

class ProductsProvider extends GetConnect{

  String url = Environment.API_URL + 'api/products';

  User userSession= User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Product>> findByCategory(String idCategory) async {
    Response response = await get(
        '$url/findByCategory/$idCategory',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de productos x categorías');
      return [];
    }
    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }

  Future<List<Product>> findByNameAndCategory(String idCategory, String name) async {
    Response response = await get(
        '$url/findByNameAndCategory/$idCategory/$name',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de productos x categorías');
      return [];
    }
    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }

  Future<List<OrderProduct>> findByVisitorAndStatus(String idVisitor, String statusProduct) async {
    Response response = await get(
        '$url/findByVisitorAndStatus/$idVisitor/$statusProduct',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de productos x categorías');
      return [];
    }
     List<OrderProduct> products = OrderProduct.fromJsonList(response.body);

    return products;
  }

  Future<List<OrderProduct>> findByResidentAndStatus(String idResident, String statusProduct) async {
    Response response = await get(
        '$url/findByResidentAndStatus/$idResident/$statusProduct',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de productos x categorías');
      return [];
    }
    List<OrderProduct> products = OrderProduct.fromJsonList(response.body);

    return products;
  }
  Future<Stream> create(Product product,List<File> images) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/products/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization']= userSession.sessionToken ?? '';

    for(int i=0; i < images.length; i++){
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)
      ));
    }

    request.fields['product'] = json.encode(product);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

}