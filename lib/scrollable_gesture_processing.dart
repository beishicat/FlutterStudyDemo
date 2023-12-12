import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// PageView、ListView 嵌套 ListView 的手势处理、可滚动组件嵌套一个可滚动组件的手势处理
///
/// - 参考 https://blog.csdn.net/jdsjlzx/article/details/126811465
/// - 参考 https://github.com/CarGuo/gsy_flutter_demo/blob/7838971cefbf19bb53a71041cd100c4c15eb6443/lib/widget/vp_list_demo_page.dart
/// - 两个 widget 的 physics 必须设置成 NeverScrollableScrollPhysics() 不可滚动
class ScrollableGestureProcessingWidget<T1 extends ScrollController,
    T2 extends ScrollController> extends StatefulWidget {
  /// 滑动方向
  final Axis scrollDirection;

  /// 构建子组件，T1是外层可滚动组件的控制器，T2是嵌套进去的可滚动组件的控制器
  final Widget Function(T1?, T2?, ScrollPhysics?)? builder;

  const ScrollableGestureProcessingWidget({
    super.key,
    this.scrollDirection = Axis.vertical, // 默认垂直滑动
    this.builder,
  });

  @override
  State<ScrollableGestureProcessingWidget> createState() =>
      _ScrollableGestureProcessingWidgetState<T1, T2>();
}

class _ScrollableGestureProcessingWidgetState<T1 extends ScrollController,
        T2 extends ScrollController>
    extends State<ScrollableGestureProcessingWidget<T1, T2>> {
  T1? _pageController;
  T2? _listScrollController;
  ScrollController? _activeScrollController;
  Drag? _drag;

  @override
  void initState() {
    super.initState();
    if (T1 == PageController) {
      _pageController = PageController() as T1?;
    } else if (T1 == ScrollController) {
      _pageController = ScrollController() as T1?;
    }

    if (T2 == PageController) {
      _listScrollController = PageController() as T2?;
    } else if (T2 == ScrollController) {
      _listScrollController = ScrollController() as T2?;
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _listScrollController?.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    /// 先判断 Listview 是否可见或者可以调用
    /// 一般不可见时 hasClients false ，因为 PageView 也没有 keepAlive
    if (_listScrollController?.hasClients == true &&
        _listScrollController?.position.context.storageContext != null) {
      /// 获取 ListView 的  renderBox
      final renderBox = _listScrollController?.position.context.storageContext
          .findRenderObject() as RenderBox;

      /// 判断触摸的位置是否在 ListView 内
      /// 不在范围内一般是因为 ListView 已经滑动上去了，坐标位置和触摸位置不一致
      if (renderBox.paintBounds
              .shift(renderBox.localToGlobal(Offset.zero))
              .contains(details.globalPosition) ==
          true) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController?.position.drag(details, _disposeDrag);
        return;
      }
    }

    /// 这时候就可以认为是 PageView 需要滑动
    _activeScrollController = _pageController;
    _drag = _pageController?.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == _listScrollController &&
        (
            // 手指向上（向左）移动，也就是快要显示出底部 PageView
            details.primaryDelta! < 0 &&
                    // 到了底部，切换到 PageView
                    _activeScrollController?.position.pixels ==
                        _activeScrollController?.position.maxScrollExtent ||
                // 手指向下（向右）移动
                details.primaryDelta! > 0 &&
                    // 到了顶部
                    _activeScrollController?.position.pixels == 0)) {
      /// 切换相应的控制器
      _activeScrollController = _pageController;
      _drag?.cancel();

      /// 参考  Scrollable 里的，
      /// 因为是切换控制器，也就是要更新 Drag
      /// 拖拽流程要切换到 PageView 里，所以需要  DragStartDetails
      /// 所以需要把 DragUpdateDetails 变成 DragStartDetails
      /// 提取出 PageView 里的 Drag 相应 details
      _drag = _pageController?.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }

    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  /// 拖拽结束了，释放  _drag
  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    // 添加滑动手势处理
    final gestures = <Type, GestureRecognizerFactory>{};
    if (Axis.vertical == widget.scrollDirection) {
      // 竖直方向的手势处理的回调
      gestures[VerticalDragGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (VerticalDragGestureRecognizer instance) {
        instance
          ..onStart = _handleDragStart
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd
          ..onCancel = _handleDragCancel;
      });
    } else {
      // 水平方向的手势处理的回调
      gestures[HorizontalDragGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
              (HorizontalDragGestureRecognizer instance) {
        instance
          ..onStart = _handleDragStart
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd
          ..onCancel = _handleDragCancel;
      });
    }

    // 自定义手势
    return RawGestureDetector(
      gestures: gestures,
      behavior: HitTestBehavior.opaque,
      child: widget.builder?.call(_pageController, _listScrollController,
          const NeverScrollableScrollPhysics()),
    );
  }
}
