import 'package:flutter/material.dart';

/// 页面状态保持包装器
class KeepAliveWrapper extends StatefulWidget {
  final bool keepAlive;
  final Widget child;

  const KeepAliveWrapper({
    super.key,
    required this.child,
    this.keepAlive = true,
  });

  @override
  State<StatefulWidget> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    // 状态发生变化时调用
    if (oldWidget.keepAlive != widget.keepAlive) {
      // 更新 KeepAlive 状态
      updateKeepAlive();
    }

    super.didUpdateWidget(oldWidget);
  }
}
