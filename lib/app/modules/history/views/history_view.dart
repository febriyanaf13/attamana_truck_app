import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getListHistoryDo();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Delivery History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Image.asset(
                'setting_bar'.png,
                scale: 20,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.HISTORY_DETAIL);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.listHistoryDo[index].noDeliv,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Text(
                                      'Receipient: Paul Pogba',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: kSuccessColor),
                                  child: Text(
                                    controller.listHistoryDo[index].status,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            10.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      5.height,
                                      Text(
                                        controller.listHistoryDo[index]
                                            .alamatPengiriman,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      5.height,
                                      Text(
                                        '${DateFormat('d MMMM yyyy').format(controller.listHistoryDo[index].tglEstimasiSampai)}, ${controller.listHistoryDo[index].jamEstimasiSampai}',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300),
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
                  itemCount: controller.listHistoryDo.length),
            )));
  }
}
