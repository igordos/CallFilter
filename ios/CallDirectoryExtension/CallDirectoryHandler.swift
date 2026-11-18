import CallKit
import Foundation

/// Call Directory Extension entry point.
///
/// This target is not part of the generated Flutter Xcode project yet. To
/// enable it, add a Call Directory Extension target named
/// `CallDirectoryExtension`, add `CallFilterSnapshot.swift` to that target, set
/// the App Group to `group.com.callfilter.callFilter`, and enable the Call
/// Directory capability in the system settings. See
/// docs/platform-limitations.md for the full checklist.
final class CallDirectoryHandler: CXCallDirectoryProvider {
  override func beginRequest(with context: CXCallDirectoryExtensionContext) {
    let snapshot = CallFilterSnapshot.loadFromSharedDefaults()

    let blockingNumbers = Set(
      snapshot.directoryMappings
        .filter(\.shouldBlock)
        .compactMap { SequentialPhoneNumber($0.phoneNumber) }
    )
    for entry in blockingNumbers.sorted(by: { $0.value < $1.value }) {
      context.addBlockingEntry(withNextSequentialPhoneNumber: entry.value)
    }

    var identificationByNumber: [Int64: String] = [:]
    for mapping in snapshot.directoryMappings where !mapping.shouldBlock {
      guard
        let entry = SequentialPhoneNumber(mapping.phoneNumber),
        !mapping.label.isEmpty,
        identificationByNumber[entry.value] == nil
      else {
        continue
      }
      identificationByNumber[entry.value] = mapping.label
    }
    for (number, label) in identificationByNumber.sorted(by: { $0.key < $1.key }) {
      context.addIdentificationEntry(
        withNextSequentialPhoneNumber: number,
        label: label
      )
    }

    context.completeRequest()
  }
}

private struct SequentialPhoneNumber: Hashable {
  let value: Int64

  init?(_ raw: String) {
    let digits = raw.filter(\.isNumber)
    guard !digits.isEmpty, let value = Int64(digits) else {
      return nil
    }
    self.value = value
  }
}
