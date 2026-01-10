
**Save this file in project root!**

***

## ✅ **OPTION 3: Code Context File (For AI)**

### **Create: CONTEXT.md**

```markdown
# Development Context

## Current Implementation Status

### ✅ Completed Features
1. User registration with email/password
2. Login with validation
3. Google Sign-In integration
4. JWT token authentication
5. Auto-login on app start
6. Age input screen
7. Life map visualization (1080 dots)

### 🔧 Recent Changes (Jan 10, 2026)
- Fixed CORS headers in backend PHP files
- Added network security config for Android
- Updated Google Sign-In to use `.standard()` constructor
- Fixed Gradle build configuration
- Implemented token validation in main.dart

### 🐛 Known Issues
- None currently

### 📝 Key Code Patterns

**API Call Pattern:**
```dart
final response = await ApiService.someMethod();
if (response['success'] == true) {
  // Success
} else {
  // Handle error: response['error']
}
