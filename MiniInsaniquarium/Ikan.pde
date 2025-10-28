class Ikan {
  
  // --- Properti Baru (berdasarkan kode Anda) ---
  PVector pos;       // Posisi (x, y)
  PVector vel;       // Kecepatan (vx, vy) - untuk rotasi
  PVector targetPos; // Posisi target (x, y)
  float hunger;      // Tingkat kelaparan (0=Kenyang, 100=Lapar)
  float ukuran;
  boolean isAlive;   // Status hidup ikan
  float alpha;       // Opacity untuk efek menghilang (0-255)
  int makanCount;    // Hitung berapa kali ikan makan
  int makanThreshold = 5; // Setelah 5 kali makan, ukuran bertambah
  float ukuranMax = 50;   // Ukuran maksimal ikan

  // Constructor (dipanggil saat 'new Ikan()')
  Ikan(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    hunger = 50; // Mulai dengan lapar (tidak langsung mati)
    ukuran = 20;
    isAlive = true;  // Ikan hidup saat dibuat
    alpha = 255;     // Opacity penuh
    makanCount = 0;  // Mulai dari 0
    setNewRandomTarget(); // Langsung cari target acak
  }
  
  // Method baru: Menetapkan target acak baru untuk dituju
  void setNewRandomTarget() {
    targetPos = new PVector(random(width), random(height));
  }

  // --- LOGIKA BARU (dari kode Anda) ---
  // Logika AI: cari makanan terdekat
  void findFood(ArrayList<Makanan> foods) {
    // Jika ikan sudah mati, jangan lakukan apa-apa
    if (!isAlive) return;
    
    // Jika ikan kenyang (hunger < 50) ATAU tidak ada makanan
    if (hunger < 50 || foods.isEmpty()) {
      // Pergi ke target acak
      if (pos.dist(targetPos) < 15) { // Jika sudah dekat dgn target acak
        setNewRandomTarget(); // Cari target acak baru
      }
      return; // Keluar (jangan cari makanan)
    }
    
    // Jika lapar DAN ada makanan, cari yang terdekat
    Makanan closestFood = foods.get(0);
    float minDistance = pos.dist(closestFood.pos);
    
    for (Makanan f : foods) {
      float d = pos.dist(f.pos);
      if (d < minDistance) {
        minDistance = d;
        closestFood = f;
      }
    }
    
    // Set target ke makanan terdekat
    targetPos = closestFood.pos.copy();
    
    // Cek jika kita "memakan" makanan itu
    if (minDistance < ukuran / 2) { // Pakai 'ukuran' kita
      eat(foods, closestFood);
    }
  }

  // Method baru: Logika saat makan
  void eat(ArrayList<Makanan> foods, Makanan f) {
    // Jika ikan sudah mati, jangan makan
    if (!isAlive) return;
    
    foods.remove(f); // Hapus makanan dari daftar
    hunger = 0; // Ikan jadi kenyang
    jatuhkanKoin(); // Panggil method kita yg lama untuk drop koin
    setNewRandomTarget(); // Setelah makan, cari target acak baru
    
    // Tambah hitungan makan
    makanCount++;
    
    // Jika sudah makan cukup kali, tumbuhkan ukuran
    if (makanCount >= makanThreshold) {
      ukuran += 5; // Tumbuh 5 unit
      ukuran = min(ukuran, ukuranMax); // Batasi maksimal
      makanCount = 0; // Reset hitungan
    }
  }
  
  // Method lama (sudah ada, tapi disederhanakan)
  void jatuhkanKoin() {
    daftarKoin.add(new Koin(pos.x, pos.y, 10)); // Hanya drop koin
  }

  // --- LOGIKA GERAK BARU (menggantikan 'berenang()') ---
  void update() {
    // Jika ikan sudah mati, hanya kurangi opacity untuk efek menghilang
    if (!isAlive) {
      alpha -= 2; // Kurangi opacity perlahan (sesuaikan kecepatan)
      alpha = max(alpha, 0); // Pastikan tidak negatif
      return; // Jangan gerak lagi
    }
    
    // Cek jika hunger mencapai 100, ikan mati
    if (hunger >= 100) {
      isAlive = false;
      return;
    }
    
    // Ikan bergerak menuju target (targetPos)
    float speed = 1.5; // Kecepatan ikan
    
    // Hitung vektor arah ke target
    PVector arah = PVector.sub(targetPos, pos);
    
    // Cek jika kita sudah sangat dekat
    if (arah.mag() < speed) {
      pos = targetPos.copy(); // Langsung lompat ke target
      vel.set(0,0);
    } else {
      // Bergerak ke arah target
      arah.normalize(); // Dapatkan arah (panjang=1)
      arah.mult(speed); // Kalikan dgn kecepatan
      
      vel = arah.copy(); // Simpan kecepatan untuk rotasi
      pos.add(vel);      // Gerakkan ikan
    }
    
    // Ikan perlahan-lahan jadi lapar lagi
    hunger += 0.05;
    hunger = constrain(hunger, 0, 100); // Batasi 0-100
  }

  // --- LOGIKA TAMPIL BARU (menggunakan 'rotate()') ---
  void tampil() {
    // Jika alpha <= 0, jangan tampilkan
    if (alpha <= 0) return;
    
    // MODUL 3 (Transformasi): rotate, translate
    pushMatrix();
    translate(pos.x, pos.y);
    
    // Arahkan ikan ke target (agar berputar)
    // Gunakan 'vel' (kecepatan) untuk menentukan rotasi
    float angle = atan2(vel.y, vel.x);
    rotate(angle);
    
    // MODUL 1 (Bentuk Dasar)
    noStroke();
    
    // Tubuh (berwarna berdasarkan kelaparan, dari kode Anda) dengan alpha
    fill(255, 255 - hunger*2.5, 255 - hunger*2.5, alpha); 
    ellipse(0, 0, ukuran, ukuran * 0.7); // Tubuh
    
    // Ekor dengan alpha
    fill(255, 150, 0, alpha); // Warna ekor tetap
    triangle(-ukuran/2, 0, -ukuran, -ukuran/3, -ukuran, ukuran/3);
    
    // Mata: Jika hidup, gambar ellipse; jika mati, gambar X
    if (isAlive) {
      fill(0, alpha);
      ellipse(ukuran/4, -ukuran/8, 3, 3);
    } else {
      // Gambar X untuk mata mati
      stroke(0, alpha); // Warna hitam dengan alpha
      strokeWeight(1);
      line(ukuran/4 - 1.5, -ukuran/8 - 1.5, ukuran/4 + 1.5, -ukuran/8 + 1.5);
      line(ukuran/4 + 1.5, -ukuran/8 - 1.5, ukuran/4 - 1.5, -ukuran/8 + 1.5);
      noStroke(); // Reset stroke agar tidak mempengaruhi gambar lain
    }
    
    popMatrix();
  }
}
