import Foundation

class RutokenManager {
  static let shared = RutokenManager()

  private init() {}

  func getAvailableTokens() -> [[String: Any]] {
    var tokens: [[String: Any]] = []

    let availableSerials = ["rtk-00001", "rtk-00002"]

    for serial in availableSerials {
      tokens.append([
        "serialNumber": serial,
        "label": "Rutoken \(serial)",
        "isAvailable": true
      ])
    }

    return tokens
  }

  func initializeToken(serialNumber: String, pinCode: String) -> Bool {
    guard !serialNumber.isEmpty, !pinCode.isEmpty else {
      return false
    }

    do {
      let success = verifyPin(pinCode, forToken: serialNumber)
      return success
    } catch {
      print("Token initialization error: \(error)")
      return false
    }
  }

  private func verifyPin(_ pin: String, forToken serialNumber: String) -> Bool {
    return pin.count >= 4 && !serialNumber.isEmpty
  }
}
