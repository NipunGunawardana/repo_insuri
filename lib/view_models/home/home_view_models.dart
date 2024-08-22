import 'package:euro_insu_proj/model/MyCountriesModel.dart';
import 'package:get/get.dart';

import '../../data/response/status.dart';
import '../../repository/home_repository/hone_repository.dart';

class HomeController extends GetxController {
  final _api = HomeRepository();

  final rxRequestStatus = Status.LOADING.obs;
  final countryList = <MyCountriesModel>[].obs;
  final filterdcountryList = <MyCountriesModel>[].obs;

  var selectedModel = MyCountriesModel().obs;
  var selectedCounty = ''.obs;
  var selectedCapital = ''.obs;
  RxString error = ''.obs;
  RxDouble rangeValue = 0.0.obs;

  // Update the range value
  void updateRange(double newValue) {
    rangeValue.value = newValue;
  }

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setCountryList(List<MyCountriesModel> newCountries) {
    countryList.value = newCountries;
    filterdcountryList.value = newCountries;
  }

  void setCountryListForRefresh(List<MyCountriesModel> newCountries) {
    countryList.value = newCountries;
  }

  void setError(String _value) => error.value = _value;

//get All list
  Future<void> fetchDataFromCountriesListApi() async {
    setRxRequestStatus(Status.LOADING);
    _api.countryListApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      selectedCounty.value = 'Select';
      selectedCapital.value = 'Select';
      setCountryList(value);
    }).onError((error, stackTrace) {
      print('Error: $error');
      print('StackTrace: $stackTrace');
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

//refresh list
  Future<void> refreshApi() async {
    // Set status to loading before starting the delay
    setRxRequestStatus(Status.LOADING);

    // Add a 3-second delay
    await Future.delayed(Duration(seconds: 0));

    // Then call the API
    _api.countryListApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setCountryListForRefresh(value);
    }).onError((error, stackTrace) {
      print('Error: $error');
      print('StackTrace: $stackTrace');
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  // Method to filter countries by common name
  void filterByCommonName(String commonName) async {
    if (commonName.isEmpty) {
      // If no filter, show all countries
      filterdcountryList.value = countryList;
    } else {
      refreshApi();
      selectedCounty.value = commonName;
      selectedCapital.value = 'Select';
      rangeValue.value = 0.0;
      filterdcountryList.value = countryList.where((country) {
        // Check if the common name matches
        return country.name?.common
                ?.toLowerCase()
                .contains(commonName.toLowerCase()) ??
            false;
      }).toList();
    }
  }

  // Method to filter countries by capital Name
  void filterByCapital(String commonName) async {
    if (commonName.isEmpty) {
      // If no filter, show all countries
      filterdcountryList.value = countryList;
    } else {
      refreshApi();
      selectedCapital.value = commonName;
      selectedCounty.value = 'Select';
      rangeValue.value = 0.0;
      filterdcountryList.value = countryList.where((country) {
        // Check if the common name matches
        return country.capital!.single
                ?.toLowerCase()
                .contains(commonName.toLowerCase()) ??
            false;
      }).toList();
    }
  }

  // Method to filter countries by populations
  void filterByPopulation(double pop) async {
    print('ppppppp..' + pop.toString());
    if (pop.isNull) {
      // If no filter, show all countries
      rangeValue.value = 0.0;
    } else {
      refreshApi();

      selectedCounty.value = 'Select';
      selectedCapital.value = 'Select';
      rangeValue.value = pop;
      filterdcountryList.value = countryList.where((country) {
        // Ensure the population is not null and compare it to the given pop value
        return country.population != null && country.population! < pop;
      }).toList();
    }
  }
}
