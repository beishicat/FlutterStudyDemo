import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/models/city.dart';
import 'package:lpinyin/lpinyin.dart';

class CityPage extends StatefulWidget {
  const CityPage({super.key});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final _cityList = <City>[];
  final _dio = Dio();

  @override
  void initState() {
    super.initState();

    // _readJson();
    _getCityData();
  }

  List<City> _readCityList(List<dynamic>? data) {
    List<City> list = [];
    for (final e in data ?? []) {
      final level = e['level'] as String?;
      if (level == 'country') {
        // 如果是国家层级，继续循环
        return _readCityList(e['districts']);
      } else {
        final items = e['districts'] as List<dynamic>?;
        list.addAll(items?.map((e) {
              final model = City.fromJson(e);
              // 处理首字拼音
              final tag = PinyinHelper.getPinyinE(model.name ?? ' ')
                  .substring(0, 1)
                  .toUpperCase();
              model.pingyin = tag;
              if (RegExp('[A-Z]').hasMatch(tag)) {
                model.pingyin = tag;
              } else {
                model.pingyin = '#';
              }
              return model;
            }).toList() ??
            []);
      }
    }

    return list;
  }

  Future<void> _getCityData() async {
    final result = await _dio.get<Map<String, dynamic>>(
        'http://47.109.54.6:8901/api/pub/message_manage/searchWeatherCity');
    final list = result.data?['data'] as List<dynamic>;
    _cityList.addAll(_readCityList(list));
    SuspensionUtil.sortListBySuspensionTag(_cityList);
    SuspensionUtil.setShowSuspensionStatus(_cityList);
    setState(() {});
  }

  Future<void> _readJson() async {
    // 加载城市列表
    final jsonString = await rootBundle.loadString('assets/data/china.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>?;
    final list = json?['china'] as List<dynamic>?;
    _cityList.addAll(City.fromJsonArray(list));
    for (final e in _cityList) {
      final tag =
          PinyinHelper.getPinyinE(e.name ?? ' ').substring(0, 1).toUpperCase();
      e.pingyin = tag;
      if (RegExp('[A-Z]').hasMatch(tag)) {
        e.pingyin = tag;
      } else {
        e.pingyin = '#';
      }
    }
    SuspensionUtil.sortListBySuspensionTag(_cityList);
    SuspensionUtil.setShowSuspensionStatus(_cityList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('城市列表'),
      ),
      body: AzListView(
        data: _cityList,
        itemCount: _cityList.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(
            _cityList[index].name ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        susItemBuilder: (_, index) => Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _cityList[index].getSuspensionTag(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        indexBarData: SuspensionUtil.getTagIndexList(_cityList),
      ),
    );
  }
}
