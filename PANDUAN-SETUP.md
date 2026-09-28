# 🚀 Panduan Menjadikan Jurnal Scalper sebagai Platform Online

Ikuti langkah ini berurutan. Total sekitar **15–25 menit**. Semua layanan yang dipakai punya **paket gratis** yang cukup untuk banyak user.

Ada 2 bagian:
- **Bagian A — Supabase** (akun/login + database) → biar tiap orang punya jurnal pribadi.
- **Bagian B — Vercel** (hosting) → biar bisa diakses lewat alamat web kapan saja.

> Selama kunci Supabase belum diisi, `index.html` tetap jalan **mode offline** (data di browser). Jadi kamu tidak akan merusak apa pun saat menyiapkan ini.

---

## BAGIAN A — Supabase (login + database)

### A1. Buat akun & project
1. Buka **https://supabase.com** → klik **Start your project** → daftar (bisa pakai akun GitHub atau email).
2. Setelah masuk, klik **New project**.
3. Isi:
   - **Name**: `jurnal-scalper` (bebas)
   - **Database Password**: buat password kuat, **simpan** (untuk keperluan lanjutan, bukan untuk aplikasi ini).
   - **Region**: pilih **Southeast Asia (Singapore)** biar cepat dari Indonesia.
4. Klik **Create new project**, tunggu ±1–2 menit sampai selesai disiapkan.

### A2. Buat tabel database
1. Di menu kiri, klik **SQL Editor** → **New query**.
2. Buka file **`supabase-schema.sql`** (ada di folder ini), **salin semua isinya**, tempel ke editor.
3. Klik **Run** (atau Ctrl+Enter). Harusnya muncul "Success. No rows returned".

### A3. Ambil URL & Kunci (publishable key)
1. Di menu kiri, klik ikon **⚙ Project Settings** → **API Keys** (atau **API** / **Data API**).
2. Catat 2 nilai ini:
   - **Project URL** — contoh: `https://abcdefgh.supabase.co`
   - **Publishable key** — diawali `sb_publishable_...`
     - *(Di project lama, kunci ini bernama **anon public** dan berbentuk `eyJ...`. Keduanya sama-sama bisa dipakai.)*

> ℹ️ **Aman.** Publishable key (`sb_publishable_...`) memang dirancang untuk dipasang di halaman web dan dilindungi oleh Row Level Security.
> ⚠️ **JANGAN** pakai **Secret key** (`sb_secret_...`) atau `service_role` di aplikasi ini — itu rahasia, khusus server.

### A4. Tempel ke aplikasi
1. Buka file **`index.html`** dengan editor teks (Notepad juga bisa).
2. Cari 2 baris ini (sekitar baris 413–414), di bawah tulisan `KONFIGURASI CLOUD`:
   ```js
   const SUPABASE_URL="__SUPABASE_URL__";
   const SUPABASE_ANON_KEY="__SUPABASE_ANON_KEY__";
   ```
3. Ganti isinya dengan nilai dari langkah A3:
   ```js
   const SUPABASE_URL="https://abcdefgh.supabase.co";
   const SUPABASE_ANON_KEY="sb_publishable_...(kunci publishable-mu)...";
   ```
   *(Nama variabelnya tetap `SUPABASE_ANON_KEY` — biarkan saja, isinya pakai publishable key.)*
4. **Simpan** file. Selesai — aplikasi kini otomatis jadi mode cloud.

### A5. Pengaturan verifikasi email (pilih salah satu)
Di Supabase → **Authentication** → **Sign In / Providers** → **Email**:
- **Untuk uji coba cepat:** matikan **"Confirm email"**. User bisa langsung login setelah daftar tanpa cek email.
- **Untuk platform publik (disarankan):** biarkan **"Confirm email" menyala**. Setiap user daftar → dapat email verifikasi → klik link → baru bisa login. (Lanjutkan ke B agar link verifikasi mengarah ke situs aslimu.)

### A6. Coba dulu di komputer (opsional tapi disarankan)
Double-click `index.html`. Sekarang harusnya muncul **layar login**. Coba **Daftar** dengan email & password, lalu isi 1–2 slot, refresh halaman — data harus tetap ada. Berarti cloud sudah jalan. 🎉

---

## BAGIAN B — Vercel (hosting online)

Tujuannya: aplikasi punya alamat seperti `https://jurnal-scalper.vercel.app` yang bisa dibuka siapa saja.

### Cara paling mudah: lewat CLI (butuh Node.js)
1. Install **Node.js** dari https://nodejs.org (versi LTS).
2. Buka **PowerShell** di folder ini (klik kanan folder → "Open in Terminal"), lalu jalankan:
   ```powershell
   npx vercel login
   npx vercel --prod
   ```
3. Ikuti pertanyaannya (tekan Enter untuk pilihan default). Setelah selesai, Vercel memberi **URL live** — itulah alamat platform-mu.

### Alternatif tanpa install: lewat GitHub
1. Daftar di **https://github.com**, buat **repository baru**, lalu **upload** semua file folder ini (tombol *Add file → Upload files*).
2. Daftar di **https://vercel.com** (login pakai GitHub) → **Add New → Project** → pilih repo tadi → **Deploy**.

### B1. Hubungkan Site URL (penting jika verifikasi email menyala)
Setelah dapat URL Vercel:
1. Supabase → **Authentication** → **URL Configuration**.
2. Isi **Site URL** dengan URL Vercel-mu (mis. `https://jurnal-scalper.vercel.app`).
3. Tambahkan URL yang sama di **Redirect URLs**. Simpan.

Ini memastikan link verifikasi email mengarah ke situsmu, bukan localhost.

---

## ✅ Selesai!
Bagikan URL Vercel ke siapa pun. Tiap orang **daftar akun sendiri**, dan jurnal mereka **privat & tersinkron** di semua perangkat.

## 🔄 Cara update aplikasi nanti
Setiap kali kamu mengubah `index.html`, jalankan lagi `npx vercel --prod` (cara CLI) atau upload ulang ke GitHub (cara GitHub) — Vercel akan otomatis memperbarui situs.

## 🧭 Catatan
- **Indikator kanan atas** (`⏳ menyimpan…` / `✓ tersimpan`) menunjukkan status simpan ke cloud.
- **Backup:** tombol ⬇ tetap ada untuk mengunduh salinan `.json` — berguna sebagai cadangan tambahan.
- **Screenshot** saat ini ikut tersimpan di data cloud. Kalau nanti pemakaian screenshot sangat banyak dan terasa lambat, beri tahu aku — kita bisa pindahkan penyimpanan foto ke **Supabase Storage** agar lebih ringan.
- **Batas gratis** (perkiraan): Supabase 500MB database + 50.000 user aktif/bulan; Vercel bandwidth 100GB/bulan. Lebih dari cukup untuk mulai.
```

Jika ada langkah yang membingungkan, kirim screenshot layarmu — aku bantu.
