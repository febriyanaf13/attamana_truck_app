import 'package:attamana_truck_app/app/modules/delivery/views/delivery_ongoing_view.dart';
import 'package:attamana_truck_app/app/modules/delivery/views/delivery_scheduled_view.dart';
import 'package:attamana_truck_app/app/modules/history/views/history_do_detail_view.dart';
import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/delivery/bindings/delivery_binding.dart';
import '../modules/delivery/views/delivery_details_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/splash_view.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashViewView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
        name: _Paths.DASHBOARD,
        page: () => const DashboardView(),
        bindings: [DashboardBinding(),HomeBinding(), HistoryBinding(), AccountBinding()]),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ), GetPage(
      name: _Paths.HISTORY_DETAIL,
      page: () => const HistoryDoDetailView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY,
      page: () => const DeliveryDetailsView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_ONGOING,
      page: () => const DeliveryOngoingView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_SCHEDULED,
      page: () => const DeliveryScheduledView(),
      binding: DeliveryBinding(),
    ),
  ];
}
