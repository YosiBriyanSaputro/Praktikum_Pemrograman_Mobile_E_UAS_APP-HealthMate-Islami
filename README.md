# 📱 HealthMate Islami  
Aplikasi mobile berbasis Flutter yang membantu pengguna memantau kesehatan sehari-hari seperti makanan, minum air, olahraga, dan catatan harian.  
Aplikasi juga menyediakan ayat Al-Qur’an harian serta motivasi harian dari API publik.

Seluruh data **realtime**, **tanpa hardcoded**, menggunakan **RESTful API**, dan catatan pengguna disimpan aman di **Firebase Firestore**.

---

## ✨ Fitur Utama

### 🔐 Autentikasi (Firebase Authentication)
- Register akun baru  
- Login  
- Update nama  
- Update password  
- Logout  

### 🕌 Home Screen
- Ayat Al-Qur’an harian (Quran API)  
- Motivasi harian (ZenQuotes API)  
- Menu cepat menuju fitur utama  

### 🍽️ Food Tracker
- CRUD makanan (Firestore)
- Hitung total kalori harian
- Rekomendasi makanan (TheMealDB API)
- **Search & Filter makanan (WAJIB UAS — sudah terpenuhi)**

### 💧 Water Tracker
- Catat konsumsi air
- Progress bar hidrasi harian
- CRUD minum (Firestore)

### 🏋️ Exercise Tracker
- Rekomendasi latihan fisik (API-Ninjas)
- Catat durasi & tipe latihan (Firestore)
- CRUD latihan

### 📝 Notes Tracker
- Catatan harian kesehatan
- CRUD catatan real-time

### 📊 Report (Laporan)
- Laporan Hari Ini
- Laporan 7 Hari
- Laporan 14 Hari  
Meliputi: total kalori, total gelas air, total latihan.

### ⚙️ Settings
- Update nama
- Update password
- Tema Light/Dark Mode
- Logout

---

# 🌐 Daftar Endpoint API yang Digunakan

## **1. TheMealDB API (Food Recommendation)**
| Fungsi | Endpoint |
|-------|----------|
| Search makanan | `https://www.themealdb.com/api/json/v1/1/search.php?s={query}` |
| Filter kategori | `https://www.themealdb.com/api/json/v1/1/filter.php?c={category}` |

---

## **2. API-Ninjas Exercise (Rekomendasi Latihan)**
| Fungsi | Endpoint |
|--------|----------|
| Daftar latihan berdasarkan kategori | `https://api.api-ninjas.com/v1/exercises?type={category}` |

> API-Ninjas membutuhkan API KEY.

---

## **3. ZenQuotes API (Motivasi Harian)**
| Fungsi | Endpoint |
|--------|----------|
| Motivasi random | `https://zenquotes.io/api/random` |

---

## **4. Al-Qur’an API (Ayat Harian)**
Contoh endpoint umum:
| Fungsi | Endpoint |
|--------|----------|
| Ayat acak / harian | `https://api.quran.gading.dev/surah` atau endpoint lain sesuai implementasi |

---

# 🛠️ Arsitektur Folder
```
/lib
 ├── screens/         # Semua halaman aplikasi (UI)
 ├── services/        # API & Firestore services
 ├── models/          # Model data JSON & Firestore
 ├── logic/           # Perhitungan & proses data
 ├── theme/           # Light/Dark mode
 └── main.dart
```

---

# 🚀 Cara Instalasi & Menjalankan Proyek

## **1. Clone Repository**
```bash
git clone https://github.com/USERNAME/REPO-NAME.git
cd REPO-NAME
```

## **2. Install Dependencies**
```bash
flutter pub get
```

## **3. Konfigurasi Firebase**
Masukkan file berikut ke dalam proyek:
- `google-services.json` → android/app  
- `firebase_options.dart` → lib/

Jalankan:
```bash
flutterfire configure
```

## **4. Pastikan Anda Menambahkan API KEY**
Untuk API-Ninjas:
```dart
const apiKey = "YOUR_API_KEY";
```

## **5. Jalankan Aplikasi**
```bash
flutter run
```

---

# 📸 Screenshots (Optional)
Tambahkan screenshot halaman:
- Home  
- Food Tracker  
- Search makanan  
- Water  
- Exercise  
- Notes  
- Report  
- Settings  

---

# 🧪 Pengujian
Aplikasi sudah diuji:
- API Fetch (Quran, Quote, Food, Exercise)
- CRUD Firestore
- Loading / Error Handling
- Search & Filter
- Laporan data
- Navigasi
- Autentikasi

Semua fitur berjalan stabil tanpa crash.

---

# 🎯 Status Proyek
✔️ Siap UAS  
✔️ Memenuhi semua kriteria penilaian  
✔️ Menggunakan API realtime  
✔️ Menggunakan Firestore untuk database  
✔️ UI/UX Material 3  
✔️ Search + Filter sudah ada  

---

# 👨‍💻 Developer
**Yosi Briyan Saputro**  
Mobile Programming – UAS Project  
