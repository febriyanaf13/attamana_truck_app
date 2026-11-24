import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/dialog/custom_dialog.dart';
import '../modules/delivery/controllers/delivery_controller.dart';
import '../modules/delivery/models/delivery_order.dart';
import '../modules/delivery/views/delivery_scheduled_view.dart';
import '../modules/history/controllers/history_controller.dart';
import '../routes/app_pages.dart';
import '../utils/constants.dart';
import '../utils/string_utils.dart';
import 'notifikasi_provider.dart';

/// sama dengan Fcm::CHANNEL di server
const _kChannelId = 'attamana_notif';
const _kChannelNama = 'Job pengiriman';
const _kTokenFcm = 'fcm_token';

/// Pesan saat aplikasi tertutup / di latar belakang: notifikasi ditampilkan otomatis oleh sistem
/// (payload `notification` dari server), di sini tidak perlu apa-apa.
@pragma('vm:entry-point')
Future<void> notifikasiLatarBelakang(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

/// VERSI 52: push notification job antar untuk driver (Firebase Cloud Messaging).
///
/// Server mengirim notifikasi saat DO di-CONFIRM untuk driver ini (job baru), DO diubah (jadwal, alamat, barang),
/// dialihkan ke driver lain, dibatalkan / ditunda, serta pengingat H-1 17:00 & 2 jam sebelum pickup.
///
/// - token HP didaftarkan ke server setelah login (beranda dibuka) dan saat token berganti; dihapus saat logout
/// - notifikasi yang datang saat aplikasi dibuka: ditampilkan (flutter_local_notifications) + daftar DO di-refresh
/// - notifikasi diketuk: job baru -> lembar "Confirm Delivery" DO tsb, job berjalan -> detail DO,
///   job batal / dialihkan -> pesan penjelasan
/// - setiap aplikasi kembali dibuka (resume), daftar DO di-refresh (cadangan bila push tidak sampai)
///
/// Bila Firebase belum dikonfigurasi (google-services.json belum ada), aplikasi tetap jalan tanpa push.
class NotifikasiService extends GetxService with WidgetsBindingObserver {
  static NotifikasiService get to => Get.find<NotifikasiService>();

  final aktif = false.obs;
  final _lokal = FlutterLocalNotificationsPlugin();
  Map<String, dynamic>? _tujuanTertunda;
  DateTime _terakhirSegar = DateTime.fromMillisecondsSinceEpoch(0);

  static Future<void> pasang() async {
    final s = Get.put(NotifikasiService(), permanent: true);
    WidgetsBinding.instance.addObserver(s);
    await s._init();
  }

  Future<void> _init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(notifikasiLatarBelakang);
      aktif.value = true;
    } catch (e) {
      if (kDebugMode) print('Firebase belum dikonfigurasi: $e');
      return;
    }

    try {
      await _lokal.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (r) {
          if (r.payload == null || r.payload!.isEmpty) return;
          try {
            bukaDariData(Map<String, dynamic>.from(jsonDecode(r.payload!)));
          } catch (_) {}
        },
      );
      await _lokal
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            _kChannelId,
            _kChannelNama,
            description: 'Job antar baru, perubahan, pembatalan & pengingat pickup',
            importance: Importance.high,
          ));

      // aplikasi sedang dibuka -> tampilkan sendiri & segarkan daftar DO
      FirebaseMessaging.onMessage.listen((m) {
        final n = m.notification;
        if (n != null) {
          _lokal.show(
            m.hashCode,
            n.title,
            n.body,
            NotificationDetails(
              android: AndroidNotificationDetails(_kChannelId, _kChannelNama,
                  importance: Importance.high,
                  priority: Priority.high,
                  styleInformation: BigTextStyleInformation(n.body ?? '')),
              iOS: const DarwinNotificationDetails(),
            ),
            payload: jsonEncode({...m.data, '_judul': n.title ?? '', '_isi': n.body ?? ''}),
          );
        }
        segarkanDaftar(paksa: true);
      });

      // diketuk saat aplikasi di latar belakang
      FirebaseMessaging.onMessageOpenedApp.listen((m) => bukaDariData({
            ...m.data,
            '_judul': m.notification?.title ?? '',
            '_isi': m.notification?.body ?? '',
          }));

      // diketuk saat aplikasi tertutup -> dibuka setelah beranda siap
      final awal = await FirebaseMessaging.instance.getInitialMessage();
      if (awal != null) {
        _tujuanTertunda = {
          ...awal.data,
          '_judul': awal.notification?.title ?? '',
          '_isi': awal.notification?.body ?? '',
        };
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((t) => _kirimToken(t));
    } catch (e) {
      if (kDebugMode) print('Inisialisasi notifikasi gagal: $e');
    }
  }

  bool get _login =>
      storage.read(kSesionAuth) == true && storage.read(kUserId) != null;

  // ------------------------------------------------------------------ token HP

  /// dipanggil saat beranda dibuka (setelah login)
  Future<void> daftarkanToken() async {
    if (!aktif.value || !_login) return;
    try {
      final izin = await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);
      if (izin.authorizationStatus == AuthorizationStatus.denied) return;
      final t = await FirebaseMessaging.instance.getToken();
      if (t != null && t.isNotEmpty) await _kirimToken(t);
    } catch (e) {
      if (kDebugMode) print('Token FCM gagal: $e');
    }
  }

  Future<void> _kirimToken(String token) async {
    if (!_login) return;
    try {
      final info = await PackageInfo.fromPlatform();
      final r = await NotifikasiProvider().simpanPerangkat(
          token, Platform.isIOS ? 'ios' : 'android', info.version);
      if (r.status.isOk && r.body is Map && r.body['success'] == true) {
        storage.write(_kTokenFcm, token);
      }
    } catch (_) {}
  }

  /// dipanggil SEBELUM status login dihapus (logout): HP berhenti menerima job user ini
  Future<void> hapusToken() async {
    final t = storage.read(_kTokenFcm);
    if (t == null) return;
    try {
      await NotifikasiProvider().hapusPerangkat('$t');
    } catch (_) {}
    storage.remove(_kTokenFcm);
  }

  // ------------------------------------------------------------------ segarkan daftar DO

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) segarkanDaftar();
  }

  /// muat ulang Scheduled / On Going / History dari server (maks. 1x per 30 detik kecuali [paksa])
  Future<void> segarkanDaftar({bool paksa = false}) async {
    if (!_login || !Get.isRegistered<DeliveryController>()) return;
    final now = DateTime.now();
    if (!paksa && now.difference(_terakhirSegar).inSeconds < 30) return;
    _terakhirSegar = now;
    try {
      final d = Get.find<DeliveryController>();
      await Future.wait([d.getListDeliveryOrder(), d.getListOnGoingDeliveryOrder()]);
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().getListHistoryDo();
      }
    } catch (_) {}
  }

  // ------------------------------------------------------------------ buka notifikasi

  /// dipanggil beranda setelah tampil: buka notifikasi yang diketuk saat aplikasi masih tertutup
  void prosesTertunda() {
    final d = _tujuanTertunda;
    _tujuanTertunda = null;
    if (d != null) {
      Future.delayed(const Duration(milliseconds: 500), () => bukaDariData(d));
    }
  }

  /// data push: notif_id, tipe, ref_tabel, ref_id, url, no_deliv, status_do (+ _judul, _isi dari notifikasi)
  Future<void> bukaDariData(Map<String, dynamic> d) async {
    if (!_login) return;
    final id = int.tryParse('${d['notif_id'] ?? ''}') ?? 0;
    if (id > 0) {
      NotifikasiProvider().baca([id]).then((_) {}, onError: (_) {});
    }
    if ('${d['ref_tabel'] ?? ''}' != 'delivery_orders') return;

    final tipe = '${d['tipe'] ?? ''}';
    final noDeliv = '${d['no_deliv'] ?? ''}';
    final judul = '${d['_judul'] ?? ''}';
    final isi = '${d['_isi'] ?? ''}';

    if (tipe == 'DO_BATAL' || tipe == 'DO_DIALIHKAN') {
      await segarkanDaftar(paksa: true);
      dialogWarning(judul.isNotEmpty ? judul : 'Job $noDeliv',
          isi.isNotEmpty ? isi : 'Job ini tidak lagi ditugaskan ke Anda.');
      return;
    }

    final c = Get.isRegistered<DeliveryController>()
        ? Get.find<DeliveryController>()
        : Get.put(DeliveryController());
    await Future.wait([c.getListDeliveryOrder(), c.getListOnGoingDeliveryOrder()]);
    _terakhirSegar = DateTime.now();

    // job menunggu pickup -> daftar Scheduled + lembar Confirm Delivery DO tsb
    final terjadwal = _cari(c.listDo, noDeliv);
    if (terjadwal != null) {
      Get.toNamed(Routes.DELIVERY_SCHEDULED);
      Future.delayed(const Duration(milliseconds: 400),
          () => tampilkanKonfirmasiDo(c, terjadwal));
      return;
    }
    // job berjalan -> detail
    final berjalan = _cari(c.listOnGoingDo, noDeliv);
    if (berjalan != null) {
      c.getDetailDeliveryOrder(berjalan.id);
      Get.toNamed(Routes.DELIVERY);
      return;
    }
    // sudah selesai / tidak ada lagi di daftar driver
    if ('${d['status_do'] ?? ''}' == 'DELIVERED') {
      Get.toNamed(Routes.HISTORY);
      return;
    }
    dialogWarning(noDeliv.isNotEmpty ? noDeliv : 'Delivery order',
        'Delivery order ini sudah tidak ada di daftar job Anda (mungkin sudah diproses, dialihkan, atau dibatalkan).');
  }

  ListDo? _cari(List<ListDo> daftar, String noDeliv) {
    if (noDeliv.isEmpty) return null;
    for (final x in daftar) {
      if (x.noDeliv == noDeliv) return x;
    }
    return null;
  }
}
