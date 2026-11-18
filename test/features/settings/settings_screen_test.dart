import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('settings cards keep the shared page gutter', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_settings')));
    await settle(tester);

    final cardRect = tester.getRect(find.byType(AppCard).first);
    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(cardRect.left, AppSpacing.page);
    expect(cardRect.right, screenWidth - AppSpacing.page);
  });
}
