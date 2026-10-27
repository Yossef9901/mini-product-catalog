# Mini Product Catalog — Flutter Homework Section 4

This project implements the active `go_router` flow and keeps a commented Navigator reference in `lib/main.dart`.

## Requirements
- Flutter SDK installed and available in PATH
- VS Code with Flutter and Dart extensions
- Chrome installed for Flutter web

## Run
Open this folder in VS Code, then in the terminal:

```bash
flutter pub get
flutter run -d chrome
```

If Chrome is not listed as a device, run `flutter devices`. You can also run on an Android emulator/device with `flutter run`.

## Included
- `lib/main.dart`: Login → Products → Details with `go_router`
- `lib/product_widgets.dart`: reusable ListView/GridView product widgets
- Responsive layout: list below 600 px; 2-column grid at 600 px and above
- Favorites counter, add-to-cart result returned from Details to Products
- Lifecycle debug prints in all three StatefulWidget pages
- Required short answers and commented Navigator sample at top of `main.dart`

## Screenshot requirement
Run the app and interact with each page. Open VS Code's **Debug Console** (or terminal output where Flutter logs appear) and capture a screenshot showing lifecycle prints. Resize the Chrome window to show `ProductsPage: didChangeDependencies -> width: ..., height: ...`.

## Important
The actual Flutter SDK is required to resolve dependencies and run the app. Run `flutter pub get` before launching.
