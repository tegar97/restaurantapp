import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/core/utils/navigation/navigation_utils.dart';
import 'package:restaurantapp/core/viewmodels/connection/connection_provider.dart';
import 'package:restaurantapp/core/viewmodels/connection/restaurant/restaurant_provider.dart';
import 'package:restaurantapp/gen/assets.gen.dart';
import 'package:restaurantapp/ui/constant/constant.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/idle_item.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/loading_listview.dart';
import 'package:restaurantapp/ui/widgets/restaurant/restaurant_list.dart';

class ResturantCitiesScreen extends StatelessWidget {
  final String city;
  const ResturantCitiesScreen({
    Key? key,
    required this.city,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Restaurants in $city",
          style: styleTitle.copyWith(
            fontSize: setFontSize(55),
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => navigate.pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => RestaurantProvider(),
        child: RestaurantCitiesBody(
          city: city,
        ),
      ),
    );
  }
}

class RestaurantCitiesBody extends StatelessWidget {
  final String city;
  const RestaurantCitiesBody({
    Key? key,
    required this.city,
  }) : super(key: key);

  void refreshHome(BuildContext context) {
    final restaurantProv = RestaurantProvider.instance(context);
    restaurantProv.clearRestaurantByCity();
    ConnectionProvider.instance(context).setConnection(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantProvider, ConnectionProvider>(
      builder: (context, restaurantProv, connectionProv, _) {

        if (connectionProv.internetConnected == false) {
          return IdleNoItemCenter(
            title: "No internet connection,\nplease check your wifi or mobile data",
            iconPathSVG: Assets.images.illustrationNoConnection.path,
            buttonText: "Retry Again",
            onClickButton: () => refreshHome(context),
          );
        }

        if (restaurantProv.restaurantsByCity == null &&
            !restaurantProv.onSearch) {
          restaurantProv.getRestaurantsByCity(city);
          return const LoadingListView();
        }

        if (restaurantProv.restaurantsByCity == null &&
            restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.restaurantsByCity!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound.path,
          );
        }

        return RestaurantListWidget(
          restaurants: restaurantProv.restaurantsByCity!,
        );
      },
    );
  }
}
