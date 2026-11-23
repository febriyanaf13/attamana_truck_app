import 'package:attamana_truck_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  //TODO: Implement AccountController

  //storage
  var userNama = storage.read(kUserNama);
  var userId = storage.read(kUserId);

  //controller
  var authC = Get.put(AuthController());

  @override
  void onInit() {
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
}
