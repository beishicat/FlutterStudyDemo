import 'package:azlistview/azlistview.dart';

class City extends ISuspensionBean {
  String? name;
  String? pingyin;

  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<City> fromJsonArray(List<dynamic>? list) {
    return list?.map((e) => City.fromJson(e)).toList() ?? [];
  }

  @override
  String getSuspensionTag() => pingyin ?? '#';
}
