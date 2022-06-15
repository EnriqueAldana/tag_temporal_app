import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tag_temporal_app/src/pages/resident/address/map/resident_address_map_page.dart';
class ResidentAddressCreateController extends GetxService {
/*
  `address_street` varchar(180) NOT NULL,
  `external_number` varchar(100) NOT NULL,
  `internal_number` varchar(100) NOT NULL,
  `neighborhood` varchar(180) NOT NULL,
  `state` varchar(180) NOT NULL,
  `country` varchar(180) NOT NULL,
  `postal_code` varchar(5) NOT NULL,
  `lat` DOUBLE PRECISION NOT NULL,
  `lng` DOUBLE PRECISION NOT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  `id_user` bigint NOT NULL,
  `id_company` bigint NOT NULL,
  */
TextEditingController address_streetController = TextEditingController();
TextEditingController external_numberController = TextEditingController();
TextEditingController internal_numberController = TextEditingController();
TextEditingController neighborhoodController = TextEditingController();
TextEditingController stateController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController postal_codeController = TextEditingController();
TextEditingController refPointController = TextEditingController();

void openGoogleMaps(BuildContext context) async {
  Map<String,dynamic>  refPointMap = await showMaterialModalBottomSheet(

      context: context,
      builder: (context) => ResidentAddressMapPage(),
    isDismissible: false,
    enableDrag: false
  );
  print('REF POINT MAP ${refPointMap}');
  refPointController.text= refPointMap['address'];
  address_streetController.text=refPointMap['direction'];
  external_numberController.text=refPointMap['street'];
  neighborhoodController.text=refPointMap['city'];
  stateController.text=refPointMap['department'];
  countryController.text=refPointMap['country'];


}

}