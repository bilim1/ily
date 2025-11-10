# Архитектура React Native CryptoPro Rutoken

## Структура

```
├── src/                          # Основной TypeScript API
│   ├── index.ts                 # Экспорт класса CryptoProRutokenAPI
│   └── types.ts                 # Интерфейсы и типы
│
├── ios/                          # iOS нативный код
│   ├── RNCryptoProRutoken.podspec
│   ├── Podfile
│   └── RNCryptoProRutoken/
│       ├── RNCryptoProRutoken.swift      # Основной модуль
│       ├── RNCryptoProRutoken.m          # Мост для React Native
│       └── Managers/
│           ├── CryptoProCertificateManager.swift
│           ├── RutokenManager.swift
│           └── CryptoProSignatureManager.swift
│
├── android/                      # Android нативный код
│   ├── build.gradle
│   ├── settings.gradle
│   └── app/src/main/java/com/cryptoproruto/
│       ├── CryptoProRutokenModule.kt      # Основной модуль
│       ├── CryptoProRutokenPackage.kt     # React Native пакет
│       └── Managers/
│           ├── CryptoProCertificateManager.kt
│           ├── RutokenManager.kt
│           └── CryptoProSignatureManager.kt
│
└── Example/                      # Пример приложения
    └── App.tsx
```

## Поток данных

```
JavaScript (React Native)
        ↓
    TypeScript API (index.ts)
        ↓
    Native Bridge (RCTBridgeModule)
        ↓
    Platform-specific Managers
        ↓
    CryptoPro CSP SDK / Rutoken SDK
        ↓
    Cryptographic Operations
```

## Компоненты

### 1. JavaScript API (src/index.ts)

Предоставляет простой интерфейс для JavaScript:

```typescript
CryptoProRutokenAPI.signDocument(options)
CryptoProRutokenAPI.getAvailableCertificates()
CryptoProRutokenAPI.getAvailableTokens()
```

### 2. iOS Native Module

**RNCryptoProRutoken.swift** - основной модуль, обработчик методов
**RNCryptoProRutoken.m** - Objective-C bridge для React Native

Менеджеры:
- **CryptoProCertificateManager** - работа с сертификатами
- **RutokenManager** - управление токенами
- **CryptoProSignatureManager** - криптографические операции

### 3. Android Native Module

**CryptoProRutokenModule.kt** - основной модуль React Native
**CryptoProRutokenPackage.kt** - регистрация пакета

Менеджеры:
- **CryptoProCertificateManager** - работа с сертификатами
- **RutokenManager** - управление токенами
- **CryptoProSignatureManager** - криптографические операции

## Методы API

### getVersion()
Получить версию библиотеки

### getAvailableCertificates()
1. iOS: Поиск в Keychain через SecKeychain API
2. Android: Поиск в AndroidKeyStore
3. Возврат массива Certificate объектов

### getAvailableTokens()
1. iOS: Запрос к Rutoken SDK
2. Android: Запрос к Rutoken SDK
3. Возврат массива Token объектов

### signDocument(options)
1. Проверка наличия файла документа
2. Чтение содержимого файла
3. Выбор сертификата (если не указан)
4. Создание подписи через CryptoPro SDK
5. Возврат подписи или пути к подписанному документу

### verifySignature(signedData)
1. Парсинг подписи
2. Верификация через CryptoPro SDK
3. Извлечение информации о сертификате
4. Возврат результата и данных о подписанте

### initializeToken(serialNumber, pinCode)
1. Поиск токена по серийному номеру
2. Проверка PIN-кода
3. Инициализация токена
4. Возврат статуса

## Интеграция с SDK

### CryptoPro CSP

**iOS:**
```swift
import CryptoPro
// Использование CryptoPro API
```

**Android:**
```kotlin
import ru.crypto.pro.*
// Использование CryptoPro API
```

### Rutoken

**iOS:**
```swift
import Rutoken
// Использование Rutoken API
```

**Android:**
```kotlin
import ru.rutoken.*
// Использование Rutoken API
```

## Обработка ошибок

- JS → Native преобразование errors в `Promise.reject()`
- Promise отклоняются с кодом ошибки и сообщением
- Все исключения обрабатываются в try-catch блоках

## Безопасность

- PIN-коды не сохраняются в памяти дольше необходимого
- Приватные ключи хранятся в защищенном хранилище (Keychain/AndroidKeyStore)
- Все криптографические операции выполняются нативным кодом
- Подписи передаются в безопасном формате

## Производительность

- Асинхронные операции выполняются в фоновых потоках
- Кеширование списков сертификатов и токенов
- Минимальное преобразование данных между JS и Native

## Расширение функциональности

Для добавления новых методов:

1. Добавить в `types.ts`
2. Добавить метод в `index.ts`
3. Реализовать в `RNCryptoProRutoken.swift`
4. Добавить в `RNCryptoProRutoken.m`
5. Реализовать в `CryptoProRutokenModule.kt`
6. Обновить менеджеры при необходимости
