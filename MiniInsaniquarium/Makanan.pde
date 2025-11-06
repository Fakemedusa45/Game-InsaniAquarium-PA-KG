class MakananIkan {
  PVector pos;       
  float kecepatan;   
  float ukuran;      
  color warna;       
  MakananIkan(float x, float y) {
    pos = new PVector(x, y);
    kecepatan = random(1.5, 2.5);  
    ukuran = 10;
    warna = color(255, 220, 100);
  }

  void jatuh(int levelMakananIkan) {
    pos.y += kecepatan * (1 + (levelMakananIkan - 1) * 0.3);
  }
  void tampil() {
    noStroke();
    fill(warna);
    ellipse(pos.x, pos.y, ukuran, ukuran);
  }
}
