import 'package:attamana_truck_app/app/routes/app_pages.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/widget/custom_lottie.dart';
import '../../../style/colors.dart';
import '../controllers/delivery_controller.dart';

class DeliveryOngoingView extends GetView<DeliveryController> {
  const DeliveryOngoingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'On Going Delivery',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return controller.getListOnGoingDeliveryOrder();
          },
          child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Obx(
                () => controller.listOnGoingDo.isEmpty
                    ? lottieNotFound(controller.isLoadingListOnGoingDo.value)
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          color: kSuccessColor,
                        ),
                        itemCount: controller.listOnGoingDo.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.getDetailDeliveryOrder(
                                  controller.listOnGoingDo[index].id);
                              Get.toNamed(Routes.DELIVERY);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: kBoxColor),
                                        child: Image.asset(
                                          'truck_box'.png,
                                          scale: 30,
                                          color: kSuccessColor,
                                        ),
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                  .listOnGoingDo[index].noDeliv,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Receipient: ${controller.listOnGoingDo[index].namaPenerima}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: kWarningrColor
                                                .withOpacity(0.1)),
                                        child: Text(
                                          controller
                                              .listOnGoingDo[index].status,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: kWarningrColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  10.height,
                                  SizedBox(
                                    height: 75,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                                                    color: Colors.red,
                                                    size: 15,
                                                  ),
                                                  5.width,
                                                  const Text(
                                                    'Pickup',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                              5.height,
                                              Expanded(
                                                child: Text(
                                                  controller
                                                      .listOnGoingDo[index]
                                                      .alamatPickup,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              5.height,
                                              Text(
                                                '${DateFormat('d MMMM yyyy').format(controller.listOnGoingDo[index].tglEstimasiPickup)}, ${controller.listOnGoingDo[index].jamEstimasiPickup}',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ],
                                          ),
                                        ),
                                        10.width,
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: kPrimaryColor,
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
                                              Expanded(
                                                child: Text(
                                                  controller
                                                      .listOnGoingDo[index]
                                                      .alamatPengiriman,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              5.height,
                                              Text(
                                                '${DateFormat('d MMMM yyyy').format(controller.listOnGoingDo[index].tglEstimasiSampai)}, ${controller.listOnGoingDo[index].jamEstimasiSampai}',
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
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )),
        ));
  }
}
