# 🌲 Minimalist Neovim 0.12 (Next)

Konfigurasi Neovim yang dirancang dengan prinsip **"Clean, Fast, and Manual"**. Fokus utama pada pengembangan **Flutter** dan **Lua** menggunakan Neovim 0.12 untuk mendapatkan performa maksimal tanpa *bloatware*.

---

## 🎯 Filosofi Konfigurasi
* **Minimalis Modern**: Mengandalkan ekosistem `mini.nvim` yang ringan untuk menjaga fungsionalitas tetap lengkap tanpa membebani startup time.
* **Vanilla Feel**: Minim penggunaan plugin pihak ketiga yang berat; lebih mengoptimalkan fitur bawaan Neovim terbaru.
* **Aesthetic & Flat**: Menggunakan palet warna **Rose Pine** dengan UI yang datar (flat), tanpa tanda `~` (End of Buffer) yang mengganggu.
* **On-Demand Power**: Fitur seperti *autocompletion* hanya muncul saat dipicu secara manual (`<C-Space>`) agar tidak mengganggu fokus saat mengetik.

---

## ✨ Fitur Utama
* 🚀 **Full Flutter Integration**: Dukungan penuh untuk `flutter-tools.nvim`, mencakup Hot Reload, Debugging (DAP), dan LSP.
* 🧼 **Floating File Explorer**: Navigasi file yang elegan menggunakan `oil.nvim` dalam mode floating window.
* 💾 **Auto-Format on Save**: Merapikan kode secara otomatis setiap kali menekan `<leader>w` menggunakan `vim.lsp.buf.format`.
* 📂 **Smart Folding**: Pelipatan kode cerdas berbasis LSP menggunakan `nvim-ufo` dengan indikator jumlah baris yang redup (Comment style).
* 🔋 **Reliable Sessions**: Manajemen proyek menggunakan `mini.sessions` yang stabil, termasuk fitur auto-save saat keluar.

---

## 🛠️ Daftar Plugin Terpasang

| Kategori | Plugin | Kegunaan |
| :--- | :--- | :--- |
| **Colorscheme** | `rose-pine/neovim` | Tema utama dengan nuansa gelap dan tenang. |
| **File Explorer** | `oil.nvim` | Navigasi file berbasis buffer di floating window. |
| **LSP & Dev** | `nvim-lspconfig`, `mason.nvim`, `flutter-tools.nvim` | Server bahasa dan manajemen perangkat lunak pengembangan. |
| **Navigation** | `mini.pick`, `hop.nvim` | Pencarian file cepat dan navigasi kursor instan. |
| **Editing** | `mini.pairs`, `mini.surround`, `mini.indentscope` | Auto-close brackets, manipulasi pengapit, dan garis indentasi. |
| **Utility** | `mini.sessions`, `mini.icons` | Manajemen session proyek dan ikon flat yang ringan. |
| **UI & Visual** | `fidget.nvim`, `nvim-ufo` | Notifikasi progress LSP dan pelipatan kode modern. |
| **Debugging** | `nvim-dap`, `nvim-dap-ui` | Alat debugging profesional untuk Flutter. |

---

## ⌨️ Keymaps Pilihan

### 📁 Navigasi & Project
- `<leader>e` : Toggle Floating Oil.nvim
- `<leader>ff` : Mencari file (`mini.pick`)
- `<leader>ss` : Simpan Session (Input Nama)
- `<leader>sl` : List & Load Session
- `<leader>sd` : Hapus Session (Force)

### 💻 Development & LSP
- `<leader>w` : Save file + Auto Format
- `C-Space` : Trigger Autocompletion (Manual)
- `K` : Hover documentation
- `gd` : Go to Definition
- `<leader>ca` : Code Action
- `za` : Toggle Fold (Buka/Tutup lipatan)

---

## 🚀 Instalasi

1. Pastikan Anda menggunakan **Neovim 0.12+**.
2. Clone repository ini ke folder konfigurasi Anda:
   ```bash
   git clone [https://github.com/username/your-repo.git](https://github.com/username/your-repo.git) $HOME/AppData/Local/nvim
3. Buka Neovim dan jalankan perintah untuk menginstal plugin:
   ```bash
   :PackInstall
4. Restart Neovim dan Anda siap untuk bertempur!

Dibuat dengan ❤️ untuk produktivitas maksimal.

### Saran Terakhir:
Jangan lupa untuk mengganti link `git clone` dengan link asli repository GitHub Anda nanti. Jika Anda memiliki tangkapan layar (screenshot) tampilan Neovim Anda, masukkan ke dalam folder proyek (misalnya di folder `assets/`) dan update bagian gambar di paling bawah agar README-nya semakin terlihat profesional.

Apakah ada bagian lain dari konfigurasi kita yang ingin Anda tambahkan ke dalam README ini?
