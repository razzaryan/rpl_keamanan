# Laporan Praktikum Pemrograman Mobile
## Pertemuan 6: Prinsip RPL & Keamanan Kode

**Mata Kuliah:** Pemrograman Mobile (ST407)  
**Program Studi:** S1 Informatika, Universitas Amikom Yogyakarta  
**Praktikan:** Razaan Azzaryan Bilhaq Widagdo (NIM: 25.11.6309)  
**Branch Git:** `fitur-rpl-keamanan`  
**Repository GitHub:** https://github.com/razzaryan/rpl_keamanan  
**Lokasi Proyek:** `C:\Users\RAZZ\Documents\PM\06`  
**File Dokumen Resmi PDF:** `Laporan_Praktikum_Pertemuan6_25.11.6309_Razaan Azzaryan Bilhaq Widagdo.pdf`

---

### 1. Ringkasan Implementasi Praktik & Latihan
1. **flutter_dotenv & Keamanan Kredensial:**
   - Parameter `BASE_URL` dan `API_KEY` dipindahkan seluruhnya ke file `.env`.
   - File `.env` telah dimasukkan ke dalam `.gitignore` dan template `.env.example` telah dibuat.
2. **AppConfig (`lib/config/app_config.dart`):**
   - Mengambil variabel dari `.env` secara terpusat dengan timeout 10 detik.
3. **Repository Pattern & SOLID:**
   - Abstraksi `UserRepository` & implementasi `UserRepositoryImpl`.
   - Latihan 1: Abstraksi `PostRepository` & implementasi `PostRepositoryImpl`.
   - Mengikuti prinsip SRP (Single Responsibility) dan DIP (Dependency Inversion).
4. **Dependency Injection (Latihan 2):**
   - `DependencyInjector` berbasis `InheritedWidget` di `lib/config/dependency_injector.dart`.
5. **Validators & Sanitasi XSS (Latihan 3):**
   - `Validators.validatePhone()` (10–13 digit).
   - `Validators.validateUrl()` (skema `http://` / `https://`).
   - `Validators.validatePassword()` (min 8 karakter, huruf kapital, angka, simbol).
   - `Validators.sanitize()` mengamankan tag bahaya HTML.
6. **Logging Aman (Latihan 4):**
   - `AppLogger` di `lib/utils/logger.dart` hanya aktif saat `kDebugMode` dan menyensor informasi sensitif.
7. **Unit Testing (Latihan 5):**
   - 6 test suite dijalankan via `flutter test` dan seluruhnya **PASSED** 100%.
   - Analisis kode via `flutter analyze` menghasilkan **No issues found**.

---

### 2. Catatan Peer Review
| Kriteria Keamanan | Status | Keterangan |
| :--- | :---: | :--- |
| Hardcoded Credential | ✅ PASS | Tidak ada kredensial mentah di source code |
| Git Exposure | ✅ PASS | `.env` terlindungi oleh `.gitignore` |
| Validasi Input | ✅ PASS | Form nomor HP, URL, password, email tervalidasi |
| Sanitasi XSS | ✅ PASS | Tag `<script>` dan atribut berbahaya disanitasi |
| Safe Logging | ✅ PASS | Log aman dan non-aktif di production |
| Error Handling | ✅ PASS | Exception timeout & socket ditangani secara elegan |
