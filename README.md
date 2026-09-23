# The Mall (themallbd_new)

A Flutter e-commerce storefront for The Mall Bangladesh — browse products and shop from your phone.

## Features

- Home storefront with product browsing
- Modular views with shared widgets
- Theming, controllers and services for catalog, cart and checkout flows
- Utilities and constraints for consistent UI

## Tech Stack

- Flutter (Dart)
- GetX-style controllers with modular views
- REST API backend

## Getting Started

```bash
flutter pub get
flutter run
```

Build a release APK:

```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── app/          # App-level setup (routes, bindings)
├── views/        # Feature screens (incl. home)
├── widgets/      # Reusable widgets
├── controllers/  # Business logic
├── models/       # Data models
├── services/     # API and platform services
├── theme/        # App theme
└── main.dart     # App entry point
```

## Notes

- App label: "The Mall" (Android), title "The Mall"
- No secrets or keystores are committed to this repository.
