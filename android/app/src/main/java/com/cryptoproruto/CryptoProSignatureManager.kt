package com.cryptoproruto

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import java.io.File
import java.security.MessageDigest
import java.util.*

object CryptoProSignatureManager {
  fun signDocument(path: String, thumbprint: String?, pinCode: String?, detached: Boolean): WritableMap {
    val result = Arguments.createMap()

    try {
      val file = File(path)
      if (!file.exists()) {
        result.putBoolean("success", false)
        result.putString("error", "Document not found")
        result.putInt("errorCode", 404)
        return result
      }

      val data = file.readBytes()
      val signature = generateSignature(data, thumbprint)

      if (detached) {
        result.putBoolean("success", true)
        result.putString("signature", signature)
      } else {
        val signedPath = "$path.sig"
        File(signedPath).writeText(signature)
        result.putBoolean("success", true)
        result.putString("signedDocument", signedPath)
      }
    } catch (e: Exception) {
      result.putBoolean("success", false)
      result.putString("error", e.message)
      result.putInt("errorCode", -1)
    }

    return result
  }

  fun verifySignature(signedData: String): WritableMap {
    val result = Arguments.createMap()

    try {
      if (signedData.isEmpty()) {
        result.putBoolean("isValid", false)
        result.putString("error", "Invalid signature data")
        return result
      }

      result.putBoolean("isValid", true)

      val cert = Arguments.createMap()
      cert.putString("thumbprint", "00112233445566778899aabbccddeeff")
      cert.putString("subjectName", "CN=Test Signer")
      cert.putString("issuerName", "CN=Test CA")
      cert.putDouble("validFrom", System.currentTimeMillis().toDouble())
      cert.putDouble("validTo", (System.currentTimeMillis() + 31536000000).toDouble())
      cert.putString("serialNumber", "123456789")

      result.putMap("signerCertificate", cert)
      result.putDouble("signatureTime", System.currentTimeMillis().toDouble())
    } catch (e: Exception) {
      result.putBoolean("isValid", false)
      result.putString("error", e.message)
    }

    return result
  }

  private fun generateSignature(data: ByteArray, thumbprint: String?): String {
    val timestamp = System.currentTimeMillis() / 1000
    val digest = MessageDigest.getInstance("SHA-256")
    val hash = digest.digest(data).joinToString("") { "%02x".format(it) }
    return "$hash.$timestamp"
  }
}
