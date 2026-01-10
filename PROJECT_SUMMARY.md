# Life in Months - Project Summary

## App Overview
Flutter app that visualizes life in 1080 months (90 years), with authentication and milestone tracking.

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** PHP (app.devsarun.io)
- **Database:** MySQL
- **Auth:** Email/Password + Google Sign-In
- **HTTP:** Dio package
- **Storage:** SharedPreferences

## Key Files

### Services
- `lib/services/api_service.dart` - All API calls (Dio)
- `lib/services/auth_service.dart` - Google Sign-In
- `lib/services/storage_service.dart` - Token storage

### Screens
- `lib/auth/login_screen.dart` - Login UI
- `lib/auth/register_screen.dart` - Registration UI
- `lib/onboarding/age_input_screen.dart` - Birth date input
- `lib/life_map/life_map_screen.dart` - Main 1080 dots screen

### Backend API
- `/api/auth.php` - register, login, google_login
- `/api/users.php` - getProfile, updateProfile
- `/api/milestones.php` - CRUD operations
- `/api/settings.php` - App settings

## API Base URL
```dart
static const String baseUrl = 'https://app.devsarun.io';
