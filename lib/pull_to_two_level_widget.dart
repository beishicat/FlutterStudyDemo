import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/scrollable_gesture_processing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshControlStateText {
  final String releaseText;
  final String refreshingText;
  final String idleText;
  final String completeText;
  final String failedText;
  final String canTwoLevelText;

  const RefreshControlStateText({
    this.releaseText = '松开立即刷新数据',
    this.refreshingText = '正在刷新...',
    this.idleText = '下拉刷新',
    this.completeText = '刷新完成',
    this.failedText = '刷新失败',
    this.canTwoLevelText = '松开立即进入二楼',
  });
}

/// 下拉进入二楼的组件，包括下拉刷新
class PullToTwoLevelWidget extends StatelessWidget {
  final Widget twoLevelChild; // 二楼页面
  final TextStyle? headerTextStyle; // 刷新头的字体风格
  final RefreshController controller;
  final ImageProvider<Object>? backgroundImage; // 下拉的背景图，和二楼的背景图一样
  final Color? backgroundColor;
  final RefreshControlStateText stateText; // 文字
  final Widget? Function(ScrollController?)? builder; // 构建列表
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoading;
  final void Function(bool)? onTwoLevel;

  const PullToTwoLevelWidget({
    super.key,
    required this.twoLevelChild,
    required this.controller,
    this.builder,
    this.headerTextStyle,
    this.backgroundImage,
    this.backgroundColor,
    this.stateText = const RefreshControlStateText(),
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      maxOverScrollExtent: 120,
      enableScrollWhenTwoLevel: true,
      child:
          ScrollableGestureProcessingWidget<ScrollController, ScrollController>(
        builder: (controller1, controller2, phsyics) {
          return SmartRefresher(
            controller: controller,
            scrollController: controller1,
            physics: phsyics,
            enableTwoLevel: true,
            header: TwoLevelHeader(
              textStyle:
                  headerTextStyle ?? const TextStyle(color: Colors.white),
              displayAlignment: TwoLevelDisplayAlignment.fromTop,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                image: backgroundImage != null
                    ? DecorationImage(
                        image: backgroundImage!,
                        fit: BoxFit.cover,
                        // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
                        alignment: Alignment.topCenter,
                      )
                    : null,
              ),
              twoLevelWidget: twoLevelChild,
              refreshingIcon: const CupertinoActivityIndicator(
                animating: true,
                color: Colors.white,
              ),
              releaseText: stateText.releaseText,
              refreshingText: stateText.refreshingText,
              idleText: stateText.idleText,
              completeText: stateText.completeText,
              failedText: stateText.failedText,
              canTwoLevelText: stateText.canTwoLevelText,
            ),
            onLoading: () async {
              print('onLoading ....');
              await onLoading?.call();
              controller.loadComplete();
            },
            onRefresh: () async {
              print('onRefresh ....');
              await onRefresh?.call();
              controller.refreshCompleted();
            },
            onTwoLevel: onTwoLevel,
            child: builder?.call(controller2),
          );
        },
      ),
    );
  }
}
