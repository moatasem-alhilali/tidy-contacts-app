<div align="center">

# 📇 Tidy Contacts

**An on-device contacts cleaner that finds duplicates and normalizes your phone numbers — 100% private, no server.**

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 🧭 نظرة عامة (Arabic)

**Tidy Contacts** تطبيق لتنظيف جهات الاتصال يعمل **بالكامل على جهازك بدون أي سيرفر**. يكتشف الأرقام المكرّرة، ويوحّد صيغ أرقام الهاتف حسب قواعد قابلة للتخصيص، ويعرض لك **معاينة** لكل تغيير قبل تطبيقه. التطبيق ثنائي اللغة (عربي/إنجليزي) ويحترم خصوصيتك — بياناتك لا تغادر هاتفك.

---

## ✨ Features

- 🔍 **Duplicate detection** — automatically finds duplicate contacts on your device.
- 🧹 **Number normalization** — clean and standardize phone number formats using customizable rules.
- 📐 **Custom cleaning rules** — define your own rules and see which contacts they affect.
- 👀 **Preview before apply** — review every change before it touches your address book.
- 🔒 **Privacy-first** — all processing happens **on-device**. No backend, no data collection.
- 🌍 **Bilingual** — full Arabic 🇸🇦 and English 🇬🇧 support (RTL-aware).
- 🎨 **Modern UI** — Material 3, responsive layout, light & dark themes.

---

## 📱 Screenshots

> _Add screenshots to `doc/screenshots/` and reference them here._

| Overview | Duplicates | Rules | Preview |
| :---: | :---: | :---: | :---: |
| _tbd_ | _tbd_ | _tbd_ | _tbd_ |

---

## 🛠 Tech Stack

| Area | Package(s) |
| --- | --- |
| **State management** | `flutter_riverpod`, `riverpod_annotation` |
| **Routing** | `auto_route` |
| **Networking** | `dio`, `retrofit` |
| **Local storage** | `hive`, `shared_preferences`, `flutter_secure_storage` |
| **Contacts** | `flutter_contacts` |
| **Localization** | `easy_localization` |
| **UI / UX** | `flutter_screenutil`, `skeletonizer`, `modal_bottom_sheet`, `pinput`, `cached_network_image` |
| **Sharing** | `share_plus` |
| **Codegen** | `freezed`, `json_serializable`, `build_runner`, `flutter_gen` |

> ℹ️ Firebase (Analytics / Messaging / Crashlytics) is currently **disabled** — all Firebase code is commented out and can be re-enabled later.

---

## 🏗 Architecture

Feature-first, layered structure with Riverpod for dependency injection and state.

```
lib/
├── main.dart                     # App entry point
├── src/
│   ├── config/                   # Routing, guards, app-level config
│   ├── core/                     # Shared building blocks
│   │   ├── di/                   # Riverpod providers / injection
│   │   ├── network/              # Dio client, interceptors, error handling
│   │   ├── services/             # Notifications, monitoring, storage
│   │   ├── widgets/              # Reusable widgets (maps, etc.)
│   │   └── utils/                # Helpers, constants, logger
│   └── features/                 # Feature modules
│       ├── splash/
│       ├── home/
│       └── contact_cleaner/      # ⭐ Core feature
│           ├── data/             #   models, repositories, cleaning engine
│           └── presentation/     #   providers + UI (overview / duplicates / rules / preview)
├── design-system-package/        # In-repo design system & shared forms
└── gen/                          # Generated assets (flutter_gen)
```

> **Note:** the internal Dart package name is `hive_manager` (imports use `package:hive_manager/...`). The user-facing app name is **Tidy Contacts**.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) **3.41+** (Dart **3.8+**)
- Android Studio / Xcode for the respective platforms

### 1. Clone

```bash
git clone https://github.com/moatasem-alhilali/tidy-contacts-app.git
cd tidy-contacts-app
```

### 2. Configure environment

Create a `.env` file in the project root (see `.env.example`):

```bash
cp .env.example .env
```

```env
BASE_URL=https://your-api-base-url.com
```

### 3. Install dependencies & generate code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run

```bash
flutter run
```

---

## 🔧 Configuration

### App identifiers

| Platform | Identifier |
| --- | --- |
| Android `applicationId` | `android/app/build.gradle.kts` |
| iOS `PRODUCT_BUNDLE_IDENTIFIER` | `moatasem.contactclean.com` |

---

## 📦 Building for release

CI workflows are provided under [`.github/workflows/`](.github/workflows/):

- `build_apk.yml` — builds a signed APK (requires keystore secrets).
- `build_apk_without_keystore.yml` — builds an unsigned/debug APK.

Manual builds:

```bash
flutter build apk --release      # Android
flutter build appbundle --release
flutter build ios --release      # iOS (run on macOS, then `pod install` in ios/)
```

---

## 🔐 Security

- All contact processing is **on-device**; the app does not upload your contacts anywhere.
- Do **not** hardcode secrets. Keep API keys and `BASE_URL` out of version control — `.env` is git-ignored.
- If a key was ever committed, **rotate it** and add API restrictions in its provider console.

---

## 🛡️ Privacy Policy

Tidy Contacts collects **no data** — all processing happens on your device. A bilingual
(Arabic/English) privacy policy is included at [`docs/privacy-policy.html`](docs/privacy-policy.html).

**To publish it for the App Store (free, via GitHub Pages):**

1. On GitHub → **Settings → Pages**.
2. Under *Build and deployment*, set **Source: Deploy from a branch**, **Branch: `main`**, **Folder: `/docs`**, then **Save**.
3. After a minute your policy is live at:
   ```
   https://moatasem-alhilali.github.io/tidy-contacts-app/privacy-policy.html
   ```
4. Paste that URL into **App Store Connect → App Privacy → Privacy Policy URL**.

> Before publishing, replace `REPLACE_WITH_YOUR_EMAIL@example.com` in the HTML with your real support email.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repo and create a feature branch (`git checkout -b feature/my-feature`).
2. Run `flutter analyze` and make sure it passes.
3. Commit with a clear message and open a Pull Request.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

---

<div align="center">

Made with ❤️ using Flutter · **Tidy Contacts**

</div>
