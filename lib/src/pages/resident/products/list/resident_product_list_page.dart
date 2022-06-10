import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/resident/products/list/resident_product_list_controller.dart';
import '../../../../models/category.dart';

class ResidentproductListPage extends StatelessWidget {

ResidentProductsListController con = Get.put(ResidentProductsListController());

@override
Widget build(BuildContext context) {
  return Obx(() => DefaultTabController(
    length: con.categories.length,
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.amber,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            tabs: List<Widget>.generate(con.categories.length, (index) {
              return Tab(
                child: Text(con.categories[index].name ?? ''),
              );
            }),
          ),
        ),
      ),
      body: TabBarView(
        children: con.categories.map((Category category) {
          return FutureBuilder(
            future: con.getProducts(category.id ?? '1') ,
            builder: (context, AsyncSnapshot<List<Product>> snapshot){
              if (snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_ , index){
                      return _cardProduct(snapshot.data![index]);
                    }
                );
              }
              else {
                return Container();
              }
            }
          );
        }).toList(),
      ),
    )
  ));
}

Widget _cardProduct(Product product){

  return Container(
    margin: EdgeInsets.only(top: 15, left: 20,right: 20 ),
    child: ListTile(
      title: Text(product.name ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(product.description ?? ''),
          Column(
            children: [
              Text("Precio"),
              Text(
                  product.price.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      )
              ),
            ],
          )
        ],
      ),
      trailing:  Container(
        height: 115,
        width: 115,
        child: FadeInImage(
          image: product.image1 != null
            ? NetworkImage(product.image1!)
            : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
      )
    ),
  );
}
}