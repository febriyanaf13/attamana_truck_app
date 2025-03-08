import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:attamana_truck_app/app/utils/constants.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

// import 'package:slider_button/slider_button.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../components/widget/custom_lottie.dart';
import '../../../style/colors.dart';
import '../controllers/delivery_controller.dart';

class DeliveryDetailsView extends GetView<DeliveryController> {
  const DeliveryDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => SizedBox(
          height: Get.height,
          child: controller.detailDo.isEmpty
              ? Center(
                  child: lottieNotFound(controller.isLoadingDetailDo.value))
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: kBoxColor),
                                child: Image.asset(
                                  'truck'.png,
                                  scale: 10,
                                  color: kSuccessColor,
                                ),
                              ),
                              10.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.detailDo[0].noDeliv,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    const Text(
                                      'Sliper',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '20 mins',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 10),
                                        ),
                                        10.width,
                                        const Text(
                                          'to delivery location',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: kWarningrColor.withOpacity(0.1)),
                                child: Text(
                                  controller.detailDo[0].status,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: kWarningrColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
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
                                  fontWeight: FontWeight.w400, fontSize: 12),
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
                                controller.detailDo[0].alamatPickup,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.radio_button_checked_outlined,
                              color: Colors.green,
                            ),
                            10.width,
                            const Text(
                              'Delivery Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
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
                                controller.detailDo[0].alamatPengiriman,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        30.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Memo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    controller.detailDo[0].memo,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Receipient',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    controller.detailDo[0].namaPenerima,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        30.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    DateFormat('d MMMM yyyy').format(controller
                                        .detailDo[0].tglEstimasiPickup),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    '${controller.detailDo[0].jamEstimasiPickup} WIB',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        30.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Drop Off Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    DateFormat('d MMMM yyyy').format(controller
                                        .detailDo[0].tglEstimasiSampai),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Drop Off Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    '${controller.detailDo[0].jamEstimasiSampai ?? '-'} WIB',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        30.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal invoice / perpindahan barang',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    DateFormat('d MMMM yyyy')
                                        .format(controller.detailDo[0].refDate),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                        50.height,
                        controller.detailDo[0].status == "PICKUP"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup image(s)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  10.height,
                                  GetBuilder<DeliveryController>(
                                    builder: (_) {
                                      print(
                                          "jumlah foto : ${controller.imageFileListPickup}");
                                      return controller
                                              .imageFileListPickup!.isNotEmpty
                                          ? SizedBox(
                                              height: 100,
                                              width: Get.width,
                                              child: ListView.separated(
                                                itemCount: 3,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return index == 1 &&
                                                          controller
                                                                  .imageFileListPickup!
                                                                  .length ==
                                                              1
                                                      ? Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .blueGrey),
                                                          child: Center(
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  controller
                                                                      .pickImages(
                                                                          "PICKUP");
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_a_photo_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ))
                                                      : index == 2
                                                          ? Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .red),
                                                              child: Center(
                                                                child:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          controller
                                                                              .deleteImage("PICKUP");
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              ))
                                                          : SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child: Obx(
                                                                () => ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .file(
                                                                    File(controller
                                                                        .imageFileListPickup![
                                                                            index]
                                                                        .path),
                                                                    width: 50,
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'user_profile'
                                                                            .jpg,
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return 20.width;
                                                },
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blueGrey),
                                              child: Center(
                                                child: IconButton(
                                                    onPressed: () {
                                                      controller
                                                          .pickImages("PICKUP");
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .add_a_photo_outlined,
                                                      color: Colors.white,
                                                    )),
                                              ));
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery image(s)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  10.height,
                                  GetBuilder<DeliveryController>(
                                    builder: (_) {
                                      print(
                                          "jumlah foto : ${controller.imageFileListDelivered}");
                                      return controller.imageFileListDelivered!
                                              .isNotEmpty
                                          ? SizedBox(
                                              height: 100,
                                              width: Get.width,
                                              child: ListView.separated(
                                                itemCount: 3,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return index == 1 &&
                                                          controller
                                                                  .imageFileListDelivered!
                                                                  .length ==
                                                              1
                                                      ? Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .blueGrey),
                                                          child: Center(
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  controller
                                                                      .pickImages(
                                                                          "DELIVERED");
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_a_photo_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ))
                                                      : index == 2
                                                          ? Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .red),
                                                              child: Center(
                                                                child:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          controller
                                                                              .deleteImage("DELIVERED");
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              ))
                                                          : SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child: Obx(
                                                                () => ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .file(
                                                                    File(controller
                                                                        .imageFileListDelivered![
                                                                            index]
                                                                        .path),
                                                                    width: 50,
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                        'user_profile'
                                                                            .jpg,
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return 20.width;
                                                },
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blueGrey),
                                              child: Center(
                                                child: IconButton(
                                                    onPressed: () {
                                                      controller.pickImages(
                                                          "DELIVERED");
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .add_a_photo_outlined,
                                                      color: Colors.white,
                                                    )),
                                              ));
                                    },
                                  ),
                                ],
                              ),
                        50.height,
                        ActionSlider.standard(
                          rolling: false,
                          backgroundColor: Colors.white,
                          reverseSlideAnimationCurve: Curves.easeInOut,
                          reverseSlideAnimationDuration:
                              const Duration(milliseconds: 500),
                          toggleColor: Colors.white,
                          icon: Image.asset(
                            'truck'.png,
                            scale: 10,
                            color: kSuccessColor,
                          ),
                          action: (controllerSlider) async {
                            //Do something here OnSlide

                            var statusDo = "";
                            switch (controller.detailDo[0].status) {
                              case 'PICKUP':
                                return controller.postUpdateSelesaiLoadingDo(
                                    controller.detailDo[0].id,
                                    'ON DELIVERY',
                                    controllerSlider);
                              // statusDo = 'ON DELIVERY';
                              // break;
                              case 'ON DELIVERY':
                                return controller.postUpdateDeliveredDo(
                                    controller.detailDo[0].id,
                                    'DELIVERED',
                                    controllerSlider);
                              // statusDo = 'DELIVERED';
                              // break;
                            }
                            return null;
                            // return controller.postUpdateSelesaiLoadingDo(
                            //     controller.detailDo[0].id, statusDo);
                            // return true;
                          },
                          child: Text(
                            controller.detailDo[0].status == "PICKUP"
                                ? "Slide to start delivery"
                                : "Slide to finish job",
                            style: const TextStyle(
                                color: Color(0xff4a4a4a),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                        // Center(
                        //     child: SliderButton(
                        //   boxShadow: BoxShadow(
                        //     color: Colors.black.withOpacity(0.3),
                        //     blurRadius: 4,
                        //   ),
                        //   action: () async {
                        //     //Do something here OnSlide
                        //     var statusDo = "";
                        //     switch (controller.detailDo[0].status) {
                        //       case 'PICKUP':
                        //         return controller.postUpdateSelesaiLoadingDo(
                        //             controller.detailDo[0].id, 'ON DELIVERY');
                        //       // statusDo = 'ON DELIVERY';
                        //       // break;
                        //       case 'ON DELIVERY':
                        //         return controller.postUpdateDeliveredDo(
                        //             controller.detailDo[0].id, 'DELIVERED');
                        //       // statusDo = 'DELIVERED';
                        //       // break;
                        //     }
                        //     return null;
                        //     // return controller.postUpdateSelesaiLoadingDo(
                        //     //     controller.detailDo[0].id, statusDo);
                        //     // return true;
                        //   },
                        //   label: Text(
                        //     controller.detailDo[0].status == "PICKUP"
                        //         ? "Slide to start delivery"
                        //         : "Slide to finish job",
                        //     style: const TextStyle(
                        //         color: Color(0xff4a4a4a),
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 17),
                        //   ),
                        //   icon: Image.asset(
                        //     'truck'.png,
                        //     scale: 10,
                        //     color: kSuccessColor,
                        //   ),
                        //   radius: 10,
                        // )),
                        50.height
                        // const Spacer(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
