import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/core/viewmodels/favorite/favorite_provider.dart';
import 'package:restaurantapp/ui/constant/constant.dart';
import 'package:restaurantapp/ui/screens/facorite/favorite_screen.dart';
import 'package:restaurantapp/ui/screens/restaurant/restaurant_screen.dart';
import 'package:restaurantapp/ui/screens/setting/setting_screen.dart';
import 'package:restaurantapp/ui/widgets/idle/loading/idle_item.dart';

class DasboardScreen extends StatefulWidget {
  const DasboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DasboardScreen> createState() => _DasboardScreenState();
}

class _DasboardScreenState extends State<DasboardScreen> {
  int _currentIndex = 0;

  List<Widget> menuList = [
    const RestaurantScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavbar(),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProv, _) {
          if (favoriteProv.favorites == null &&
              favoriteProv.onSearch == false) {
            favoriteProv.getFavorites();
            return const IdleLoadingCenter();
          }

          return menuList[_currentIndex];
        },
      )
    );
    
  }
  Widget _bottomNavbar() {
  return CustomNavigationBar(
    iconSize: 25, 
    selectedColor: primaryColor,
    unSelectedColor: grayColor.withOpacity(0.4),
    strokeColor: primaryColor,
    backgroundColor: Colors.white,
    borderRadius: const Radius.circular(15),
     currentIndex: _currentIndex,
      onTap: (index) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    items: [
    CustomNavigationBarItem(
          icon: const Icon(Icons.local_restaurant_rounded),
          badgeCount: 0,
          showBadge: false,
          title: Text(
            "Restaurant",
            style: styleSubtitle,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          badgeCount: 0,
          showBadge: false,
          title: Text(
            "Favorite",
            style: styleSubtitle,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.settings),
          badgeCount: 0,
          showBadge: false,
          title: Text(
            "Setting",
            style: styleSubtitle,
          ),
        )
      ],  
  );
}
}

