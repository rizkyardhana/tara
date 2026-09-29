# TARA Backend

Backend REST API lokal untuk aplikasi TARA. Backend memerlukan MySQL yang berjalan dan database `tara_db` yang sudah dibuat. Saat pertama dijalankan, backend membuat tabel-tabel yang diperlukan.

Buat database menggunakan akun MySQL lokal Anda:

```sql
CREATE DATABASE tara_db;
```

Konfigurasikan koneksi melalui environment variables. Default host dan port adalah `127.0.0.1:8889`, sesuai konfigurasi MySQL lokal/phpMyAdmin; default development user dan password adalah `root` dan `root`.

```bash
cd backend
pnpm install
DB_USER=root DB_PASSWORD=root pnpm run dev
```

Variabel koneksi lain yang didukung: `DB_HOST`, `DB_PORT`, dan `DB_NAME` (default `tara_db`). Ubah `DB_USER` dan `DB_PASSWORD` jika MySQL lokal Anda memakai kredensial berbeda.

Health check: `GET http://localhost:8000/api/health`
