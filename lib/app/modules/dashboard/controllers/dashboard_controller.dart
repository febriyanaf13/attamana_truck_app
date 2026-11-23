import 'package:attamana_truck_app/app/data/repository/delivery_order_repository.dart';
import 'package:attamana_truck_app/app/modules/history/controllers/history_controller.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController

  //controller
  var historyC = Get.put(HistoryController());

  //bottom tap bar
  var tabController = PersistentTabController(initialIndex: 0).obs;

  //userId
  var userId = storage.read(kUserId);


  @override
  void onInit() {

    historyC.getListHistoryDo();
    DeliveryOrderRepository().getHistoryDeliveryOrder(userId);

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

  void changeTabIndex(int index) {
    tabController.value.index = index;
  }
}
