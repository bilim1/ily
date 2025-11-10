import { NativeModules } from 'react-native';
import type { CryptoProRutokenModule, SignatureOptions, SignatureResult, Certificate, Token, VerificationResult } from './types';

const NativeCryptoProRutoken = NativeModules.CryptoProRutoken as CryptoProRutokenModule;

if (!NativeCryptoProRutoken) {
  throw new Error('CryptoProRutoken native module not found');
}

export class CryptoProRutokenAPI {
  static async getVersion(): Promise<string> {
    return NativeCryptoProRutoken.getVersion();
  }

  static async getAvailableCertificates(): Promise<Certificate[]> {
    return NativeCryptoProRutoken.getAvailableCertificates();
  }

  static async getAvailableTokens(): Promise<Token[]> {
    return NativeCryptoProRutoken.getAvailableTokens();
  }

  static async signDocument(options: SignatureOptions): Promise<SignatureResult> {
    return NativeCryptoProRutoken.signDocument(options);
  }

  static async verifySignature(signedData: string): Promise<VerificationResult> {
    return NativeCryptoProRutoken.verifySignature(signedData);
  }

  static async initializeToken(serialNumber: string, pinCode: string): Promise<boolean> {
    return NativeCryptoProRutoken.initializeToken(serialNumber, pinCode);
  }
}

export default CryptoProRutokenAPI;
export * from './types';
