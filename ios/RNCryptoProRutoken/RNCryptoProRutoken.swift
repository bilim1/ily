import Foundation

@objc(RNCryptoProRutoken)
class RNCryptoProRutoken: NSObject {

  override static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc
  func getVersion(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    do {
      resolve("1.0.0")
    } catch {
      reject("ERROR", "Failed to get version", error)
    }
  }

  @objc
  func getAvailableCertificates(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    do {
      let certificates = CryptoProCertificateManager.shared.getAvailableCertificates()
      resolve(certificates)
    } catch {
      reject("ERROR", "Failed to get certificates", error)
    }
  }

  @objc
  func getAvailableTokens(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    do {
      let tokens = RutokenManager.shared.getAvailableTokens()
      resolve(tokens)
    } catch {
      reject("ERROR", "Failed to get tokens", error)
    }
  }

  @objc
  func signDocument(_ options: NSDictionary, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.global().async {
      do {
        let documentPath = options["documentPath"] as? String ?? ""
        let thumbprint = options["certificateThumbprint"] as? String
        let pinCode = options["pinCode"] as? String
        let detached = options["detached"] as? Bool ?? false

        let result = CryptoProSignatureManager.shared.signDocument(
          path: documentPath,
          thumbprint: thumbprint,
          pinCode: pinCode,
          detached: detached
        )

        resolve(result)
      } catch {
        reject("SIGN_ERROR", "Failed to sign document", error)
      }
    }
  }

  @objc
  func verifySignature(_ signedData: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.global().async {
      do {
        let result = CryptoProSignatureManager.shared.verifySignature(signedData)
        resolve(result)
      } catch {
        reject("VERIFY_ERROR", "Failed to verify signature", error)
      }
    }
  }

  @objc
  func initializeToken(_ serialNumber: String, pinCode: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    do {
      let success = RutokenManager.shared.initializeToken(serialNumber: serialNumber, pinCode: pinCode)
      resolve(success)
    } catch {
      reject("TOKEN_ERROR", "Failed to initialize token", error)
    }
  }
}
