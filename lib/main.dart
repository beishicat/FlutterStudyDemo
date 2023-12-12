import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/city_page.dart';
import 'package:flutter_demo/emblem_list_page.dart';
import 'package:flutter_demo/refresh_list_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 48,
              child: CupertinoTextField(
                controller: _textController,
                placeholder: '请输入需要跳转的 URL 链接',
                placeholderStyle: const TextStyle(
                  color: Colors.black12,
                  fontSize: 16,
                  height: 1.2,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                if (await canLaunchUrlString(_textController.text)) {
                  await launchUrlString(_textController.text,
                      mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('跳转'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => const CityPage()));
              },
              child: const Text('城市列表'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => const OpenTwoLevelPage()));
              },
              child: const Text('下拉打开二楼（基于 pull_to_refresh）'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => const PageViewDemo()));
              },
              child: const Text('PageView 嵌套 ListView 解决手势冲突'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => const ListViewEmbedListViewPage()));
              },
              child: const Text('ListView 嵌套 ListView 解决手势冲突'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => EmabedPageView(
                      appBar: AppBar(
                        title: const Text('PageView 嵌套测试'),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('PageView 嵌套 PageView 解决手势冲突'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 跳转外部应用
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const NestScrollViewPage(),
                  ),
                );
              },
              child: const Text('Nested -> PageView 嵌套 PageView 解决手势冲突'),
            ),
          ],
        ),
      ),
    );
  }
}
