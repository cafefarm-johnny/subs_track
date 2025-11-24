import 'package:flutter/material.dart';

/// Fade in/out 애니메이션이 적용된 SnackBar 위젯
class FadeSnackBar extends SnackBar {
  FadeSnackBar({
    super.key,
    required String text,
    required super.duration,
    required Duration fadeDuration,
    required super.behavior,
    super.elevation = 0,
  }) : super(
         // SnackBar의 배경을 투명 설정하여 눈에 보이지 않게 설정하여 배경을 커스터마이징하여 직접 구현한다.
         // 배경을 직접 구현하므로써 애니메이션 효과를 직접 구현하여 Fade in/out 애니메이션 효과로 변경한다.
         backgroundColor: Colors.transparent,
         content: _FadeSnackBarContent(
           text: text,
           duration: duration,
           fadeDuration: fadeDuration,
         ),
       );
}

class _FadeSnackBarContent extends StatefulWidget {
  const _FadeSnackBarContent({
    required this.text,
    required this.duration,
    required this.fadeDuration,
  });

  final String text;
  final Duration duration;
  final Duration fadeDuration;

  @override
  State<_FadeSnackBarContent> createState() => _FadeSnackBarContentState();
}

class _FadeSnackBarContentState extends State<_FadeSnackBarContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  /// 스낵바 종료 애니메이션 처리 핸들러
  void _handleAnimationStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      // 스낵바 노출 시간 - fade 동작 시간 = fade out 대기 시간
      // ex: 3초 - 0.3초 = 2.7초
      final fadeOutDelay = widget.duration - widget.fadeDuration;
      if (fadeOutDelay <= Duration.zero) {
        return;
      }

      // 대기시간 만큼 대기 후 역방향 애니메이션 실행
      await Future.delayed(fadeOutDelay);
      if (mounted) {
        _controller.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.fadeDuration,
      reverseDuration: widget.fadeDuration,
      vsync: this,
    );
    _controller.addStatusListener(_handleAnimationStatusChanged);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    // 스낵바 노출 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  /// [FadeTransition] 위젯을 사용해서 스낵바 위젯에 Fade in/out 애니메이션 효과를 적용한다.
  /// [SnackBar] 위젯을 투명처리하고, [Container] 위젯을 사용해서 스낵바를 직접 구현한다. (애니메이션 처리를 위해 눈속임 처리)
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: theme.snackBarTheme.insetPadding,
        height: 50,
        width: theme.snackBarTheme.width,
        decoration: BoxDecoration(
          color: theme.snackBarTheme.backgroundColor,
          borderRadius:
              theme.snackBarTheme.shape is RoundedRectangleBorder
                  ? (theme.snackBarTheme.shape as RoundedRectangleBorder)
                      .borderRadius
                  : null,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: theme.snackBarTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
