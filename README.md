<div align="center">

# 📈 Jurnal Trading AB · untuk Scalper

**Platform pencatatan harian berbasis web, dirancang khusus untuk trader scalper.**

Multi-user · sinkronisasi cloud · ringan (± 50 KB) · Single Page Application tanpa build step.

![Live](https://img.shields.io/badge/Live-jurnal--scalper.vercel.app-000000?style=flat-square&logo=vercel&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=white)

**🔗 Live demo: [jurnal-scalper.vercel.app](https://jurnal-scalper.vercel.app)**

<img src="Screenshot%202026-09-02%20140712.png" alt="Jurnal Trading AB" width="720">

</div>

---

## ✨ Fitur

- 📓 **Jurnal harian scalping**, catat banyak posisi dalam satu hari dengan cepat.
- ☁️ **Multi-user + cloud sync**, autentikasi email/password, data tersinkron otomatis via Supabase.
- 📱 **Akses dari mana saja**, cukup browser, tanpa instal apa pun.
- 🪶 **Sangat ringan**, seluruh aplikasi ± 50 KB, dimuat instan.
- 🎨 **Fully branded**, antarmuka dengan identitas visual sendiri.

## 🛠️ Tech Stack

| Bagian | Teknologi |
|---|---|
| Frontend | HTML + JavaScript (SPA satu file `index.html`, tanpa framework) |
| Database | Supabase (PostgreSQL + Auth) |
| Hosting | Vercel (static) |

## 🚀 Menjalankan

```bash
# Cara tercepat: buka langsung index.html di browser
# atau jalankan server statis lokal
npx serve .
```

**Menyambungkan ke Supabase:** jalankan `supabase-schema.sql` di project Supabase-mu, lalu isi kredensial Supabase pada konfigurasi aplikasi.

> Kredensial disimpan di `.env.local` yang **tidak** ikut ke repo demi keamanan.

---

<div align="center">

**Ariqo Banyusila Abrar** · [@PiwPiyolett](https://github.com/PiwPiyolett)

</div>
