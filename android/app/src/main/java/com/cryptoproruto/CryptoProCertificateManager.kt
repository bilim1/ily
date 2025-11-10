package com.cryptoproruto

import android.content.Context
import android.content.pm.ApplicationInfo
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import java.security.KeyStore

object CryptoProCertificateManager {
  fun getAvailableCertificates(context: Context): WritableArray {
    val certificates = Arguments.createArray()

    try {
      val keystore = KeyStore.getInstance("AndroidKeyStore")
      keystore.load(null)

      val aliases = keystore.aliases()
      while (aliases.hasMoreElements()) {
        val alias = aliases.nextElement()
        val cert = keystore.getCertificate(alias)

        if (cert != null) {
          val certMap = Arguments.createMap()
          certMap.putString("thumbprint", getThumbprint(cert.encoded))
          certMap.putString("subjectName", cert.toString())
          certMap.putString("serialNumber", alias)
          certMap.putString("issuerName", "Unknown")
          certMap.putDouble("validFrom", System.currentTimeMillis().toDouble())
          certMap.putDouble("validTo", (System.currentTimeMillis() + 31536000000).toDouble())

          certificates.pushMap(certMap)
        }
      }
    } catch (e: Exception) {
      e.printStackTrace()
    }

    return certificates
  }

  private fun getThumbprint(cert: ByteArray): String {
    return cert.joinToString("") { "%02x".format(it) }
  }
}
