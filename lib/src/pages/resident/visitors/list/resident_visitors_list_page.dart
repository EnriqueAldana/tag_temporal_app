import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/pages/resident/visitors/list/resident_visitors_list_controller.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';

class ResidentVisitorListPage extends StatelessWidget {

ResidentVisitorListController con = Get.put(ResidentVisitorListController());
@override
Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: _buttonNext(context),
    appBar: AppBar(
      iconTheme: IconThemeData(
          color: Colors.black
      ),
      title: Text(
        'Usuarios visitantes',
        style: TextStyle(
            color: Colors.black
        ),
      ),

    ),
    body: GetBuilder<ResidentVisitorListController> ( builder: (value) => Stack(
      children: [
        _textSelectVisitor(),
        _listVisitors(context)
      ],
    )),
  );
}

Widget _listVisitors( BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: 50),
    child: FutureBuilder(  // No usar Obx sino GetBuilder para actualizar widgets
        future: con.getVisitorMen(),
        builder: (context,AsyncSnapshot<List<User>> snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  itemBuilder: (_,index){
                    return _radioSelectorUser(snapshot.data![index], index);
                  }
              );
            }
            else{
              return Center(
                  child: NoDataWidget(text: 'No hay usuarios con rol de visitante')
              );
            }
          }
          else{
            return Center(
                child: NoDataWidget(text: 'No hay usuarios con rol de visitantes')
            );
          }
        }),
  );



}
Widget _radioSelectorUser(User user, int index){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Row(
          children: [
            Radio(
              value: index,
              groupValue: con.radioValue.value,
              onChanged: con.handleRadioValueChange,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    user.name  ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    )
                ),
                Text(
                    user.lastname  ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    )
                ),
              ],
            )
          ],
        ),
        // Divider(color: Colors.grey[400],);
      ],
    ),

  );
}
Widget _textSelectVisitor(){
  return Container(
    margin: EdgeInsets.only(top:30, left: 30),
    child: Text(
      'Elije un visitante',
      style: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}


Widget _buttonNext(BuildContext context){

  return Container(
    width: double.infinity,
    height: 50 ,
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: ElevatedButton(
        onPressed: ()=> con.createOrder(),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
        child: Text(
          'CONTINUAR',
          style: TextStyle(
              color: Colors.black
          ),
        )
    ),
  );

}
}