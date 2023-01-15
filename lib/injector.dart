import 'package:get_it/get_it.dart';
import 'package:restaurantapp/core/data/api.dart';
import 'package:restaurantapp/core/data/base_api.dart';
import 'package:restaurantapp/core/service/restaurant_service.dart';
import 'package:restaurantapp/core/utils/favorite/favorite_utils.dart';

import 'package:restaurantapp/core/utils/navigation/navigation_utils.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  /// Registering api
  if (locator.isRegistered(instance: Api()) == false) {
    locator.registerSingleton(Api());
  }
  if (locator.isRegistered(instance: BaseAPI()) == false) {
    locator.registerSingleton(BaseAPI());
  }

  /// Registering utilsu
  locator.registerSingleton(NavigationUtils());
  locator.registerLazySingleton(() => FavoriteUtils());
  // locator.registerLazySingleton(() => ScheduleUtils());
  // locator.registerLazySingleton(() => NotificationUtils());
  // locator.registerLazySingleton(() => BackgroundServiceUtils());

  /// Registering services
  locator.registerLazySingleton(() => RestaurantService(locator<BaseAPI>()));
}
