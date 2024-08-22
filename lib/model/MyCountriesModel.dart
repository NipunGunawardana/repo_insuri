class MyCountriesModel {
  MyCountriesModel({
    this.flags,
    this.name,
    this.capital,
    this.region,
    this.languages,
    this.population,
  });

  final Flags? flags;
  final Name? name;
  final List<String>? capital;
  final String? region;
  final Map<String, String>? languages;
  final int? population;
  static List<MyCountriesModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyCountriesModel.fromJson(json)).toList();
  }

  factory MyCountriesModel.fromJson(Map<String, dynamic> json) {
    return MyCountriesModel(
      flags: json["flags"] == null ? null : Flags.fromJson(json["flags"]),
      name: json["name"] == null ? null : Name.fromJson(json["name"]),
      capital: json["capital"] == null
          ? []
          : List<String>.from(json["capital"]!.map((x) => x)),
      region: json["region"],
      languages: Map.from(json["languages"])
          .map((k, v) => MapEntry<String, String>(k, v)),
      population: json["population"],
    );
  }
}

class Flags {
  Flags({
    required this.png,
    required this.svg,
    required this.alt,
  });

  final String? png;
  final String? svg;
  final String? alt;

  factory Flags.fromJson(Map<String, dynamic> json) {
    return Flags(
      png: json["png"],
      svg: json["svg"],
      alt: json["alt"],
    );
  }
}

class Name {
  Name({
    required this.common,
    required this.official,
    required this.nativeName,
  });

  final String? common;
  final String? official;
  final Map<String, NativeName> nativeName;

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      common: json["common"],
      official: json["official"],
      nativeName: Map.from(json["nativeName"]).map(
          (k, v) => MapEntry<String, NativeName>(k, NativeName.fromJson(v))),
    );
  }
}

class NativeName {
  NativeName({
    required this.official,
    required this.common,
  });

  final String? official;
  final String? common;

  factory NativeName.fromJson(Map<String, dynamic> json) {
    return NativeName(
      official: json["official"],
      common: json["common"],
    );
  }
}
