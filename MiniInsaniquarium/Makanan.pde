class MakananIkan { // Memulai definisi class 'MakananIkan'.
  PVector pos; // Variabel untuk menyimpan posisi (x, y) makanan.
  float kecepatan; // Variabel untuk menyimpan kecepatan jatuh makanan.
  float ukuran; // Variabel untuk ukuran (diameter) makanan.
  color warna; // Variabel untuk menyimpan warna makanan.
MakananIkan(float x, float y) { // Konstruktor class MakananIkan.
    pos = new PVector(x, y); // Mengatur posisi awal (tempat mouse diklik).
    kecepatan = random(1.5, 2.5); // Mengatur kecepatan jatuh acak antara 1.5 dan 2.5.
    ukuran = 10; // Mengatur ukuran makanan ke 10.
warna = color(255, 220, 100); // Mengatur warna makanan (kuning muda).
  }

  void jatuh(int levelMakananIkan) { // Fungsi untuk menggerakkan makanan (jatuh).
    pos.y += kecepatan * (1 + (levelMakananIkan - 1) * 0.3); // Tambah posisi Y.
    // Kecepatan dikalikan dengan modifier berdasarkan 'levelMakananIkan'.
}
  void tampil() { // Fungsi untuk menggambar makanan.
    noStroke(); // Tidak menggunakan garis pinggir.
    fill(warna); // Atur warna isi sesuai variabel 'warna'.
    ellipse(pos.x, pos.y, ukuran, ukuran); // Gambar makanan sebagai lingkaran.
  }
}
