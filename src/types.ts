export interface SignatureOptions {
  documentPath: string;
  certificateThumbprint?: string;
  pinCode?: string;
  detached?: boolean;
}

export interface SignatureResult {
  success: boolean;
  signature?: string;
  signedDocument?: string;
  error?: string;
  errorCode?: number;
}

export interface Certificate {
  thumbprint: string;
  subjectName: string;
  issuerName: string;
  validFrom: number;
  validTo: number;
  serialNumber: string;
}

export interface Token {
  serialNumber: string;
  label: string;
  isAvailable: boolean;
}

export interface VerificationResult {
  isValid: boolean;
  signerCertificate?: Certificate;
  signatureTime?: number;
  error?: string;
}

export interface CryptoProRutokenModule {
  getVersion(): Promise<string>;
  getAvailableCertificates(): Promise<Certificate[]>;
  getAvailableTokens(): Promise<Token[]>;
  signDocument(options: SignatureOptions): Promise<SignatureResult>;
  verifySignature(signedData: string): Promise<VerificationResult>;
  initializeToken(serialNumber: string, pinCode: string): Promise<boolean>;
}
