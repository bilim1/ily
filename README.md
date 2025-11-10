# React Native CryptoPro Rutoken

Кроссплатформенный модуль для React Native, обеспечивающий подпись документов электронной подписью через CryptoPro CSP SDK и Рутокен.

## Возможности

- Получение доступных сертификатов
- Получение доступных токенов Рутокен
- Подпись документов
- Верификация подписей
- Инициализация токенов

## Требования

- React Native >= 0.70.0
- iOS 12.0+
- Android 24+
- CryptoPro CSP SDK
- Rutoken SDK

## Установка

### iOS

1. Установить CocoaPods зависимости:
```bash
cd ios && pod install
```

2. Добавить CryptoPro CSP и Rutoken в Podfile:
```ruby
pod 'CryptoPro-CSP'
pod 'Rutoken'
```

3. Запустить `pod install`

### Android

1. Добавить Maven репозитории в `android/build.gradle`:
```gradle
maven { url 'https://download.cpdn.cryptopro.ru/java/maven/' }
maven { url 'https://jitpack.io' }
```

2. Добавить зависимости в `android/app/build.gradle`:
```gradle
implementation 'ru.crypto-pro:csp-sdk:+'
implementation 'ru.rutoken:rtpkcs11:1.5.0'
```

## Использование

```typescript
import CryptoProRutokenAPI from 'react-native-cryptopro-rutoken';

// Получить версию
const version = await CryptoProRutokenAPI.getVersion();

// Получить доступные сертификаты
const certificates = await CryptoProRutokenAPI.getAvailableCertificates();

// Получить доступные токены
const tokens = await CryptoProRutokenAPI.getAvailableTokens();

// Подписать документ
const result = await CryptoProRutokenAPI.signDocument({
  documentPath: '/path/to/document',
  detached: true
});

// Верифицировать подпись
const verification = await CryptoProRutokenAPI.verifySignature(signatureData);

// Инициализировать токен
const initialized = await CryptoProRutokenAPI.initializeToken(
  'serial-number',
  'pin-code'
);
```

## API

### getVersion()
Возвращает версию библиотеки.

### getAvailableCertificates()
Возвращает массив доступных сертификатов.

Возвращает:
```typescript
{
  thumbprint: string;
  subjectName: string;
  issuerName: string;
  validFrom: number;
  validTo: number;
  serialNumber: string;
}[]
```

### getAvailableTokens()
Возвращает массив доступных токенов.

Возвращает:
```typescript
{
  serialNumber: string;
  label: string;
  isAvailable: boolean;
}[]
```

### signDocument(options)
Подписывает документ.

Параметры:
```typescript
{
  documentPath: string;
  certificateThumbprint?: string;
  pinCode?: string;
  detached?: boolean;
}
```

Возвращает:
```typescript
{
  success: boolean;
  signature?: string;
  signedDocument?: string;
  error?: string;
  errorCode?: number;
}
```

### verifySignature(signedData)
Верифицирует подпись.

Возвращает:
```typescript
{
  isValid: boolean;
  signerCertificate?: Certificate;
  signatureTime?: number;
  error?: string;
}
```

### initializeToken(serialNumber, pinCode)
Инициализирует токен с PIN-кодом.

Возвращает: `boolean`

## Структура проекта

```
.
├── src/
│   ├── index.ts              # Основной API
│   └── types.ts              # TypeScript типы
├── ios/
│   ├── RNCryptoProRutoken.podspec
│   └── RNCryptoProRutoken/
│       ├── RNCryptoProRutoken.swift
│       ├── RNCryptoProRutoken.m
│       └── Managers/
│           ├── CryptoProCertificateManager.swift
│           ├── RutokenManager.swift
│           └── CryptoProSignatureManager.swift
├── android/
│   └── app/src/main/java/com/cryptoproruto/
│       ├── CryptoProRutokenModule.kt
│       ├── CryptoProRutokenPackage.kt
│       ├── CryptoProCertificateManager.kt
│       ├── RutokenManager.kt
│       └── CryptoProSignatureManager.kt
├── Example/
│   └── App.tsx
└── package.json
```

## Сборка

### iOS

```bash
cd ios
xcodebuild -workspace RNCryptoProRutoken.xcworkspace -scheme RNCryptoProRutoken -configuration Release
```

### Android

```bash
cd android
./gradlew assembleRelease
```

## Лицензия

MIT

## Поддержка

Для сообщения об ошибках и пожеланий используйте GitHub Issues.
