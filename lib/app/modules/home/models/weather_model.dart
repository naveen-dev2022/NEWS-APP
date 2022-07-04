class WeatherModel {
  List<Weather>? weather;
  Main? main;
  Sys? sys;
  String? name;
  String? error;

  WeatherModel(
      {
        this.weather,
        this.main,

        this.sys,

        this.name,
        this.error
     });

  WeatherModel.fromJson(Map<String, dynamic> json) {
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
    sys = json['sys'] != null ? new Sys.fromJson(json['sys']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    if (this.main != null) {
      data['main'] = this.main!.toJson();
    }
    if (this.sys != null) {
      data['sys'] = this.sys!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}


class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}

class Main {
  var temp;

  Main(
      {this.temp,
   });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    return data;
  }
}


class Sys {
  String? country;

  Sys({this.country});

  Sys.fromJson(Map<String, dynamic> json) {
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    return data;
  }
}