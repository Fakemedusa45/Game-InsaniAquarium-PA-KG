// MODUL 5: Membuat class Tombol
class Tombol {

  float x, y, w, h;
  String label;

  Tombol(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void tampil() {
    // MODUL 1 (Bentuk Dasar)
    stroke(255);
    strokeWeight(2);
    // MODUL 2 (Percabangan 'if'): Ubah warna jika mouse di atasnya
    if (isDiKlik(mouseX, mouseY)) {
      fill(100, 200, 100); // Hijau saat hover
    } else {
      fill(50, 150, 50); // Hijau normal
    }
    rect(x, y, w, h, 10); // Tombol dengan sudut bulat
    
    // Teks
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, x + w/2, y + h/2);
  }

  // Method untuk cek jika mouse di atas tombol (untuk Modul 4)
  boolean isDiKlik(float mx, float my) {
    return (mx > x && mx < x + w && my > y && my < y + h);
  }
}
