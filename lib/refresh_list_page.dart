import 'package:flutter/material.dart';
import 'package:flutter_demo/pull_to_two_level_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 二级页面
class OpenTwoLevelPage extends StatefulWidget {
  const OpenTwoLevelPage({super.key});

  @override
  State<OpenTwoLevelPage> createState() => _OpenTwoLevelPageState();
}

class _OpenTwoLevelPageState extends State<OpenTwoLevelPage> {
  final controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PullToTwoLevelWidget(
        builder: (scrollContorller) => RefreshListPage(
          scrollController: scrollContorller,
          onTwoLevel: () {
            controller.requestTwoLevel();
          },
        ),
        twoLevelChild: const TwoLevelWidget(),
        backgroundImage: const AssetImage('assets/images/ziyang_text_mask.png'),
        backgroundColor: const Color(0xFF1E2133),
        controller: controller,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        onLoading: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        onTwoLevel: (isOpen) {
          print("二楼的打开状态: ${isOpen.toString()}");
        },
      ),
    );
  }
}

class TwoLevelWidget extends StatelessWidget {
  const TwoLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E2133),
          image: DecorationImage(
            image: AssetImage('assets/images/ziyang_text_mask.png'),
            fit: BoxFit.cover,
            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}

class RefreshListPage extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback? onTwoLevel;

  const RefreshListPage({super.key, this.scrollController, this.onTwoLevel});

  @override
  State<StatefulWidget> createState() => _RefreshListPageState();
}

class _RefreshListPageState extends State<RefreshListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('刷新测试'),
        actions: [
          ElevatedButton(
            onPressed: widget.onTwoLevel,
            child: const Text("点击这里打开二楼!"),
          ),
        ],
      ),
      body: ListView.builder(
        controller: widget.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
          title: Text('测试数据 $index'),
        ),
        itemCount: 30,
      ),
    );
  }
}
