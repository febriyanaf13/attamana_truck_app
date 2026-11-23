abstract class Api {
  // static const baseUrl = 'http://192.168.18.15:8000/api';

  static const baseUrl = 'https://attamana.freightapp.in:444/api';
  // static const baseUrl = 'https://demoerp.freightapp.in:444/api';

  static const token = '$baseUrl/login';
  static const login = '$baseUrl/uslogin';

  //api delivery orders
  static const deliveryOrder = '$baseUrl/list_do';
  static const detaiDeliveryOrder = '$baseUrl/detail_do';
  static const onGoingDeliveryOrder = '$baseUrl/list_ongoing_do';
  static const selesaiLoadingDo = '$baseUrl/loading_do';
  static const deliveredDo = '$baseUrl/delivered_do';
  static const pickupDo = '$baseUrl/pickup_do';
  static const historyDo = '$baseUrl/list_history_do';
  static const historyDoDetail = '$baseUrl/detail_do';
  static const sinkronisasiDoLokal = '$baseUrl/sinkronisasi_do_lokal';
}
