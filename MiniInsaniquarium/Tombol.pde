class Tombol { // Memulai definisi class 'Tombol' (versi simpel).
  float x, y, w, h; // Variabel posisi dan ukuran.
  String label; // Teks tombol.
Tombol(float x, float y, float w, float h, String label) { // Konstruktor.
    this.x = x; // Simpan x.
    this.y = y; // Simpan y.
this.w = w; // Simpan w.
    this.h = h; // Simpan h.
    this.label = label; // Simpan label.
  }
  void tampil() { // Fungsi untuk menggambar tombol.
    stroke(255); // Warna border (putih).
    strokeWeight(2); // Tebal border.
if (isDiKlik(mouseX, mouseY)) { // Cek apakah mouse di atas tombol.
      fill(100, 200, 100); // Warna hijau cerah (jika hover).
} else { // Jika tidak di-hover:
      fill(50, 150, 50); // Warna hijau gelap.
    }
    rect(x, y, w, h, 10); // Gambar kotak tombol.
fill(255); // Warna teks (putih).
    textAlign(CENTER, CENTER); // Perataan tengah.
    textSize(16); // Ukuran teks.
    text(label, x + w/2, y + h/2); // Gambar teks tombol.
}
  boolean isDiKlik(float mx, float my) { // Fungsi cek klik/hover.
    return (mx > x && mx < x + w && my > y && my < y + h); // Cek area kotak.
}
}
