# REM Hub

![Flutter](https://img.shields.io/badge/Built%20with-Flutter-blue?logo=flutter&logoColor=white)
![Platforms](https://img.shields.io/badge/Platforms-Windows%20%7C%20Linux%20%7C%20Android-green)
![Maintenance](https://img.shields.io/badge/Maintained-no-red)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

**REM Hub** is a cross-platform app built with Flutter for managing audio-video systems.

It is based on the interaction with a central **Backend Server** which manage connections with final devices.

It currently supports connections to **audio matrix** (MDM-D8 via Dateq protocol) and **PTZ camera** (RGB Link via ViscaIp protocol).

---

## 🔧 Key Features

- Highly responsive on every screen
- Multi-User at the same time support
- Multi-Connection and easy management of previous/actual connections
- Fluent UI, gestures control and detailed error handling
- Available for **Windows**, **Linux**, and **Android**

---

## 📦 Downloads

You can find and download the full release version for Windows, Linux and Android in this repository's page on GitHub "release" section, or following this [link](https://github.com/alleboprime/REMAudioApp/releases/tag/v1.0.0).


---

> ⚠️ **Warning**  
> Those releases contain only the **Frontend** of the application.  
> If you want to test the **entire architecture** it is important to download and execute the **Backend Server** which could be found in this [repository](https://github.com/FiXeer17/REMAudioWeb.git).

## 🚀 Installation & Usage (Pre-built)

### Android
Download and install the `.apk` on your device.
>You may have to analyze the app with Play Protect

### Windows
Once you've downloaded the `.zip` package, extract it and execute the `REM_Hub.exe` application.

### Linux
Once you've downloaded the `.zip` package, extract it and execute the binary application.


> ⚠️ **Warning**  
> It is important to leave all the extracted content inside the folder, or the application might not work properly.  
> Only experienced users should modify the folder structure or path.  


>There's No need to install Flutter to use pre-built versions.

---


## 🛠️ Development Setup (Flutter)

### Requirements
- Flutter SDK (latest version)
- Android Studio
- Android development components  
  (See [Flutter install guide](https://docs.flutter.dev/get-started/install))

### Installation
1. Follow the [official guide](https://docs.flutter.dev/get-started/install).
2. Choose your OS and Android development setup (recommended).
3. Verify the setup:
   ```bash
   flutter doctor -v
   ```

### Usage
- In Android Studio: press the **run** arrow (top right).
- Via CLI:
  ```bash
  flutter run [--release/debug] [device_id]
  ```
  Or simply:
  ```bash
  flutter run
  ```
- Select the target device from the **bottom-right** of Android Studio.

> When adding dependencies, save the `pubspec.yaml` file and Flutter will automatically update the project.

### Recommendations
- For easier SDK version management, use **[Flutter Version Management (FVM)](https://fvm.app/)**.
- Prefer USB or wireless debugging if your device supports it.

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---
