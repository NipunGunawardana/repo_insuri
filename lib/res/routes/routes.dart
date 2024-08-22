import 'package:euro_insu_proj/res/routes/routes_name.dart';
import 'package:get/get.dart';

import '../../view/home/home_view.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.homeView,
          page: () => HomeView(),
          transitionDuration: Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
