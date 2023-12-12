import 'package:flutter/material.dart';
import 'package:flutter_demo/keep_alive_wrapper.dart';
import 'package:flutter_demo/scrollable_gesture_processing.dart';

/// 处理 PageView 内嵌 ListView 的手势
class PageViewDemo extends StatelessWidget {
  const PageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView 嵌套 ListView'),
      ),
      body: ScrollableGestureProcessingWidget<PageController, ScrollController>(
        builder: (pageController, listController, phsyics) {
          return PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,

            ///去掉 Android 上默认的边缘拖拽效果
            scrollBehavior:
                ScrollConfiguration.of(context).copyWith(overscroll: false),

            /// 屏蔽默认的滑动响应
            physics: phsyics,
            children: [
              Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'Page View -> first',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              KeepAliveListView(
                listScrollController: listController,
                itemCount: 30,
              ),
              Container(
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Page View -> last',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ListView 嵌入 ListView 处理手势
class ListViewEmbedListViewPage extends StatelessWidget {
  const ListViewEmbedListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView 嵌套 ListView'),
      ),
      body:
          ScrollableGestureProcessingWidget<ScrollController, ScrollController>(
        builder: (pageController, listController, phsyics) {
          return ListView(
            physics: phsyics,
            controller: pageController,
            children: [
              const ListTile(title: Text('外层列表0')),
              const ListTile(title: Text('外层列表1')),
              const ListTile(title: Text('外层列表2')),
              const ListTile(title: Text('外层列表3')),
              const ListTile(title: Text('外层列表4')),
              const ListTile(title: Text('外层列表5')),
              const ListTile(title: Text('外层列表6')),
              const ListTile(title: Text('外层列表7')),
              const ListTile(title: Text('外层列表8')),
              const ListTile(title: Text('外层列表9')),
              const ListTile(title: Text('外层列表10')),
              Container(
                height: 500,
                color: Colors.black12,
                child: KeepAliveListView(
                  listScrollController: listController,
                  itemCount: 20,
                ),
              ),
              const ListTile(title: Text('外层列表11')),
              const ListTile(title: Text('外层列表12')),
              const ListTile(title: Text('外层列表13')),
              const ListTile(title: Text('外层列表14')),
              const ListTile(title: Text('外层列表15')),
              const ListTile(title: Text('外层列表16')),
              const ListTile(title: Text('外层列表17')),
              const ListTile(title: Text('外层列表18')),
            ],
          );
        },
      ),
    );
  }
}

/// nest 中放入 PageView
class NestScrollViewPage extends StatelessWidget {
  const NestScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nest -> PageView 嵌套测试'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.orange,
                alignment: Alignment.center,
                child: const Text(
                  '这里是 Header',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
          ];
        },
        body: const EmabedPageView(),
      ),
    );
  }
}

/// PageView 嵌套在 PageView 中
class EmabedPageView extends StatefulWidget {
  final AppBar? appBar;

  const EmabedPageView({super.key, this.appBar});

  @override
  State<EmabedPageView> createState() => _EmabedPageViewState();
}

class _EmabedPageViewState extends State<EmabedPageView>
    with TickerProviderStateMixin {
  final tabs = ['美食', '风景', '娱乐'];
  final secoundsTabs = ['九寨沟', '普吉岛', '芭提雅'];
  // 外层的控制器
  late final _tabContorller = TabController(length: tabs.length, vsync: this);
  // 嵌套的控制器
  late final _secoudContorller =
      TabController(length: secoundsTabs.length, vsync: this);

  @override
  void dispose() {
    _tabContorller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child =
        ScrollableGestureProcessingWidget<PageController, PageController>(
      scrollDirection: Axis.horizontal,
      builder: (controller1, controller2, physic) {
        return Column(
          children: [
            TabBar(
              tabs: tabs.map((e) => Tab(text: e)).toList(),
              controller: _tabContorller,
              onTap: (index) {
                controller1?.animateTo(
                  MediaQuery.of(context).size.width * index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: controller1,
                physics: physic,
                onPageChanged: (index) {
                  _tabContorller.animateTo(index);
                },
                children: tabs.map(
                  (e) {
                    if (e == '风景') {
                      // 嵌套 PageView
                      return KeepAliveWrapper(
                        child: Column(
                          children: [
                            TabBar(
                              tabs: secoundsTabs
                                  .map((e) => Tab(text: e))
                                  .toList(),
                              controller: _secoudContorller,
                              onTap: (index) {
                                controller2?.animateTo(
                                  MediaQuery.of(context).size.width * index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                              },
                            ),
                            Expanded(
                              child: PageView(
                                controller: controller2,
                                physics: physic,
                                onPageChanged: (index) {
                                  _secoudContorller.animateTo(index);
                                },
                                children: secoundsTabs
                                    .map(
                                      (e) => ListViewPage(title: e),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListViewPage(title: e);
                  },
                ).toList(),
              ),
            ),
          ],
        );
      },
    );

    if (widget.appBar == null) {
      return child;
    }

    return Scaffold(
      appBar: widget.appBar,
      body: child,
    );
  }
}

class ListViewPage extends StatelessWidget {
  final String title;

  const ListViewPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          Expanded(
            child: KeepAliveWrapper(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(title: Text('$title 测试数据 $index'));
                },
                itemCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 对 PageView 里的 ListView 做 KeepAlive 记住位置
class KeepAliveListView extends StatelessWidget {
  final ScrollController? listScrollController;
  final int itemCount;

  const KeepAliveListView({
    super.key,
    required this.listScrollController,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
      child: ListView.builder(
        controller: listScrollController,
        // 屏蔽默认的滑动响应
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(title: Text('列表测试数据 $index'));
        },
        itemCount: itemCount,
      ),
    );
  }
}
