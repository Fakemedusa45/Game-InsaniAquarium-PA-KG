// MODUL 4: Import Sound Library
import processing.sound.*;
PImage bg;
PGraphics bgLayer;
// Deklarasi SoundFile (opsional, bisa dihapus jika tidak pakai)
SoundFile suaraPlop;
SoundFile suaraKoin;
SoundFile suaraBeli;

// MODUL 5 (OOP): Menggunakan ArrayList untuk menampung banyak objek
ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>();
ArrayList<Makanan> daftarMakanan = new ArrayList<Makanan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();

// Variabel Game
int uang = 100;
int hargaIkan = 50;

// MODUL 5 (OOP): Objek Tombol
Tombol tombolBeliIkan;

// Modul 6 telah dihapus (tidak ada 'mode3D')

void setup() {
  // Ukuran layar 2D standar. P3D dihilangkan.
  size(800, 600);
   bg = loadImage("img/bg2.png");
  bgLayer = createGraphics(width, height);
  bgLayer.beginDraw();
  bgLayer.image(bg, 0, 0, width, height);
  bgLayer.endDraw();

  // Inisialisasi Tombol (Modul 5 & 4)
  tombolBeliIkan = new Tombol(20, 20, 150, 40, "Beli Ikan (50)");

  // Load suara (Modul 4)
  // Ini aman meski file tidak ada, karena ada try-catch
  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
  }
  catch (Exception e) {
    println("File suara tidak ditemukan. Tidak apa-apa, game tetap jalan.");
  }
}

void draw() {
  // MODUL 1 (Continuous Mode): 'draw()' mengulang terus menerus

  // === INI ADALAH GAME 2D UTAMA ===

  // Latar belakang akuarium
 image(bgLayer, 0, 0); 
 fill(100, 150, 255, 2); // warna biru muda dengan alpha 20
 noStroke();
 rect(0, 0, width, height); 

  // MODUL 2 (Kurva): Gambar rumput laut statis
  noStroke();
  fill(50, 200, 50);
  beginShape();
  curveVertex(100, height);
  curveVertex(100, height);
  curveVertex(120, height - 50);
  curveVertex(130, height - 150);
  curveVertex(110, height - 250);
  curveVertex(140, height);
  curveVertex(140, height);
  endShape();

  // MODUL 2 (Loop): Jalankan semua objek di ArrayList

  // 1. Makanan
  for (int i = daftarMakanan.size() - 1; i >= 0; i--) {
    Makanan m = daftarMakanan.get(i);
    m.tampil();
    m.jatuh();
    // Hapus jika sudah di dasar
    if (m.pos.y > height) {
      daftarMakanan.remove(i);
    }
  }

  // 2. Ikan
  for (Ikan ikan : daftarIkan) {
    ikan.update(); // Ganti berenang() -> update()
    ikan.tampil();
    ikan.findFood(daftarMakanan); // Ganti cariMakan() -> findFood()
  }

  // 3. Koin
  for (int i = daftarKoin.size() - 1; i >= 0; i--) {
    Koin k = daftarKoin.get(i);
    k.tampil();
    k.jatuh();
    // Hapus jika sudah di dasar
    if (k.pos.y > height) {
      daftarKoin.remove(i);
    }
  }

  // MODUL 4 (GUI): Tampilkan GUI (Tombol dan Teks)
  tombolBeliIkan.tampil();

  fill(255);
  textSize(24);
  textAlign(RIGHT);
  text("Uang: " + uang, width - 20, 45);
}

// MODUL 4 (GUI - Event Mouse)
void mousePressed() {
  // 1. Cek Tombol Beli Ikan
  if (tombolBeliIkan.isDiKlik(mouseX, mouseY)) {
    // MODUL 2 (Percabangan 'if')
    if (uang >= hargaIkan) {
      uang -= hargaIkan;
      daftarIkan.add(new Ikan(width / 2, height / 2)); // <-- INI DIA PERUBAHANNYA
      if (suaraBeli != null) suaraBeli.play();
    }
    return; // Selesai, jangan jatuhkan makanan
  }

  // 2. Cek Koin
  // Loop terbalik agar aman saat menghapus
  for (int i = daftarKoin.size() - 1; i >= 0; i--) {
    Koin k = daftarKoin.get(i);
    // Cek jarak klik ke koin
    if (dist(mouseX, mouseY, k.pos.x, k.pos.y) < k.ukuran/2) {
      uang += k.nilai;
      daftarKoin.remove(i); // Hapus koin
      if (suaraKoin != null) suaraKoin.play();
      return; // Selesai, jangan jatuhkan makanan
    }
  }

  // 3. Jika tidak klik apa-apa, jatuhkan makanan
  daftarMakanan.add(new Makanan(mouseX, mouseY));
  if (suaraPlop != null) suaraPlop.play();
}

// MODUL 4 (GUI - Event Keyboard)
// Fungsi keyPressed() dihapus karena tidak lagi diperlukan
// untuk mengganti mode 3D.
