import 'package:action_slider/action_slider.dart';
import 'package:attamana_truck_app/app/modules/delivery/controllers/delivery_controller.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:slider_button/slider_button.dart';

import '../../../components/widget/custom_lottie.dart';
import '../../../style/colors.dart';
import '../models/delivery_order.dart';

class DeliveryScheduledView extends GetView<DeliveryController> {
  const DeliveryScheduledView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Scheduled Delivery',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return controller.getListDeliveryOrder();
          },
          child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Obx(
                () => controller.listDo.isEmpty
                    ? lottieNotFound(controller.isLoadingListDo.value)
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          color: kSuccessColor,
                        ),
                        itemCount: controller.listDo.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => tampilkanKonfirmasiDo(controller, controller.listDo[index]),
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
                                              controller.listDo[index].noDeliv,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Receipient: ${controller.listDo[index].namaPenerima}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Column(
                                      //   children: [
                                      //     const Icon(
                                      //       Icons.directions_walk,
                                      //       size: 20,
                                      //     ),
                                      //     Row(
                                      //       children: [
                                      //         const Text(
                                      //           '100',
                                      //           style: TextStyle(
                                      //               fontSize: 14,
                                      //               fontWeight: FontWeight.w800,
                                      //               color: Colors.green),
                                      //         ),
                                      //         5.width,
                                      //         const Text(
                                      //           'KM',
                                      //           style: TextStyle(
                                      //             fontSize: 12,
                                      //             fontWeight: FontWeight.w500,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 10, vertical: 5),
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(5),
                                      //       color: kSuccessColor),
                                      //   child: const Text(
                                      //     'Completed',
                                      //     style: TextStyle(
                                      //         fontSize: 10,
                                      //         color: kWhiteColor,
                                      //         fontWeight: FontWeight.w500),
                                      //   ),
                                      // )
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
                                                  controller.listDo[index]
                                                      .alamatPickup,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              5.height,
                                              Text(
                                                '${DateFormat('d MMMM yyyy').format(controller.listDo[index].tglEstimasiPickup)}, ${controller.listDo[index].jamEstimasiPickup}',
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
                                                  controller.listDo[index]
                                                      .alamatPengiriman,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              5.height,
                                              Text(
                                                '${DateFormat('d MMMM yyyy').format(controller.listDo[index].tglEstimasiSampai)}, ${controller.listDo[index].jamEstimasiSampai}',
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


/// VERSI 52: lembar "Confirm Delivery" dipisah dari daftar supaya bisa dibuka juga
/// saat driver mengetuk notifikasi job baru (lihat NotifikasiService).
void tampilkanKonfirmasiDo(DeliveryController controller, ListDo item) {
  Get.bottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
              top: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Icon(Icons.minimize_rounded, size: 60,),
                const Text(
                  'Confirm Delivery',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                20.height,
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(
                                10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius
                                    .circular(5),
                            color: kBoxColor),
                        child: Image.asset(
                          'truck_box'.png,
                          scale: 10,
                          color: kSuccessColor,
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              item
                                  .noDeliv,
                              style:
                                  const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                      fontSize: 16),
                            ),
                            const Text(
                              'Sliper',
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     const Icon(
                      //       Icons.directions_walk,
                      //       size: 20,
                      //     ),
                      //     Row(
                      //       children: [
                      //         const Text(
                      //           '100',
                      //           style: TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w800,
                      //               color: Colors.green),
                      //         ),
                      //         5.width,
                      //         const Text(
                      //           'KM',
                      //           style: TextStyle(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                30.height,
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                    ),
                    10.width,
                    const Text(
                      'Pickup Location',
                      style: TextStyle(
                          fontWeight:
                              FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.green,
                    ),
                    10.width,
                    Expanded(
                      child: Text(
                        item
                            .alamatPickup,
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.w500,
                            fontSize: 14),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons
                          .radio_button_checked_outlined,
                      color: Colors.green,
                    ),
                    10.width,
                    const Text(
                      'Delivery Location',
                      style: TextStyle(
                          fontWeight:
                              FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.transparent,
                    ),
                    10.width,
                    Expanded(
                      child: Text(
                        item
                            .alamatPengiriman,
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.w500,
                            fontSize: 14),
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                30.height,
                const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Memo',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            'Electronics/Gadgets',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Receipient',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            'Donald Duck',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Pickup Date',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            DateFormat(
                                    'd MMMM yyyy')
                                .format(item
                                    .tglEstimasiPickup),
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Pickup Time',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            '${item.jamEstimasiPickup} WIB',
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Drop Off Date',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            DateFormat(
                                    'd MMMM yyyy')
                                .format(item
                                    .tglEstimasiSampai),
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Drop Off Time',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            '${item.jamEstimasiSampai} WIB',
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          // VERSI 50: dulu nomor telepon contoh (08123456789)
                          const Text(
                            'Customer',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w400,
                                fontSize: 12),
                          ),
                          Text(
                            item.namaCustomer.isNotEmpty
                                ? item.namaCustomer
                                : '-',
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [],
                      ),
                    ),
                  ],
                ),
                20.height,
                // const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionSlider.standard(
                    rolling: false,
                    width: 300,
                    backgroundColor: Colors.white,
                    reverseSlideAnimationCurve:
                        Curves.easeInOut,
                    reverseSlideAnimationDuration:
                        const Duration(
                            milliseconds: 500),
                    toggleColor: Colors.white,
                    icon: Image.asset(
                      'truck'.png,
                      scale: 10,
                      color: kSuccessColor,
                    ),
                    action: (controllerSlider) async {
                      try {
                        controllerSlider.loading();

                        final result = await controller.postUpdatePickupDo(
                          item.noDeliv,  item.id,
                          "PICKUP"
                        );

                        if (result) {
                          controllerSlider.success();
                        } else {
                          controllerSlider.reset();
                        }
                      } catch (e) {
                        controllerSlider.reset();
                      }
                    },
                    child: const Text(
                      "Slide to accept job",
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                ),
                // Center(
                //     child: SliderButton(
                //       boxShadow: BoxShadow(
                //         color:
                //         Colors.black.withOpacity(0.3),
                //         blurRadius: 4,
                //       ),
                //       action: () async {
                //         ///Do something here OnSlide
                //         return controller
                //             .postUpdatePickupDo(
                //             controller
                //                 .listDo[index].id,
                //             "PICKUP");
                //         // return true;
                //       },
                //       label: const Text(
                //         "Slide to accept job",
                //         style: TextStyle(
                //             color: Color(0xff4a4a4a),
                //             fontWeight: FontWeight.w500,
                //             fontSize: 17),
                //       ),
                //       icon: Image.asset(
                //         'truck'.png,
                //         scale: 10,
                //         color: kSuccessColor,
                //       ),
                //       radius: 10,
                //     )),
                // const Spacer(),
                20.height
              ],
            ),
          ),
        ),
      ));
}
