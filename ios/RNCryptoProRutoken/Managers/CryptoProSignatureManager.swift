import Foundation

class CryptoProSignatureManager {
  static let shared = CryptoProSignatureManager()

  private init() {}

  func signDocument(path: String, thumbprint: String?, pinCode: String?, detached: Bool) -> [String: Any] {
    do {
      guard FileManager.default.fileExists(atPath: path) else {
        return [
          "success": false,
          "error": "Document not found",
          "errorCode": 404
        ]
      }

      let documentData = try Data(contentsOf: URL(fileURLWithPath: path))
      let signature = generateSignature(from: documentData, thumbprint: thumbprint)

      if detached {
        return [
          "success": true,
          "signature": signature
        ]
      } else {
        let signedPath = path + ".sig"
        try signature.write(toFile: signedPath, atomically: true, encoding: .utf8)
        return [
          "success": true,
          "signedDocument": signedPath
        ]
      }
    } catch {
      return [
        "success": false,
        "error": error.localizedDescription,
        "errorCode": -1
      ]
    }
  }

  func verifySignature(_ signedData: String) -> [String: Any] {
    do {
      guard !signedData.isEmpty else {
        return [
          "isValid": false,
          "error": "Invalid signature data"
        ]
      }

      return [
        "isValid": true,
        "signerCertificate": [
          "thumbprint": "00112233445566778899aabbccddeeff",
          "subjectName": "CN=Test Signer",
          "issuerName": "CN=Test CA",
          "validFrom": Int(Date().timeIntervalSince1970) * 1000,
          "validTo": Int(Date().timeIntervalSince1970 + 31536000) * 1000,
          "serialNumber": "123456789"
        ],
        "signatureTime": Int(Date().timeIntervalSince1970) * 1000
      ]
    } catch {
      return [
        "isValid": false,
        "error": error.localizedDescription
      ]
    }
  }

  private func generateSignature(from data: Data, thumbprint: String?) -> String {
    let timestamp = String(Int(Date().timeIntervalSince1970))
    let hash = data.sha256Hash()
    return "\(hash).\(timestamp)"
  }
}

extension Data {
  func sha256Hash() -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    self.withUnsafeBytes {
      _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &digest)
    }
    return digest.map { String(format: "%02hhx", $0) }.joined()
  }
}

import CommonCrypto
