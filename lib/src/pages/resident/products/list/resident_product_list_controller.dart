
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/providers/categories_provider.dart';
import 'package:tag_temporal_app/src/models/category.dart';
import 'package:tag_temporal_app/src/providers/products_provider.dart';
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


}

