import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/resident/products/list/resident_product_list_controller.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';
import '../../../../models/category.dart';

class ResidentproductListPage extends StatelessWidget {

ResidentProductsListController con = Get.put(ResidentProductsListController());

@override
Widget build(BuildContext context) {
  return Obx(() => DefaultTabController(
    length: con.categories.length,
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          flexibleSpace: Container(
            margin: EdgeInsets.only(top:30),
            alignment: Alignment.topCenter,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                _textFieldSearch(context),
                _iconShoppingBag()
              ],
            ),
          ),
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
                if(snapshot.data!.length >0){
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_ , index){
                        return _cardProduct(context, snapshot.data![index]);
                      }
                  );
                }
                else{
                  return NoDataWidget(text:'No hay tags en ésta categoría ');
                }

              }
              else {
                return NoDataWidget(text:'No hay tags en ésta categoría ');
              }
            }
          );
        }).toList(),
      ),
    )
  ));
}

Widget _iconShoppingBag(){
  return SafeArea(
    child: Container(
      margin: EdgeInsets.only(left: 10),
      child: IconButton(
          onPressed: () => con.goToOrderCreate(),
          icon: Icon(
            Icons.shopping_bag_outlined,
            size: 35,
          ),

      ),
    ),
  );
}
Widget _textFieldSearch(BuildContext context){
  return SafeArea(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar tag',
          suffixIcon: Icon(Icons.search, color: Colors.grey),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey
          ),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.grey
            ),
          ),
          contentPadding: EdgeInsets.all(15)
        ),
      ),
    ),
  );
}
Widget _cardProduct(BuildContext context,Product product){
  return GestureDetector(
    onTap: () => con.openBottomSheet(context, product),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, left: 20,right: 20 ),
          child: ListTile(
            title: Text(product.name ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    Text("Precio"),
                    Text(
                        '\$${product.price.toString()}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            )
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),

            trailing:  Container(
              height: 70,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage(
                  image: product.image1 != null
                    ? NetworkImage(product.image1!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
              ),
            )
          ),
        ),
        Divider(height:5 ,color:Colors.black, indent: 35, endIndent: 35,)
      ],
    ),
  );
}
}