import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';

/// Persistence boundary for the local whitelist.
abstract interface class WhitelistRepository {
  Stream<List<ContactWhitelistEntry>> watchEntries();

  Future<List<ContactWhitelistEntry>> getEntries();

  Future<void> addEntry(ContactWhitelistEntry entry);

  Future<void> deleteEntry(String id);
}
