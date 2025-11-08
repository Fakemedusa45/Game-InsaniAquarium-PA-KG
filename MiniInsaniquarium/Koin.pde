class Koin { // Memulai definisi class 'Koin'.

  PVector pos; // Variabel untuk menyimpan posisi (x, y) koin.
  PVector vel; // Variabel untuk menyimpan kecepatan (x, y) koin (hanya dipakai y).
  int nilai; // Variabel untuk menyimpan nilai koin (misal: 10).
  float ukuran = 30; // Variabel untuk ukuran (diameter) koin, default 30.
  float sudutPutar = 0; // Variabel untuk menyimpan sudut rotasi koin (untuk animasi).
Koin(float x, float y, int n) { // Konstruktor class Koin.
    pos = new PVector(x, y); // Mengatur posisi awal koin (di tempat ikan).
    vel = new PVector(0, 1.0); // Mengatur kecepatan (0 di x, 1.0 di y) - jatuh ke bawah.
nilai = n; // Mengatur nilai koin sesuai parameter 'n'.
  }

  void tampil() { // Fungsi untuk menggambar koin.
    pushMatrix(); // Menyimpan sistem koordinat.
    translate(pos.x, pos.y); // Pindahkan titik 0,0 ke posisi koin.
    rotate(sudutPutar); // Putar sistem koordinat sesuai 'sudutPutar'.
    stroke(255, 200, 0); // Atur warna garis pinggir (oranye).
    strokeWeight(3); // Atur tebal garis pinggir.
fill(255, 220, 0); // Atur warna isi (kuning).
    ellipse(0, 0, ukuran, ukuran); // Gambar lingkaran utama koin.
    fill(200, 150, 0); // Atur warna isi (kuning gelap) untuk simbol dolar.
    textAlign(CENTER, CENTER); // Atur perataan teks (tengah, tengah).
    textSize(18); // Atur ukuran teks.
text("$", 0, 0); // Gambar simbol "$" di tengah koin.
    popMatrix(); // Kembalikan sistem koordinat.
  }

  void jatuh() { // Fungsi untuk menggerakkan koin.
    pos.add(vel); // Tambahkan kecepatan 'vel' ke posisi 'pos' (koin bergerak ke bawah).
    sudutPutar += 0.1; // Tambah sudut putar (koin berputar perlahan).
  }
}
