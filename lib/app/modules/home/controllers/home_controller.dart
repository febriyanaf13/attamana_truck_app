import 'package:attamana_truck_app/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:attamana_truck_app/app/modules/delivery/controllers/delivery_controller.dart';
import 'package:attamana_truck_app/app/modules/history/controllers/history_controller.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/string_utils.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  //controller
  var historyC = Get.put(HistoryController());
  var dashboardC = Get.put(DashboardController());
  var deliveryC = Get.put(DeliveryController());

  //storage
  var userNama = storage.read(kUserNama);

  @override
  void onInit() {
    refreshHome();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshHome() async {
    deliveryC.getListDeliveryOrder();
    deliveryC.getListOnGoingDeliveryOrder();
    historyC.getListHistoryDo();
  }


}
