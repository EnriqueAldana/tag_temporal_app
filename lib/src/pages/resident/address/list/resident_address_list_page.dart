import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/address/list/resident_address_list_controller.dart';

class ResidentAddressListPage extends StatelessWidget {

  ResidentAddressListController con = Get.put(ResidentAddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
            'Mis direcciones',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          _iconAddressCreate()

        ],
      ),
      body: Text(
        'ResidentAddressListPage'
      ),

    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.black,
        )
    );
  }
}
