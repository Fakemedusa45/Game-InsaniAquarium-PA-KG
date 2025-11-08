class Ikan { // Memulai definisi class 'Ikan'.
  PVector pos; // Variabel untuk menyimpan posisi (x, y) ikan.
  PVector vel; // Variabel untuk menyimpan kecepatan/velocity (arah gerak) ikan.
  PVector targetPos; // Variabel untuk menyimpan posisi target yang dituju ikan.
  float hunger; // Variabel untuk melacak tingkat kelaparan ikan (0 = kenyang, 100 = mati).
  float ukuran; // Variabel untuk ukuran ikan (diameter).
  boolean isAlive; // Variabel status, true jika hidup, false jika mati.
  float alpha; // Variabel untuk transparansi (alpha), digunakan untuk animasi mati (fade out).
  int makanCount; // Variabel untuk menghitung berapa kali ikan sudah makan.
int makanThreshold = 5; // Batas jumlah makan untuk tumbuh besar (5 kali).
  float ukuranMax = 50; // Ukuran maksimum yang bisa dicapai ikan.
  boolean useBezier; // Variabel boolean acak, menentukan apakah ikan digambar dengan bezier atau elips.

  color warnaDasar; // Variabel untuk menyimpan warna dasar tubuh ikan.
  color warnaEkor; // Variabel untuk menyimpan warna ekor ikan.
Ikan(float x, float y) { // Konstruktor class Ikan (dijalankan saat 'new Ikan()' dipanggil).
    pos = new PVector(x, y); // Mengatur posisi awal ikan sesuai parameter x, y.
    vel = new PVector(0, 0); // Mengatur kecepatan awal (diam).
hunger = 50; // Mengatur kelaparan awal ke 50.
    ukuran = 20; // Mengatur ukuran awal ke 20.
    isAlive = true; // Mengatur status awal (hidup).
    alpha = 255; // Mengatur transparansi awal (terlihat penuh).
    makanCount = 0; // Mengatur hitungan makan awal ke 0.
    useBezier = random(1) < 0.5; // 50% kemungkinan true (bezier), 50% false (elips).
warnaDasar = color(random(80, 255), random(80, 255), random(80, 255)); // Mengatur warna tubuh acak (cerah).
    warnaEkor = color(random(80, 255), random(80, 255), random(80, 255)); // Mengatur warna ekor acak (cerah).

    setNewRandomTarget(); // Memanggil fungsi untuk menentukan target acak pertama.
}

  void setNewRandomTarget() { // Fungsi untuk mengatur target gerak acak baru.
    targetPos = new PVector(random(width), random(height)); // Tentukan targetPos acak di dalam layar.
}

  void findFood(ArrayList<MakananIkan> foods) { // Fungsi AI ikan untuk mencari makan.
    if (!isAlive) return; // Jika ikan mati, hentikan fungsi ini.
if (hunger < 50 || foods.isEmpty()) { // Jika ikan tidak lapar (hunger < 50) ATAU tidak ada makanan:
      if (pos.dist(targetPos) < 15) { // Jika ikan sudah dekat dengan target acaknya:
        setNewRandomTarget(); // Tentukan target acak baru.
}
      return; // Hentikan fungsi (ikan akan terus bergerak ke target acaknya).
    }

    // Blok ini hanya jalan jika ikan LAPAR (hunger >= 50) DAN ada makanan.
    MakananIkan closestFood = foods.get(0); // Asumsikan makanan terdekat adalah makanan pertama di daftar.
    float minDistance = pos.dist(closestFood.pos); // Hitung jarak ke makanan pertama.
for (MakananIkan f : foods) { // Loop melalui semua makanan di daftar 'foods'.
      float d = pos.dist(f.pos); // Hitung jarak dari ikan ke makanan 'f'.
if (d < minDistance) { // Jika jarak 'd' lebih kecil dari jarak minimum sebelumnya:
        minDistance = d; // Update jarak minimum.
        closestFood = f; // Simpan 'f' sebagai makanan terdekat.
}
    }

    targetPos = closestFood.pos.copy(); // Atur target gerak ikan ke posisi makanan terdekat.
if (minDistance < ukuran / 2) { // Jika ikan sudah sangat dekat (menyentuh) makanan:
      eat(foods, closestFood); // Panggil fungsi makan.
}
  }

  void eat(ArrayList<MakananIkan> foods, MakananIkan f) { // Fungsi saat ikan makan.
  if (!isAlive) return; // Jika ikan mati, hentikan.
  foods.remove(f); // Hapus makanan 'f' dari daftar makanan utama.
  hunger = 0; // Atur ulang kelaparan ikan ke 0 (kenyang).
  jatuhkanKoin(); // Panggil fungsi untuk menjatuhkan koin.
  setNewRandomTarget(); // Tentukan target gerak acak baru.
makanCount++; // Tambah hitungan makan.
  if (makanCount >= makanThreshold && ukuran < ukuranMax) { // Jika sudah makan 5 kali DAN belum ukuran maks:
    ukuran += 10; // Tambah ukuran ikan.
    makanCount = 0; // Atur ulang hitungan makan ke 0.
}
}

  void jatuhkanKoin() { // Fungsi untuk membuat koin baru.
    daftarKoin.add(new Koin(pos.x, pos.y, 10)); // Tambahkan objek Koin baru ke daftarKoin di posisi ikan (nilai 10).
}

  void update() { // Fungsi update (logika) ikan, dipanggil 60x per detik.
    if (!isAlive) { // Jika ikan mati:
      alpha -= 2; // Kurangi transparansi (alpha) secara perlahan (animasi fade out).
alpha = max(alpha, 0); // Pastikan alpha tidak kurang dari 0.
      return; // Hentikan fungsi update (ikan mati tidak bergerak/lapar).
    }

    // Kode di bawah ini hanya jalan jika ikan hidup.
    if (hunger >= 100) { // Jika kelaparan mencapai 100:
      isAlive = false; // Ubah status ikan menjadi mati.
return; // Hentikan fungsi update.
    }

    float speed = 1.5; // Tentukan kecepatan gerak ikan.
    PVector arah = PVector.sub(targetPos, pos); // Hitung vektor arah dari posisi ikan ke targetPos.
if (arah.mag() < speed) { // Jika jarak ke target lebih kecil dari kecepatan (sudah sampai):
      pos = targetPos.copy(); // Langsung pindah ke posisi target (mencegah getaran).
      vel.set(0, 0); // Hentikan kecepatan (diam).
} else { // Jika belum sampai:
      arah.normalize(); // Ubah vektor 'arah' menjadi panjangnya 1 (vektor satuan).
      arah.mult(speed); // Kalikan vektor arah dengan kecepatan (menjadi vektor kecepatan).
      vel = arah.copy(); // Simpan vektor kecepatan di 'vel'.
      pos.add(vel); // Tambahkan vektor kecepatan ke posisi ikan (ikan bergerak).
}

    hunger += 0.05; // Tambah kelaparan secara perlahan setiap frame.
    hunger = constrain(hunger, 0, 100); // Pastikan nilai hunger selalu di antara 0 dan 100.
}

  void tampil() { // Fungsi untuk menggambar ikan.
    if (alpha <= 0) return; // Jika ikan sudah mati dan fade out, jangan gambar.
    pushMatrix(); // Menyimpan sistem koordinat saat ini.
    translate(pos.x, pos.y); // Pindahkan titik 0,0 ke posisi ikan.
float angle = atan2(vel.y, vel.x); // Hitung sudut rotasi berdasarkan arah kecepatan (vel).
    rotate(angle); // Putar sistem koordinat sesuai sudut.
    noStroke(); // Tidak menggunakan garis pinggir.

    color tubuh = lerpColor(warnaDasar, color(255, 0, 0), hunger / 100.0); // Hitung warna tubuh.
    // (Campur 'warnaDasar' dengan merah, berdasarkan tingkat kelaparan).
    fill(tubuh, alpha); // Atur warna isi (dengan transparansi 'alpha').
if (useBezier) { // Jika 'useBezier' true:
      beginShape(); // Mulai menggambar bentuk kustom.
      vertex(-ukuran/2, 0); // Titik awal (belakang).
      bezierVertex(-ukuran/4, -ukuran/3, ukuran/4, -ukuran/3, ukuran/2, 0); // Kurva bezier untuk sisi atas.
bezierVertex(ukuran/4, ukuran/3, -ukuran/4, ukuran/3, -ukuran/2, 0); // Kurva bezier untuk sisi bawah.
      endShape(CLOSE); // Selesaikan bentuk (tubuh ikan).
    } else { // Jika 'useBezier' false:
      ellipse(0, 0, ukuran, ukuran * 0.7); // Gambar tubuh ikan sebagai elips.
}

    fill(lerpColor(warnaEkor, color(255, 200, 200), hunger / 120.0), alpha); // Atur warna ekor (juga berubah saat lapar).
if (useBezier) { // Jika 'useBezier' true:
      beginShape(); // Mulai bentuk ekor (bezier).
      vertex(-ukuran/2, 0); // Titik awal (di belakang tubuh).
      bezierVertex(-ukuran, -ukuran/4, -ukuran * 1.2, 0, -ukuran, ukuran/4); // Kurva untuk ekor.
      endShape(); // Selesaikan bentuk.
} else { // Jika 'useBezier' false:
      triangle(-ukuran/2, 0, -ukuran, -ukuran/3, -ukuran, ukuran/3); // Gambar ekor sebagai segitiga.
}

    if (isAlive) { // Jika ikan hidup:
      fill(0, alpha); // Warna hitam (transparan).
      ellipse(ukuran/4, -ukuran/8, 3, 3); // Gambar mata (titik hitam).
} else { // Jika ikan mati:
      stroke(0, alpha); // Warna garis hitam (transparan).
      strokeWeight(1); // Tebal garis 1.
line(ukuran/4 - 1.5, -ukuran/8 - 1.5, ukuran/4 + 1.5, -ukuran/8 + 1.5); // Gambar mata 'X' (garis 1).
line(ukuran/4 + 1.5, -ukuran/8 - 1.5, ukuran/4 - 1.5, -ukuran/8 + 1.5); // Gambar mata 'X' (garis 2).
      noStroke(); // Matikan garis lagi.
    }

    popMatrix(); // Kembalikan sistem koordinat seperti semula.
  }
}
