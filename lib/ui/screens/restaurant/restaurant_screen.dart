import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/core/utils/navigation/navigation_utils.dart';
import 'package:restaurantapp/core/viewmodels/connection/connection_provider.dart';
import 'package:restaurantapp/core/viewmodels/connection/restaurant/restaurant_provider.dart';
import 'package:restaurantapp/gen/assets.gen.dart';
import 'package:restaurantapp/ui/constant/constant.dart';
import 'package:restaurantapp/ui/router/route_list.dart';
import 'package:restaurantapp/ui/widgets/dialog/chip.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/idle_item.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/loading_listview.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/loading_typehorizontal.dart';
import 'package:restaurantapp/ui/widgets/restaurant/restaurant_list.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Restaurant App",
          style: styleTitle.copyWith(
            fontSize: setFontSize(55),
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => navigate.pushTo(routeRestaurantSearch),
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
      ),
      body: ChangeNotifierProvider(
          create: (context) => RestaurantProvider(),
          child: const RestaurantBody()),
    );
  }
}

class RestaurantBody extends StatelessWidget {
  const RestaurantBody({Key? key}) : super(key: key);

  Future<void> refreshHome(BuildContext context) async {
    final restaurantProv = RestaurantProvider.instance(context);
    restaurantProv.clearRestaurants();
    restaurantProv.clearCities();

    ConnectionProvider.instance(context).setConnection(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, connectionProv, _) {
        if (connectionProv.internetConnected == false) {
          return IdleNoItemCenter(
            title:
                "No internet connection,\nplease check your wifi or mobile data",
            iconPathSVG: Assets.images.illustrationNoConnection.path,
            buttonText: "Retry Again",
            onClickButton: () => refreshHome(context),
          );
        }
        return RefreshIndicator(
          onRefresh: () => refreshHome(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: setHeight(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CitiesListWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: setWidth(40),
                    ),
                    child: Divider(
                      color: blackColor.withOpacity(0.4),
                    ),
                  ),
                  // const _HeaderWidget(),
                  const _RestaurantListWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CitiesListWidget extends StatelessWidget {
  const _CitiesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidth(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cities",
                style: styleTitle.copyWith(
                  fontSize: setFontSize(55),
                ),
              ),
              Text(
                "Interesting city to visit",
                style: styleSubtitle.copyWith(
                  fontSize: setFontSize(40),
                  color: grayDarkColor,
                ),
              ),
            ],
          ),
        ),
        Consumer<RestaurantProvider>(
          builder: (context, restaurantProv, _) {
            if (restaurantProv.cities == null && !restaurantProv.onSearch) {
              restaurantProv.getCities();
              return const LoadingTypeHorizontal();
            }

            if (restaurantProv.cities == null && restaurantProv.onSearch) {
              return const LoadingTypeHorizontal();
            }

            if (restaurantProv.cities!.isEmpty) {
              return const IdleNoItemCenter(
                title: "City not found",
                useDeviceHeight: false,
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: restaurantProv.cities!
                    .asMap()
                    .map((index, value) => MapEntry(
                        index,
                        ChipItem(
                          name: value,
                          isFirst: index == 0,
                          onClick: () => navigate.pushTo(
                            routeRestaurantByCities,
                            data: value,
                          ),
                        )))
                    .values
                    .toList(),
              ),
            );
          },
        )
      ],
    );
  }
}

class _RestaurantListWidget extends StatelessWidget {
  const _RestaurantListWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProv, _) {
        print(restaurantProv.restaurants);
        if (restaurantProv.restaurants == null) {
          restaurantProv.getRestaurants();
          return const LoadingListView();
        }

        // if (restaurantProv.restaurants == null && restaurantProv.onSearch) {
        //   return const LoadingListView();
        // }

        if (restaurantProv.restaurants!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound.path,
          );
        }

        return RestaurantListWidget(
          restaurants: restaurantProv.restaurants!,
        );
      },
    );
  }
}
