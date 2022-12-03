part of 'shared.dart';

class SharedValue {
  static Color primaryColor = const Color(0xff48416d),
      secondaryColor = const Color(0xffeac28b),
      accentColor = const Color(0xff464062),
      successColor = const Color(0xff4ECCA3),
      errorColor = const Color(0xffFA7070),
      warningColor = const Color(0xffFFEBAD),
      whiteColor = const Color(0xffF4F6F9),
      blackColor = const Color(0xff393E46);

  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => const MainPage(),
    ),
    GetPage(
      name: '${RouteName.detail}/:id',
      page: () => const DetailMoviePage(),
    ),
    GetPage(
      name: '${RouteName.search}/:query',
      page: () => const SearchPage(),
    ),
  ];
}

abstract class RouteName {
  static const home = '/';
  static const notFound = '/404';
  static const detail = '/detail';
  static const search = '/search';
}
