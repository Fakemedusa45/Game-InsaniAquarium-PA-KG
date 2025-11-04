
class Koin {

  PVector pos;
  PVector vel;
  int nilai;
  float ukuran = 30;
  float sudutPutar = 0; // Untuk Modul 3

  Koin(float x, float y, int n) {
    pos = new PVector(x, y);
    vel = new PVector(0, 1.0); // Jatuh ke bawah (lebih lambat dari MakananIkan)
    nilai = n;
  }

  void tampil() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(sudutPutar);
    
    // MODUL 1 (Bentuk Dasar)
    stroke(255, 200, 0);
    strokeWeight(3);
    fill(255, 220, 0); // Kuning
    ellipse(0, 0, ukuran, ukuran);
    
    // Teks
    fill(200, 150, 0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("$", 0, 0);
    
    popMatrix();
  }

  void jatuh() {
    pos.add(vel);
    sudutPutar += 0.1; // MODUL 3: update sudut rotasi
  }
}
