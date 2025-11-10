# Руководство по настройке для заказчика

## Подготовка окружения

### Предпосылки

- Node.js 16+
- Xcode 14+ (для iOS)
- Android Studio 2022+ (для Android)
- CocoaPods (для iOS)
- Java 11+ (для Android)

## iOS Setup

1. Установить зависимости:
```bash
npm install
cd ios
pod install
cd ..
```

2. Открыть проект в Xcode:
```bash
open ios/RNCryptoProRutoken.xcworkspace
```

3. Настроить Bundle ID и сертификаты подписания

4. Установить CryptoPro CSP SDK:
   - Скачать SDK с https://www.cryptopro.ru
   - Добавить фреймворк в проект
   - Обновить Build Settings

5. Установить Rutoken SDK:
   - Скачать SDK с https://www.rutoken.ru
   - Добавить фреймворк в проект

6. Собрать проект:
```bash
xcodebuild -workspace ios/RNCryptoProRutoken.xcworkspace -scheme RNCryptoProRutoken -configuration Release
```

## Android Setup

1. Открыть проект в Android Studio:
```bash
open android -a "Android Studio"
```

2. Установить зависимости через gradle (автоматически)

3. Добавить CryptoPro CSP SDK:
   - Загрузить AAR из https://www.cryptopro.ru
   - Добавить в `android/app/libs/`
   - Обновить `android/app/build.gradle`

4. Добавить Rutoken SDK:
   - Загрузить AAR из https://www.rutoken.ru
   - Добавить в `android/app/libs/`

5. Настроить подпись APK:
   - Создать keystore файл
   - Обновить `android/app/build.gradle`

6. Собрать проект:
```bash
cd android
./gradlew assembleRelease
cd ..
```

## Интеграция в свой проект

1. Скопировать папку `src/` в ваш проект

2. Скопировать нативный код:
   - iOS: `ios/RNCryptoProRutoken/` → ваш `ios/` проект
   - Android: `android/app/src/main/java/com/cryptoproruto/` → ваш Android модуль

3. Обновить конфиги:
   - iOS: Добавить модуль в `RCTBridgeModule`
   - Android: Добавить пакет в `MainApplication.java`

4. Использовать API:
```typescript
import CryptoProRutokenAPI from './src/index';

const certificates = await CryptoProRutokenAPI.getAvailableCertificates();
```

## Тестирование

Запустить Example приложение:

### iOS
```bash
npm run ios
```

### Android
```bash
npm run android
```

## Решение проблем

### iOS - Pod не найден
```bash
cd ios && pod repo update && pod install
```

### Android - SDK не найден
Убедиться, что зависимости добавлены в `build.gradle`

### Ошибки компиляции Swift
- Проверить Deployment Target >= 12.0
- Очистить build folder (Cmd+Shift+K)

### Ошибки компиляции Java
- Проверить версию Java: `java -version`
- Очистить gradle кеш: `./gradlew clean`

## Документация SDK

- CryptoPro: https://www.cryptopro.ru/support
- Rutoken: https://www.rutoken.ru/support
