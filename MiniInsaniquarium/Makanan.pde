// MODUL 5: Membuat class Makanan
class Makanan {

  PVector pos;
  PVector vel;

  Makanan(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 1.5); // Jatuh ke bawah
  }

  void tampil() {
    // MODUL 1 (Bentuk Dasar)
    noStroke();
    fill(100, 60, 20); // Coklat
    ellipse(pos.x, pos.y, 8, 8);
  }

  void jatuh() {
    pos.add(vel);
  }
}
