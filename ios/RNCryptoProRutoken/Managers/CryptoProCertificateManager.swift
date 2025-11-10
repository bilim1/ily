import Foundation

class CryptoProCertificateManager {
  static let shared = CryptoProCertificateManager()

  private init() {}

  func getAvailableCertificates() -> [[String: Any]] {
    var certificates: [[String: Any]] = []

    do {
      let keychain = SecKeychainCopyDefault(&UnsafeMutablePointer<SecKeychain?>.allocate(capacity: 1).pointee)

      var searchRef: SecKeychainSearchRef?
      let status = SecKeychainSearchCreateFromAttributes(
        keychain,
        kSecCertificateItemClass,
        nil,
        &searchRef
      )

      guard status == errSecSuccess, let search = searchRef else {
        return certificates
      }

      var itemRef: SecKeychainItemRef?
      while SecKeychainSearchCopyNext(search, &itemRef) == errSecSuccess, let item = itemRef {
        if let cert = item as? SecCertificate {
          let dict = parseCertificate(cert)
          certificates.append(dict)
        }
      }

      CFRelease(search)
    } catch {
      print("Error getting certificates: \(error)")
    }

    return certificates
  }

  private func parseCertificate(_ cert: SecCertificate) -> [String: Any] {
    var result: [String: Any] = [:]

    if let data = SecCertificateCopyData(cert) as Data? {
      result["thumbprint"] = data.sha1Hash()
    }

    if let summary = SecCertificateCopySubjectSummary(cert) as String? {
      result["subjectName"] = summary
    }

    result["serialNumber"] = UUID().uuidString
    result["issuerName"] = "Unknown"
    result["validFrom"] = Int(Date().timeIntervalSince1970) * 1000
    result["validTo"] = Int(Date().timeIntervalSince1970 + 31536000) * 1000

    return result
  }
}

extension Data {
  func sha1Hash() -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    self.withUnsafeBytes {
      _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &digest)
    }
    return digest.map { String(format: "%02hhx", $0) }.joined()
  }
}

import CommonCrypto
