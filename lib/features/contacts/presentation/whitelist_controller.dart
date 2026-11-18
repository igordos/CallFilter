import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhitelistController extends StreamNotifier<List<ContactWhitelistEntry>> {
  @override
  Stream<List<ContactWhitelistEntry>> build() {
    return ref.watch(whitelistRepositoryProvider).watchEntries();
  }

  Future<void> addEntry(ContactWhitelistEntry entry) {
    return ref.read(whitelistRepositoryProvider).addEntry(entry);
  }

  Future<void> deleteEntry(String id) {
    return ref.read(whitelistRepositoryProvider).deleteEntry(id);
  }
}

final whitelistControllerProvider =
    StreamNotifierProvider<WhitelistController, List<ContactWhitelistEntry>>(
      WhitelistController.new,
    );
