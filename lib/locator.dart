import 'package:exentialoils/services/dialog_service.dart';
import 'package:exentialoils/services/navigation_service.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
}
