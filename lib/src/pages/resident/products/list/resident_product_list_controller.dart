
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/resident/products/detail/resident_products_detail_page.dart';
import 'package:tag_temporal_app/src/providers/categories_provider.dart';
import 'package:tag_temporal_app/src/models/category.dart';
import 'package:tag_temporal_app/src/providers/products_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class ResidentProductsListController extends GetxController {

CategoriesProvider categoriesProvider = CategoriesProvider();
ProductsProvider productsProvider= ProductsProvider();

List<Category> categories = <Category>[].obs;

ResidentProductsListController () {
  getCategories();
}

void getCategories() async {

  var result = await categoriesProvider.gerAll();
  categories.clear();
  categories.addAll(result);
}

Future<List <Product>> getProducts(String idCategory) async {
  return await productsProvider.findByCategory(idCategory);
}

void goToOrderCreate(){
  Get.toNamed('resident/orders/create');
}

void openBottomSheet(BuildContext context , Product product){
  showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ResidentProductsDetailPage(product: product)
  );
}

}

