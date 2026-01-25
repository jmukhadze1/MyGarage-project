# MyGarage (iOS)

## Description
MyGarage is an iOS application that allows users to manage their vehicles and related services.
The app provides functionality to add, edit, and view vehicles, as well as add service records.

---

## Technologies
- Swift
- UIKit
- SwiftUI
- Firebase Authentication
- Firebase Firestore
- Auto Layout / TinyConstraints
- Minimum iOS version: 17

---

## Architecture
The project follows the MVVM architecture pattern.

- **View** – UIKit view controllers and SwiftUI views  
- **ViewModel** – business logic and state management  
- **Model** – data models such as Vehicle and Service

---

## UIKit and SwiftUI
UIKit is used for:
- Application navigation
- TabBar and NavigationController
- Vehicle add/edit screens

SwiftUI is used for:
- Service add screen
- List-based and simple UI components

SwiftUI views are embedded into UIKit using `UIHostingController`.

---

## Features
- User authentication (Firebase Auth)
- Vehicle management (add, edit, view)
- Service management (add services using SwiftUI)
- Data persistence with Firestore
- UIKit and SwiftUI integration

---

## Setup
1. Open `MyGarage.xcodeproj`
2. Add `GoogleService-Info.plist`
3. Run the app on an iOS 17+ simulator
