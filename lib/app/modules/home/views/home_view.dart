import 'package:action_slider/action_slider.dart';
import 'package:attamana_truck_app/app/routes/app_pages.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:attamana_truck_app/app/utils/string_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';
import '../../delivery/controllers/delivery_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var deliveryC = Get.put(DeliveryController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  controller.userNama,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => controller.dashboardC.changeTabIndex(2),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: kPrimaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      controller.userNama.substring(0, 1),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.refreshHome();
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,
                  const Text(
                    'Start your delivery now',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  10.height,
                  GestureDetector(
                    onTap: () {
                      var doId = storage.read(kDoId);
                      deliveryC.getDetailDeliveryOrder(doId);
                      deliveryC.getListOnGoingDeliveryOrder();
                      Get.toNamed(Routes.DELIVERY_ONGOING);
                    },
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              'road'.png,
                              scale: 5,
                              color: const Color(0xFFDADADA),
                            )),
                        Container(
                          height: 112,
                          width: Get.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: kSuccessColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'truck'.png,
                                scale: 15,
                                color: kSuccessColor,
                              ),
                              Badge(
                                offset: const Offset(15, -5),
                                label: Text(controller
                                    .deliveryC.listOnGoingDo.length
                                    .toString()),
                                child: const Text(
                                  'On Going Delivery',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              const Text(
                                'Courier is on his way to make a delivery',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.height,
                  GestureDetector(
                    onTap: () {
                      deliveryC.getListDeliveryOrder();
                      Get.toNamed(Routes.DELIVERY_SCHEDULED);
                    },
                    child: Stack(
                      children: [
                        const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.timer_outlined,
                              size: 80,
                              color: Color(0xFFDADADA),
                            )),
                        Container(
                          height: 112,
                          width: Get.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 30,
                                color: kPrimaryColor,
                              ),
                              Badge(
                                offset: const Offset(15, -5),
                                label: Text(controller
                                    .deliveryC.listDo.length
                                    .toString()),
                                child: const Text(
                                  'Scheduled Delivery',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              const Text(
                                'Other delivery tasks for couriers',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  50.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'History',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      const Text(
                        'View All',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kSuccessColor),
                      ).onTap(() {
                        controller.dashboardC.changeTabIndex(1);
                      }),
                    ],
                  ),
                  20.height,
                  SizedBox(
                      height: Get.height - Get.height / 2,
                      child: Obx(
                        () => ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.historyC.getHistoryDoDetail(
                                      controller
                                          .historyC.listHistoryDo[index].id);
                                  Get.toNamed(Routes.HISTORY_DETAIL);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller
                                                    .historyC
                                                    .listHistoryDo[index]
                                                    .noDeliv,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Receipient: ${controller.historyC.listHistoryDo[index].namaPenerima}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: kSuccessColor),
                                            child: Text(
                                              controller.historyC
                                                  .listHistoryDo[index].status,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: kWhiteColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: kBoxColor),
                                            child: Image.asset(
                                              'truck_success'.png,
                                              scale: 30,
                                              color: kSuccessColor,
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_rounded,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                    5.width,
                                                    const Text(
                                                      'Drop off',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                5.height,
                                                Text(
                                                  controller
                                                      .historyC
                                                      .listHistoryDo[index]
                                                      .alamatPengiriman,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  maxLines: 2,
                                                ),
                                                5.height,
                                                Text(
                                                  '${DateFormat('d MMMM yyyy').format(controller.historyC.listHistoryDo[index].tglEstimasiSampai)}, ${controller.historyC.listHistoryDo[index].jamEstimasiSampai}',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                                  color: kSuccessColor,
                                ),
                            itemCount:
                                controller.historyC.listHistoryDo.length),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
