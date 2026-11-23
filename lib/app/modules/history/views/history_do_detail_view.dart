import 'dart:io';

import 'package:attamana_truck_app/app/modules/history/controllers/history_controller.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/widget/custom_lottie.dart';
import '../../../style/colors.dart';
import '../models/history_do_detail.dart';

class HistoryDoDetailView extends GetView<HistoryController> {
  const HistoryDoDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // print(controller.historyDoDetail[0].picture);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingHistoryDoDetail.isTrue) {
          return Center(
            child: lottieNotFound(controller.isLoadingHistoryDoDetail.value),
          );
        } else {
          return SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                  controller.historyDoDetail[0].noDeliv,
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
                                color: kSuccessColor),
                            child: Text(
                              controller.historyDoDetail[0].status,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: kWhiteTextColor,
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
                            controller.historyDoDetail[0].alamatPickup,
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
                            controller.historyDoDetail[0].alamatPengiriman,
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                controller.historyDoDetail[0].memo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                controller.historyDoDetail[0].namaPenerima,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                DateFormat('d MMMM yyyy').format(controller
                                    .historyDoDetail[0].tglEstimasiPickup),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                '${controller.historyDoDetail[0].jamEstimasiPickup} WIB',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                DateFormat('d MMMM yyyy').format(controller
                                    .historyDoDetail[0].tglEstimasiSampai),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                '${controller.historyDoDetail[0].jamEstimasiSampai ?? '-'} WIB',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Text(
                                DateFormat('d MMMM yyyy').format(
                                    controller.historyDoDetail[0].refDate),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup image(s)',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        10.height,
                        GetBuilder<HistoryController>(
                          builder: (_) {
                            var fotoPickup = <Picture>[];

                            fotoPickup = controller.historyDoDetail[0].picture
                                .where(
                                  (picture) => picture.keterangan == 'PICKUP',
                                )
                                .toList();

                            return SizedBox(
                              height: 100,
                              width: Get.width,
                              child: ListView.separated(
                                itemCount: fotoPickup.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int i) {
                                  print(
                                    'picture: ${fotoPickup[i].fileFoto}',
                                  );

                                  final imagePath = fotoPickup[i].fileFoto;

                                  final isNetwork =
                                      imagePath.startsWith('http');

                                  return SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: isNetwork
                                          ? Image.network(
                                              imagePath,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'logo_attamana_truck.jpg',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            )
                                          : Image.file(
                                              File(imagePath),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'logo_attamana_truck.jpg',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return 20.width;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    30.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery image(s)',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        10.height,
                        GetBuilder<HistoryController>(
                          builder: (_) {
                            var fotoPickup = <Picture>[];

                            fotoPickup = controller.historyDoDetail[0].picture
                                .where(
                                  (picture) => picture.keterangan == 'DROP OFF',
                                )
                                .toList();

                            return SizedBox(
                              height: 100,
                              width: Get.width,
                              child: ListView.separated(
                                itemCount: fotoPickup.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int i) {
                                  final imagePath = fotoPickup[i].fileFoto;

                                  final isNetwork =
                                      imagePath.startsWith('http');

                                  return SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: isNetwork
                                          ? Image.network(
                                              imagePath,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'logo_attamana_truck.jpg',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            )
                                          : Image.file(
                                              File(imagePath),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'logo_attamana_truck.jpg',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return 20.width;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    30.height
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
