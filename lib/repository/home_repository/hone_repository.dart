import 'dart:ui';

import 'package:euro_insu_proj/model/MyCountriesModel.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class HomeRepository {
  final _apiService = NetworkApiServices();

  Future<List<MyCountriesModel>> countryListApi() async {
    dynamic response = await _apiService.getApi(AppUrl.countryListApi);
    if (response is List) {
      return MyCountriesModel.fromJsonList(response);
    } else {
      throw Exception("Unexpected response AnnounceRepo");
    }
  }
}
