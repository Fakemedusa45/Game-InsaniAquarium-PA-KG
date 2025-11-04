class MakananIkan {
  PVector pos;       // Posisi MakananIkan
  float kecepatan;   // Kecepatan jatuh
  float ukuran;      // Ukuran MakananIkan
  color warna;       // Warna MakananIkan

  MakananIkan(float x, float y) {
    pos = new PVector(x, y);
    kecepatan = random(1.5, 2.5);  // Kecepatan dasar
    ukuran = 10;
    warna = color(255, 220, 100);
  }

  // Fungsi jatuh dengan pengaruh level upgrade MakananIkan
  void jatuh(int levelMakananIkan) {
    // Makin tinggi level, makin cepat jatuh
    pos.y += kecepatan * (1 + (levelMakananIkan - 1) * 0.3);
  }

  void tampil() {
    noStroke();
    fill(warna);
    ellipse(pos.x, pos.y, ukuran, ukuran);
  }
}
