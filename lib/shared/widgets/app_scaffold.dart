import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.maxContentWidth = AppSizes.pageMaxWidth,
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double maxContentWidth;
  final bool resizeToAvoidBottomInset;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final overlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: colors.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: title == null
            ? null
            : AppBar(
                title: Text(title!),
                actions: actions,
                leading: leading,
                leadingWidth: leading == null ? null : 64,
              ),
        body: _constrainedBody(),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Widget _constrainedBody() {
    final content = Center(
      child: ConstrainedBox(
        key: const Key('app_content_max_width'),
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: body,
      ),
    );
    return safeArea ? SafeArea(top: false, child: content) : content;
  }
}
