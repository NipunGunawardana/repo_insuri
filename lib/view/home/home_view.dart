import 'package:euro_insu_proj/model/MyCountriesModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/response/status.dart';
import '../../view_models/home/home_view_models.dart';
import '../detail_view/CountryDetailView.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.fetchDataFromCountriesListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Europe Countries'),
      ),
      body: RefreshIndicator(
        onRefresh: homeController.fetchDataFromCountriesListApi,
        child: Obx(() {
          switch (homeController.rxRequestStatus.value) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());

            case Status.ERROR:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (homeController.error.value == 'No internet')
                      Text("No Internet! Please Try Again With Internet"),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        homeController.refreshApi(); // Retry fetching data
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );

            case Status.COMPLETED:
              return CustomScrollView(slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name'),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(() {
                          // Ensure there are no duplicate items in the list
                          final uniqueList =
                              homeController.countryList.value.toSet().toList();

                          // Ensure selected value is one of the items in the list
                          MyCountriesModel? selectedValue =
                              homeController.selectedModel.value;
                          if (!uniqueList.contains(selectedValue)) {
                            selectedValue = null;
                          }

                          return DropdownButtonFormField<MyCountriesModel>(
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              hintText: homeController.selectedCounty.value,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            isExpanded: true,
                            validator: (value) {
                              if (value == null ||
                                  value.name.toString().isEmpty) {
                                return 'Fill fields';
                              }
                              return null;
                            },
                            value: selectedValue,
                            onChanged: (MyCountriesModel? selectedObject) {
                              homeController.selectedModel(selectedObject!);
                              homeController.filterByCommonName(
                                  selectedObject.name!.common.toString());
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: uniqueList.map((MyCountriesModel object) {
                              return DropdownMenuItem<MyCountriesModel>(
                                value: object,
                                child: Text(object.name!.common.toString()),
                              );
                            }).toList(),
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Capital'),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(() {
                          // Ensure there are no duplicate items in the list
                          final uniqueList =
                              homeController.countryList.value.toSet().toList();

                          // Ensure selected value is one of the items in the list
                          MyCountriesModel? selectedValue =
                              homeController.selectedModel.value;
                          if (!uniqueList.contains(selectedValue)) {
                            selectedValue = null;
                          }

                          return DropdownButtonFormField<MyCountriesModel>(
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              hintText: homeController.selectedCapital.value,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            isExpanded: true,
                            validator: (value) {
                              if (value == null ||
                                  value.name.toString().isEmpty) {
                                return 'Fill fields';
                              }
                              return null;
                            },
                            value: selectedValue,
                            onChanged: (MyCountriesModel? selectedObject) {
                              homeController.selectedModel(selectedObject!);
                              homeController.filterByCapital(
                                  selectedObject.capital!.single.toString());
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            items: uniqueList.map((MyCountriesModel object) {
                              return DropdownMenuItem<MyCountriesModel>(
                                value: object,
                                child: Text(object.capital!.single.toString()),
                              );
                            }).toList(),
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          final rangeValue = homeController.rangeValue.value;
                          final numberOfCountries =
                              homeController.filterdcountryList.length;

                          return Text(
                            rangeValue <= 1.0
                                ? 'Maximum Population: Select the Range'
                                : 'Maximum Population: ${rangeValue.toStringAsFixed(0)}\nNumber of countries: $numberOfCountries',
                            style: TextStyle(fontSize: 15),
                          );
                        }),
                        SizedBox(
                          height: 5,
                        ),
                        Slider(
                          min: 0.0,
                          max: 10000000.0,
                          value: homeController.rangeValue.value,
                          focusNode: FocusNode(),
                          onChangeEnd: (value) {
                            homeController.filterByPopulation(value);
                          },
                          onChanged: (value) {
                            homeController.updateRange(value);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Obx(() {
                            if (homeController.filterdcountryList.length == 0) {
                              return Center(
                                  child:
                                      Text('No Countries For Your Selection'));
                            } else {
                              return ListView.builder(
                                itemCount:
                                    homeController.filterdcountryList.length,
                                itemBuilder: (context, index) {
                                  final country =
                                      homeController.filterdcountryList[index];
                                  print(
                                      'countrycountry..' + country.toString());
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(() => CountryDetailView(
                                            country: country));
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          country.flags?.png ??
                                              'https://via.placeholder.com/150', // Provide a placeholder if the image is null
                                        ),
                                      ),
                                      title: Text(country.name?.common ??
                                          'Unknown Country'),
                                      subtitle: Text(
                                          country.capital?.join(', ') ??
                                              'No Capital'),
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);

            default:
              return const Center(child: Text("Unknown state"));
          }
        }),
      ),
    );
  }
}
