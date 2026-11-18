import Foundation

struct CallFilterRule: Equatable {
  let id: String
  let name: String
  let pattern: String
  let priority: Int
}

struct CallFilterDirectoryMapping: Equatable {
  let phoneNumber: String
  let label: String
  let shouldBlock: Bool
}

/// The native side of the Flutter -> Call Directory bridge.
///
/// iOS cannot evaluate RegExp patterns or caller display names at call time.
/// The extension can only use prepared phone-number mappings.
struct CallFilterSnapshot: Equatable {
  static let appGroupIdentifier = "group.com.callfilter.callFilter"
  static let storageKey = "call_filter_snapshot"

  let filteringEnabled: Bool
  let rules: [CallFilterRule]
  let whitelistNumbers: [String]
  let directoryMappings: [CallFilterDirectoryMapping]

  static func parse(_ raw: String?) -> CallFilterSnapshot {
    guard
      let raw,
      !raw.isEmpty,
      let data = raw.data(using: .utf8),
      let object = try? JSONSerialization.jsonObject(with: data),
      let root = object as? [String: Any]
    else {
      return CallFilterSnapshot(
        filteringEnabled: true,
        rules: [],
        whitelistNumbers: [],
        directoryMappings: []
      )
    }

    let rules = (root["rules"] as? [[String: Any]] ?? []).map { item in
      CallFilterRule(
        id: item["id"] as? String ?? "",
        name: item["name"] as? String ?? "",
        pattern: item["pattern"] as? String ?? "",
        priority: item["priority"] as? Int ?? 0
      )
    }
    let whitelistNumbers = root["whitelistNumbers"] as? [String] ?? []
    let directoryMappings =
      (root["directoryMappings"] as? [[String: Any]] ?? []).map { item in
        CallFilterDirectoryMapping(
          phoneNumber: item["phoneNumber"] as? String ?? "",
          label: item["label"] as? String ?? "",
          shouldBlock: item["shouldBlock"] as? Bool ?? false
        )
      }

    return CallFilterSnapshot(
      filteringEnabled: root["filteringEnabled"] as? Bool ?? true,
      rules: rules,
      whitelistNumbers: whitelistNumbers,
      directoryMappings: directoryMappings
    )
  }

  static func loadFromSharedDefaults() -> CallFilterSnapshot {
    let raw = CallFilterSnapshotStore.defaults.string(
      forKey: CallFilterSnapshot.storageKey
    )
    return parse(raw)
  }
}

enum CallFilterSnapshotStore {
  static var defaults: UserDefaults {
    UserDefaults(suiteName: CallFilterSnapshot.appGroupIdentifier) ?? .standard
  }

  @discardableResult
  static func save(_ raw: String) -> Bool {
    defaults.set(raw, forKey: CallFilterSnapshot.storageKey)
    return true
  }
}
