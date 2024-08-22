import 'package:euro_insu_proj/data/response/status.dart';
import 'package:euro_insu_proj/view_models/home/home_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:euro_insu_proj/model/MyCountriesModel.dart';
import 'package:euro_insu_proj/repository/home_repository/hone_repository.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late HomeController homeController;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    homeController = HomeController();
    homeController.onInit();
  });

  group('HomeController Tests', () {
    test('Initial values are correct', () {
      expect(homeController.rxRequestStatus.value, Status.LOADING);
      expect(homeController.countryList.isEmpty, true);
      expect(homeController.filterdcountryList.isEmpty, true);
      expect(homeController.selectedCounty.value, '');
      expect(homeController.selectedCapital.value, '');
      expect(homeController.rangeValue.value, 0.0);
      expect(homeController.error.value, '');
    });

    test('fetchDataFromCountriesListApi handles error and list is empty',
        () async {
      // Arrange
      when(mockHomeRepository.countryListApi()).thenAnswer(
        (_) async => Future.error(Exception("Failed to load countries")),
      );

      // Act
      await homeController.fetchDataFromCountriesListApi();

      // Assert
      // Expect the country list to be empty since the API call failed
      expect(homeController.countryList.length, 0);
    });

    test('filterByCommonName filters countries', () {
      // Arrange
      var countries = [
        MyCountriesModel(
            name: Name(common: "France", official: "France", nativeName: {})),
        MyCountriesModel(
            name: Name(common: "Germany", official: "Germany", nativeName: {})),
        MyCountriesModel(
            name: Name(common: "Finland", official: "Finland", nativeName: {})),
      ];

      homeController.setCountryList(countries);

      // Act
      homeController.filterByCommonName("Fran");

      // Assert
      expect(homeController.filterdcountryList.length, 1);
      expect(homeController.filterdcountryList[0].name?.common, "France");
    });

    test('filterByCapital filters countries', () {
      // Arrange
      var countries = [
        MyCountriesModel(
            name: Name(common: "France", official: "France", nativeName: {}),
            capital: ["Paris"]),
        MyCountriesModel(
            name: Name(common: "Germany", official: "Germany", nativeName: {}),
            capital: ["Berlin"]),
      ];

      homeController.setCountryList(countries);

      // Act
      homeController.filterByCapital("Berlin");

      // Assert
      expect(homeController.filterdcountryList.length, 1);
      expect(homeController.filterdcountryList[0].capital?.first, "Berlin");
    });

    test('updateRange updates the range value', () {
      // Act
      homeController.updateRange(50.0);

      // Assert
      expect(homeController.rangeValue.value, 50.0);
    });
  });
}
