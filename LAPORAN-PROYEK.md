# Laporan Proyek: Jurnal Trading AB

**Penulis / Pemilik Proyek:** Ariqo Banyusila Abrar
**Nama Platform:** Jurnal Trading AB
**Alamat Live:** https://jurnal-scalper.vercel.app
**Kategori:** Web application (trading journal untuk scalper)
**Status:** Live (production), multi-user, aktif digunakan
**Tanggal Laporan:** 23 Juli 2026

---

## 1. Ringkasan Eksekutif

**Jurnal Trading AB** adalah platform pencatatan harian (daily journal) berbasis web yang dirancang khusus untuk **trader scalper**, yaitu trader yang membuka lebih dari satu posisi dalam satu hari. Platform ini dikembangkan dari nol dalam beberapa iterasi hingga menjadi aplikasi cloud multi-user yang bisa diakses dari perangkat mana saja, dengan autentikasi email/password, sinkronisasi data otomatis, dan tampilan yang di-branding sepenuhnya.

Dari sisi teknis, aplikasi ini adalah **Single Page Application** yang seluruh kodenya berada dalam satu file `index.html`, tanpa build step, tanpa framework, dengan dukungan cloud database (Supabase) dan hosting statis (Vercel). Total ukuran aplikasi ± 50 KB (belum termasuk gambar logo), sehingga sangat ringan dan cepat dimuat.

---

## 2. Latar Belakang & Kebutuhan

Scalping adalah gaya trading yang membuka banyak posisi dalam waktu singkat. Trader scalper membutuhkan alat yang:

- Bisa mencatat **banyak posisi per hari** (tidak hanya satu)
- Memberi **rekap otomatis** (Net P/L, win rate, hari terbaik/terburuk)
- **Mudah diakses** dari perangkat mana saja
- Mendukung **screenshot chart** untuk analisis retrospektif
- Menyimpan data **secara aman & tersinkron**

Alat berbentuk spreadsheet manual (Excel/Google Sheets) tidak cukup nyaman karena harus di-format sendiri dan tidak memiliki tampilan visual yang informatif. Aplikasi jurnal berbayar umumnya mahal dan tidak fleksibel. Karena itu Jurnal Trading AB dibangun.

---

## 3. Identitas Brand

| Elemen | Deskripsi |
|---|---|
| **Nama** | Jurnal Trading AB |
| **Logo** | Monogram "AB" bergaya candlestick dengan panah naik, merepresentasikan pertumbuhan & analisis pasar |
| **Warna Utama** | Hijau emerald `#18b98a` (profit, TP, pertumbuhan) & Biru brand `#2f83d6` (analisis, kepercayaan) |
| **Warna Sekunder** | Merah `#ff5c6c` (loss, SL) |
| **Gaya UI** | Modern, minimalis, dark-mode-first dengan tema terang opsional |

Logo disediakan dalam dua varian: `logo-full.png` (dengan teks, untuk layar login) dan `logo-mark.png` (ikon saja, untuk topbar & favicon).

---

## 4. Fitur Lengkap

### 4.1 Fitur Inti: Jurnal Harian
- **Grid 31 slot** per halaman (satu slot = satu hari trading)
- **Tanggal Entry** yang dapat dipilih tiap hari
- **Jumlah posisi dinamis**: user mengetikkan angka, form posisi otomatis muncul sesuai jumlahnya
- **Detail per posisi**:
  - Arah: **Long / Buy** atau **Short / Sell**
  - **Market** (XAUUSD, EURUSD, dll., dengan saran otomatis)
  - **Hasil**: TP (Take Profit) atau SL (Stop Loss); bisa dikosongkan
  - **Profit / Loss** dalam mata uang pilihan
  - **Screenshot chart** (opsional, otomatis dikompresi)
- **Catatan harian** (opsional): mis. konteks berita, sesi, kondisi mental

### 4.2 Multi-Halaman (Multi-Sheet)
- Setiap halaman punya **judul** dan **bulan** yang dapat diedit
- Bila grid 31 slot dalam satu bulan penuh, user tinggal klik **"+ Halaman Baru"**
- Halaman sebelumnya otomatis tersimpan; navigasi antar halaman via dropdown atau tombol panah

### 4.3 Statistik Otomatis
Ditampilkan di atas grid, dihitung real-time:
- **Net P/L Bulan Ini**
- **Total Trade** (jumlah posisi + rincian profit/loss)
- **Win Rate** (persentase)
- **Hari Terbaik & Terburuk**

### 4.4 Mata Uang Ganda
- **USD ($)**: format 2 desimal
- **IDR (Rp)**: format tanpa desimal + pemisah ribuan
- Bisa diganti kapan saja, seluruh angka reformat otomatis

### 4.5 Autentikasi & Akun Pribadi
- **Daftar / Masuk** dengan email + password
- **Lupa Sandi**: reset via email
- Data setiap user **privat** dan terisolasi (Row Level Security)
- **Panel Profil**: nickname, email, deskripsi, avatar (Gravatar + fallback inisial)

### 4.6 Sinkronisasi Cloud
- Simpan otomatis dengan **debounce 1 detik**
- Indikator status: `⏳ menyimpan…` / `✓ tersimpan` / `⚠ gagal`
- **Sinkron di semua perangkat** (HP, laptop, tablet)

### 4.7 Backup & Restore Manual
- **⬇ Backup**: unduh seluruh data sebagai file `.json`
- **⬆ Pulihkan**: impor kembali dari file backup

### 4.8 Aksesibilitas & Pengalaman Pengguna
- **Tema gelap & terang** (dapat diganti dengan satu klik)
- **Animasi pop-up halus** di seluruh aplikasi (kartu, modal, foto, entrance halaman)
- **`prefers-reduced-motion`** dihormati (animasi otomatis mati bagi pengguna sensitif gerak)
- **Responsif** untuk desktop, tablet, dan HP
- Semua tombol memiliki **label teks** dan **tooltip** yang jelas

---

## 5. Arsitektur Teknis

### 5.1 Stack
| Lapisan | Teknologi | Alasan |
|---|---|---|
| **Frontend** | HTML5 + CSS3 + Vanilla JavaScript | Zero-dependency, instan dimuat, mudah dirawat |
| **Autentikasi** | Supabase Auth (email/password) | Gratis, standar industri, siap pakai |
| **Database** | Supabase PostgreSQL (JSONB) | Free tier 500 MB, RLS otomatis |
| **Hosting** | Vercel (static hosting) | Deploy 1 perintah, HTTPS gratis, CDN global |
| **CDN Library** | jsDelivr (Supabase JS SDK) | Tidak perlu build; muat langsung dari CDN |
| **Avatar** | Gravatar (fallback inisial) | Universal, tidak butuh login pihak ketiga |

### 5.2 Skema Database (Supabase)
Satu tabel `public.journals`:
```sql
create table public.journals (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}',
  updated_at timestamptz not null default now()
);
```

Dengan **Row Level Security** yang memastikan setiap user hanya bisa membaca & menulis barisnya sendiri:
```sql
create policy on journals for select using (auth.uid() = user_id);
create policy on journals for insert with check (auth.uid() = user_id);
create policy on journals for update using (auth.uid() = user_id);
```

Seluruh data jurnal (sheets, trades, profil) disimpan sebagai **JSONB blob**, memberi fleksibilitas skema tanpa migrasi database.

### 5.3 Mode Ganda: Offline & Cloud
Aplikasi memiliki **dua mode** dalam satu file:
- **Mode Offline**: jika kunci Supabase belum diisi, data disimpan di `localStorage` browser
- **Mode Cloud**: jika kunci Supabase terisi, aplikasi menampilkan layar login dan menyimpan data ke server

Ini memberi jalur pengembangan/pengujian yang mulus tanpa merusak data user.

### 5.4 Alur Data Cloud
```
User klik simpan → save() → scheduleCloudSave() → debounce 1s
                                                    ↓
                                              upsert ke journals
                                                    ↓
                                              status: "✓ tersimpan"

User login  →  onAuthStateChange  →  cloudLoad()  →  render()
```

---

## 6. Struktur File Proyek

```
Jurnal Trading For Scalper/
├─ index.html            (aplikasi utama, ± 50 KB)
├─ logo-mark.png         (ikon AB, ± 29 KB, untuk topbar & favicon)
├─ logo-full.png         (logo penuh berteks, ± 114 KB, untuk login)
├─ supabase-schema.sql   (skema database)
├─ PANDUAN-SETUP.md      (panduan setup Supabase & Vercel)
└─ LAPORAN-PROYEK.md     (dokumen ini)
```

---

## 7. Riwayat Pengembangan (Iterasi)

| # | Iterasi | Isi Utama |
|---|---|---|
| 1 | **v1.0: MVP Offline** | Grid 31 slot, multi-posisi per hari, multi-halaman dengan judul & bulan; data di localStorage |
| 2 | **v1.1: Mata Uang & TP/SL** | Selector $/Rp; TP/SL per posisi; screenshot opsional dengan kompresi; lightbox foto |
| 3 | **v2.0: Cloud Platform** | Supabase Auth (login/daftar); tabel `journals` dengan RLS; sinkronisasi debounced; indikator status; deploy ke Vercel |
| 4 | **v2.1: Lupa Sandi** | Alur reset password via email (`resetPasswordForEmail`); UI 4 mode (login/daftar/lupa/reset) |
| 5 | **v3.0: Rebrand Jurnal Trading AB** | Nama diubah dari "Jurnal Scalper" ke "Jurnal Trading AB"; logo penuh & ikon dipasang; tema warna diselaraskan dengan logo (hijau + biru) |
| 6 | **v3.1: Animasi & UX** | Animasi pop-up bertahap untuk kartu; fade+pop modal/lightbox/login; hover & press feedback; `prefers-reduced-motion` |
| 7 | **v3.2: Label Tombol** | Semua tombol topbar diberi teks (Backup, Pulihkan, Tema, Keluar) |
| 8 | **v3.3: Panel Akun** | Avatar (Gravatar + inisial); nickname dapat diedit; deskripsi/bio; panel dropdown dengan tombol logout |

---

## 8. Deployment

**Konfigurasi live:**
- **Supabase project:** `gzmvktzrnlbhtxgmazat.supabase.co` (region: Southeast Asia)
- **Vercel team:** `jurnal-tradingpiw`
- **Vercel project:** `jurnal-scalper`
- **URL Production:** https://jurnal-scalper.vercel.app

**Prosedur update:**
```powershell
cd "C:\Users\advan\Documents\Jurnal Trading For Scalper"
npx vercel --prod
```

Perubahan langsung tayang dalam hitungan detik (CDN global Vercel).

---

## 9. Keamanan & Privasi

- **Row Level Security** aktif, user tidak dapat mengakses data user lain
- **Publishable key** (bukan secret key) yang dipasang di frontend, sesuai praktik keamanan Supabase
- **Password** di-hash dan dikelola oleh Supabase Auth (tidak pernah disimpan atau dilihat oleh aplikasi)
- **HTTPS** wajib (dipaksa oleh Vercel)
- **Backup manual** tetap tersedia, data tidak terikat pada satu penyedia

---

## 10. Batasan Saat Ini & Rencana Pengembangan

### 10.1 Batasan
- **Screenshot** disimpan sebagai base64 di dalam JSONB, praktis untuk skala kecil, tapi bisa membengkak bila user mengunggah banyak foto. Perlu migrasi ke **Supabase Storage** jika penggunaan intensif.
- Free tier Supabase: **500 MB database**, **50.000 monthly active users** (cukup untuk fase awal).
- Free tier Vercel: **100 GB bandwidth/bulan** (cukup untuk ribuan user aktif).

### 10.2 Ide Pengembangan Berikutnya
| Fitur | Manfaat |
|---|---|
| **Grafik equity curve** | Visualisasi progres P/L dari waktu ke waktu |
| **Lot size & TP/SL dalam pips** | Analisis lebih akurat, rasio risk-reward |
| **Rekap per market** | Win rate khusus per instrumen (mis. XAUUSD only) |
| **Login dengan Google** | Foto profil Gmail asli sebagai avatar |
| **Unggah foto profil manual** | Alternatif untuk pengguna non-Gravatar |
| **Ekspor PDF** | Laporan bulanan siap cetak |
| **Migrasi screenshot ke Supabase Storage** | Skalabilitas untuk pemakaian intensif |

---

## 11. Pencapaian Proyek

Dari ide sederhana ("aplikasi jurnal harian untuk scalper") menjadi **platform online multi-user yang lengkap** dalam beberapa iterasi:

✅ Zero-dependency (tanpa framework, tanpa build)
✅ Dual-mode (offline & cloud), pengembangan aman
✅ Autentikasi lengkap (login, daftar, lupa sandi)
✅ Sinkronisasi otomatis lintas perangkat
✅ Branding sepenuhnya (logo, warna, favicon, tab title)
✅ Animasi profesional
✅ Sudah live di alamat `https://jurnal-scalper.vercel.app`
✅ Free tier, belum ada biaya operasional

---

## 12. Penutup

Jurnal Trading AB adalah bukti bahwa aplikasi web produksi tidak selalu memerlukan framework berat, tim besar, atau anggaran mahal. Dengan pendekatan tepat guna: Vanilla JS, single HTML file, Supabase, dan Vercel, sebuah platform multi-user yang siap digunakan bisa dibangun dan disebarkan dalam waktu singkat, tetap ringan, cepat, dan mudah dirawat.

Aplikasi ini siap dipakai secara pribadi maupun dibagikan ke sesama scalper. Rencana ke depan tinggal soal fitur analitik lanjutan dan skalabilitas; pondasinya sudah kokoh.

---

**Dibuat oleh:** Ariqo Banyusila Abrar
**Tahun:** 2026
**Lisensi:** Privat (dapat diubah sesuai kebutuhan pemilik)
