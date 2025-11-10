package com.cryptoproruto

import android.content.Context
import com.facebook.react.bridge.*
import java.io.File
import java.security.MessageDigest
import java.util.*

class CryptoProRutokenModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
  override fun getName() = "CryptoProRutoken"

  @ReactMethod
  fun getVersion(promise: Promise) {
    try {
      promise.resolve("1.0.0")
    } catch (e: Exception) {
      promise.reject("ERROR", e.message)
    }
  }

  @ReactMethod
  fun getAvailableCertificates(promise: Promise) {
    try {
      val certificates = CryptoProCertificateManager.getAvailableCertificates(reactApplicationContext)
      promise.resolve(certificates)
    } catch (e: Exception) {
      promise.reject("ERROR", e.message)
    }
  }

  @ReactMethod
  fun getAvailableTokens(promise: Promise) {
    try {
      val tokens = RutokenManager.getAvailableTokens()
      promise.resolve(tokens)
    } catch (e: Exception) {
      promise.reject("ERROR", e.message)
    }
  }

  @ReactMethod
  fun signDocument(options: ReadableMap, promise: Promise) {
    try {
      val documentPath = options.getString("documentPath") ?: ""
      val thumbprint = options.getString("certificateThumbprint")
      val pinCode = options.getString("pinCode")
      val detached = options.getBoolean("detached")

      val result = CryptoProSignatureManager.signDocument(
        documentPath, thumbprint, pinCode, detached
      )
      promise.resolve(result)
    } catch (e: Exception) {
      promise.reject("SIGN_ERROR", e.message)
    }
  }

  @ReactMethod
  fun verifySignature(signedData: String, promise: Promise) {
    try {
      val result = CryptoProSignatureManager.verifySignature(signedData)
      promise.resolve(result)
    } catch (e: Exception) {
      promise.reject("VERIFY_ERROR", e.message)
    }
  }

  @ReactMethod
  fun initializeToken(serialNumber: String, pinCode: String, promise: Promise) {
    try {
      val success = RutokenManager.initializeToken(serialNumber, pinCode)
      promise.resolve(success)
    } catch (e: Exception) {
      promise.reject("TOKEN_ERROR", e.message)
    }
  }
}
