# Wens mobile app (Flutter)

The Android app is not generated yet. Create it once, from this folder, on a machine with Flutter installed:

```bash
cd mobile
flutter create --org com.wens --project-name wens_mobile --platforms android .
```

## Planned structure

```
lib/
  core/          API client, JWT storage, theme, localization
  features/
    auth/        register, login, link device with code
    patient/     patient home, today list, reminder screen, SOS
    caregiver/   dashboard, medicines, appointments, map, alerts, report
  main.dart
```

## Main packages

| Purpose | Package |
|---|---|
| HTTP | `dio` |
| State | `flutter_riverpod` |
| Local notifications | `flutter_local_notifications` |
| Push | `firebase_messaging` |
| Location | `geolocator` |
| Map | `google_maps_flutter` |
| Secure storage | `flutter_secure_storage` |

## First task (Sprint 1, week 5)

Before building screens, check on a real phone that a local notification fires at an exact time while the app is closed (exact alarm permission and battery optimization on Android). Everything in the reminder flow depends on it.
