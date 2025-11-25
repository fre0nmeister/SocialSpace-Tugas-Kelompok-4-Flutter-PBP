# SocialSpace - Aplikasi Media Sosial

Aplikasi media sosial berbasis Flutter yang memungkinkan pengguna untuk berbagi postingan dengan gambar dan teks, mirip dengan Instagram/Facebook.

## 📱 Fitur

- **Autentikasi Pengguna**
  - Registrasi dengan username, email, dan password
  - Login dengan email dan password
  - Autentikasi aman menggunakan Firebase Auth

- **Feed Sosial**
  - Membuat postingan dengan caption teks dan gambar
  - Upload gambar dari kamera atau galeri
  - Update feed secara real-time menggunakan Firestore streams
  - Melihat postingan dari semua pengguna

- **Profil Pengguna**
  - Menampilkan avatar pengguna dengan inisial
  - Menampilkan username pada postingan
  - Fungsi logout

## 🛠️ Tech Stack

- **Flutter/Dart** - Framework mobile cross-platform
- **Firebase Authentication** - Autentikasi pengguna
- **Cloud Firestore** - Database real-time untuk postingan dan data pengguna
- **Image Picker** - Integrasi kamera dan galeri
- **Base64 Encoding** - Penyimpanan gambar di Firestore

## 🎨 Desain

- Warna Utama: Navy Blue (#1E2746)
- UI berbasis card modern
- Desain terinspirasi dari Instagram/Facebook
- Layout responsif

## 📦 Dukungan Platform

Aplikasi ini mendukung berbagai platform:
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## 🚀 Memulai

Proyek ini adalah titik awal untuk aplikasi Flutter.

Beberapa sumber untuk membantu Anda jika ini adalah proyek Flutter pertama Anda:

- [Lab: Menulis aplikasi Flutter pertama Anda](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Contoh Flutter yang berguna](https://docs.flutter.dev/cookbook)

Untuk bantuan memulai pengembangan Flutter, lihat
[dokumentasi online](https://docs.flutter.dev/), yang menawarkan tutorial,
contoh, panduan pengembangan mobile, dan referensi API lengkap.

## 📋 Prasyarat

- Flutter SDK (versi terbaru)
- Dart SDK
- Akun Firebase
- Android Studio / VS Code
- Android SDK / Xcode (untuk pengembangan mobile)

## ⚙️ Instalasi

1. Clone repository ini
```bash
git clone <repository-url>
cd SocialSpace-Tugas-Kelompok-4-Flutter-PBP
```

2. Install dependensi
```bash
flutter pub get
```

3. Konfigurasi Firebase
   - Tambahkan `google-services.json` (Android) ke `android/app/`
   - Tambahkan `GoogleService-Info.plist` (iOS) ke `ios/Runner/`
   - Update `firebase_options.dart` dengan konfigurasi Firebase Anda

4. Jalankan aplikasi
```bash
flutter run
```

## 📁 Struktur Proyek

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Konfigurasi Firebase
├── screens/
│   ├── login_page.dart      # Halaman login
│   ├── register_page.dart   # Halaman registrasi
│   └── home_page.dart       # Feed/timeline utama
└── services/
    └── auth_service.dart    # Service autentikasi
```

## 👥 Tim

**Tugas Kelompok 4 - Flutter PBP**

- Rico Aldy Kusuma (24060123120041)
- Sophie Venecia May Manalu (24060123120043)
- Steven Jonathan Sihombing (24060123120044)
- Tsabita Syahida Khafid (24060123130071)
- Rasendriya Daffa Al Ghifary (24060123130077)
- Rangga Mulki Aji Muzaki (24060123140153)
- Rajwaa Muflihul Aufaa (24060123140189)
- Tegar Caesara Yanuansa (24060123140190)
- Ranggadya Aditama Ramadhani (24060123140196)

## 📄 Lisensi

Proyek ini dibuat untuk tujuan edukasi.
