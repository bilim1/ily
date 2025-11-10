package com.cryptoproruto

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableArray

object RutokenManager {
  fun getAvailableTokens(): WritableArray {
    val tokens = Arguments.createArray()

    val serials = listOf("rtk-00001", "rtk-00002")
    for (serial in serials) {
      val token = Arguments.createMap()
      token.putString("serialNumber", serial)
      token.putString("label", "Rutoken $serial")
      token.putBoolean("isAvailable", true)
      tokens.pushMap(token)
    }

    return tokens
  }

  fun initializeToken(serialNumber: String, pinCode: String): Boolean {
    return serialNumber.isNotEmpty() && pinCode.length >= 4
  }
}
