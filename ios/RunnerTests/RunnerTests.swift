import Testing

@testable import Runner

struct RunnerTests {

  @Test
  func parsesPreparedDirectoryMappings() throws {
    let raw = """
      {
        "filteringEnabled": false,
        "rules": [
          {"id": "rule-1", "name": "Работа", "pattern": "ооо\\\\s+работа", "priority": 5}
        ],
        "whitelistNumbers": ["77001234567"],
        "directoryMappings": [
          {"phoneNumber": "77007654321", "label": "ООО Работа", "shouldBlock": true}
        ]
      }
      """

    let snapshot = CallFilterSnapshot.parse(raw)

    #expect(snapshot.filteringEnabled == false)
    #expect(snapshot.rules.count == 1)
    #expect(snapshot.rules.first?.priority == 5)
    #expect(snapshot.whitelistNumbers == ["77001234567"])
    #expect(snapshot.directoryMappings.first?.shouldBlock == true)
  }

  @Test
  func fallsBackToSafeDefaultsForInvalidJson() {
    let snapshot = CallFilterSnapshot.parse("not json")

    #expect(snapshot.filteringEnabled)
    #expect(snapshot.rules.isEmpty)
    #expect(snapshot.whitelistNumbers.isEmpty)
    #expect(snapshot.directoryMappings.isEmpty)
  }
}
