import processing.sound.*; // Import library suara bawaan Processing
SoundFile suaraPlop; // Suara saat makanan dijatuhkan
SoundFile suaraKoin; // Suara saat koin diambil
SoundFile suaraBeli; // Suara saat membeli ikan
SoundFile bgm;       // Musik latar permainan
ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>(); 
ArrayList<Makanan> daftarMakanan = new ArrayList<Makanan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();
int uang = 100;         // Uang awal pemain
int hargaIkan = 50;     // Harga per ikan
Tombol tombolBeliIkan;  // Tombol untuk membeli ikan

// ===== Background =====
PImage bg; // Gambar latar belakang

// ===== MENU SYSTEM =====
MenuSystem menuScreen; // Objek sistem menu

// Daftar state permainan
enum GameState {
  MENU,          // Layar menu utama
  GAMEPLAY,      // Layar permainan utama
  HOW_TO_PLAY,   // Layar "cara bermain"
  SETTINGS,      // Layar pengaturan
  CONFIRM_EXIT   // Pop-up konfirmasi keluar
}

// State awal permainan
GameState gameState = GameState.MENU;
GameState stateBeforeConfirm; // Menyimpan state sebelum pop-up muncul

// ==================== SETUP ====================
void setup() {
  size(800, 600, P3D); // Ukuran jendela dan aktifkan mode 3D

  // Load background image (dengan error handling)
  try {
    bg = loadImage("img/bg2.png");
  } catch (Exception e) {
    println("Background image not found - akan pakai warna solid");
    bg = null; // Jika gagal, tidak gunakan gambar
  }

  // Inisialisasi sistem menu
  menuScreen = new MenuSystem(width, height);

  // Buat tombol beli ikan di pojok kiri atas
  tombolBeliIkan = new Tombol(20, 20, 150, 40, "Beli Ikan (50)");

  // Load semua efek suara dan musik latar
  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3");
    bgm.loop(); // Musik berjalan terus
  } catch (Exception e) {
    println("File audio tidak ditemukan. Permainan lanjut tanpa suara.");
  }

  surface.setResizable(true);     // Izinkan jendela diubah ukurannya
  surface.setLocation(200, 100);  // Posisi awal jendela di layar
}

void draw() {
  background(10, 20, 40); // Warna latar default jika tidak ada gambar

  // Kelola tampilan berdasarkan state permainan
  switch(gameState) {
  case MENU:
    drawMenu(); // Tampilkan menu utama
    break;
  case GAMEPLAY:
    drawGameplay(); // Tampilkan gameplay
    break;
  case HOW_TO_PLAY:
    menuScreen.display();
    menuScreen.drawHowToPlay(); // Tampilkan panduan
    break;
  case SETTINGS:
    menuScreen.display();
    menuScreen.drawSettings(); // Tampilkan pengaturan
    break;
  case CONFIRM_EXIT:
    // Tampilkan layar sebelumnya di belakang pop-up
    if (stateBeforeConfirm == GameState.GAMEPLAY) {
      drawGameplay();
    } else if (stateBeforeConfirm == GameState.HOW_TO_PLAY) {
      menuScreen.display();
      menuScreen.drawHowToPlay();
    } else if (stateBeforeConfirm == GameState.SETTINGS) {
      menuScreen.display();
      menuScreen.drawSettings();
    }
    // Tampilkan pop-up konfirmasi di atasnya
    drawConfirmPopup();
    break;
  }
}

void drawMenu() {
  menuScreen.display(); // Tampilkan animasi/menu utama
}

void drawGameplay() {
  lights(); // Aktifkan pencahayaan 3D

  // Gambar background jika tersedia
  if (bg != null) {
    image(bg, 0, 0, width, height);
  } else {
    background(20, 40, 80);
  }

  // ===== Render makanan =====
  for (int i = daftarMakanan.size() - 1; i >= 0; i--) {
    if (i < daftarMakanan.size()) {
      Makanan m = daftarMakanan.get(i);
      m.tampil();  // Gambar makanan
      m.jatuh();   // Gerakkan makanan ke bawah
      if (m.pos.y > height) daftarMakanan.remove(i); // Hapus jika keluar layar
    }
  }

  // ===== Render ikan =====
  for (int i = daftarIkan.size() - 1; i >= 0; i--) {
    if (i < daftarIkan.size()) {
      Ikan ikan = daftarIkan.get(i);
      ikan.update();          // Update posisi & kondisi
      ikan.tampil();          // Gambar ikan
      ikan.findFood(daftarMakanan); // Cari makanan
      if (!ikan.isAlive && ikan.alpha <= 0) daftarIkan.remove(i); // Hapus jika mati
    }
  }

  // ===== Render koin =====
  for (int i = daftarKoin.size() - 1; i >= 0; i--) {
    if (i < daftarKoin.size()) {
      Koin k = daftarKoin.get(i);
      k.tampil();  // Gambar koin
      k.jatuh();   // Gerakkan ke bawah
      if (k.pos.y > height) daftarKoin.remove(i); // Hapus jika keluar layar
    }
  }

  // ===== RENDER UI 2D =====
  hint(DISABLE_DEPTH_TEST); // Nonaktifkan efek kedalaman 3D sementara
  perspective(); // Reset proyeksi

  tombolBeliIkan.tampil(); // Gambar tombol beli ikan

  // Gambar teks uang di kanan atas
  fill(255, 255, 0);
  textSize(32);
  textAlign(LEFT);
  text("$" + uang, 710, 50);

  // Tombol MENU di kanan bawah
  fill(255, 100, 100);
  rect(width - 110, height - 60, 90, 40, 5); // Posisi & ukuran
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("MENU", width - 65, height - 40);

  hint(ENABLE_DEPTH_TEST); // Aktifkan kembali efek 3D
}

// ==================== POP-UP KONFIRMASI ====================
void drawConfirmPopup() {
  hint(DISABLE_DEPTH_TEST);
  noLights();
  perspective();

  // Overlay gelap transparan
  fill(0, 0, 0, 150);
  rect(0, 0, width, height);

  // Kotak modal di tengah
  float modalWidth = width * 0.6;
  float modalHeight = height * 0.35;
  float modalX = (width - modalWidth) / 2;
  float modalY = (height - modalHeight) / 2;

  fill(10, 31, 63);
  stroke(255, 107, 107);
  strokeWeight(3);
  rect(modalX, modalY, modalWidth, modalHeight, 20);

  // Teks konfirmasi
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Kembali ke Menu?", width/2, modalY + 40);

  textSize(16);
  if (stateBeforeConfirm == GameState.GAMEPLAY)
    text("Semua kemajuan di permainan ini akan hilang.", width/2, modalY + 85);
  else
    text("Anda yakin ingin kembali ke menu utama?", width/2, modalY + 85);

  // Tombol "YA, KEMBALI"
  float yaX = modalX + 50;
  float yaY = modalY + modalHeight - 70;
  float btnW = (modalWidth / 2) - 70;
  float btnH = 40;
  fill(255, 107, 107);
  rect(yaX, yaY, btnW, btnH, 10);
  fill(255);
  text("YA, KEMBALI", yaX + btnW/2, yaY + btnH/2);

  // Tombol "TIDAK, BATAL"
  float tidakX = modalX + modalWidth - btnW - 50;
  float tidakY = yaY;
  fill(100, 200, 100);
  rect(tidakX, tidakY, btnW, btnH, 10);
  fill(0);
  text("TIDAK, BATAL", tidakX + btnW/2, tidakY + btnH/2);

  hint(ENABLE_DEPTH_TEST);
}

// ==================== INTERAKSI MOUSE ====================
void mousePressed() {
  // --- 1. Saat di menu utama ---
  if (gameState == GameState.MENU) {
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY);

    // Tergantung tombol yang diklik
    if (buttonClicked == 1) { // Mulai game
      gameState = GameState.GAMEPLAY;
      uang = 500;
      daftarIkan.clear();
      daftarMakanan.clear();
      daftarKoin.clear();
    } else if (buttonClicked == 2) { // Cara bermain
      gameState = GameState.HOW_TO_PLAY;
    } else if (buttonClicked == 3) { // Pengaturan
      gameState = GameState.SETTINGS;
    } else if (buttonClicked == 4) { // Keluar
      exit();
    }
    return;
  }

  // --- 2. Tombol Kembali di "Cara Bermain" ---
  if (gameState == GameState.HOW_TO_PLAY) {
    if (menuScreen.checkBackButton(mouseX, mouseY)) {
      stateBeforeConfirm = GameState.HOW_TO_PLAY;
      gameState = GameState.CONFIRM_EXIT;
    }
    return;
  }

  // --- 3. Tombol Kembali di "Pengaturan" ---
  if (gameState == GameState.SETTINGS) {
    if (menuScreen.checkBackButton(mouseX, mouseY)) {
      stateBeforeConfirm = GameState.SETTINGS;
      gameState = GameState.CONFIRM_EXIT;
    }
    return;
  }


  if (gameState == GameState.CONFIRM_EXIT) {
    float modalWidth = width * 0.6;
    float modalHeight = height * 0.35;
    float modalX = (width - modalWidth) / 2;
    float modalY = (height - modalHeight) / 2;
    float btnW = (modalWidth / 2) - 70;
    float btnH = 40;

    // Tombol "YA, KEMBALI"
    float yaX = modalX + 50;
    float yaY = modalY + modalHeight - 70;
    if (mouseX > yaX && mouseX < yaX + btnW && mouseY > yaY && mouseY < yaY + btnH) {
      gameState = GameState.MENU; // Kembali ke menu utama
      return;
    }

    // Tombol "TIDAK, BATAL"
    float tidakX = modalX + modalWidth - btnW - 50;
    float tidakY = yaY;
    if (mouseX > tidakX && mouseX < tidakX + btnW && mouseY > tidakY && mouseY < tidakY + btnH) {
      gameState = stateBeforeConfirm; // Kembali ke layar sebelumnya
      return;
    }
    return;
  }

  if (gameState == GameState.GAMEPLAY) {

    // Tombol MENU kanan bawah
    if (mouseX > width - 110 && mouseX < width - 20 && mouseY > height - 60 && mouseY < height - 20) {
      stateBeforeConfirm = GameState.GAMEPLAY;
      gameState = GameState.CONFIRM_EXIT;
      return;
    }

    // Tombol beli ikan
    if (tombolBeliIkan.isDiKlik(mouseX, mouseY)) {
      if (uang >= hargaIkan) {
        uang -= hargaIkan; // Kurangi uang
        daftarIkan.add(new Ikan(width / 2, height / 2)); // Tambahkan ikan baru
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli
      }
      return;
    }

    // Ambil koin dengan klik
    for (int i = daftarKoin.size() - 1; i >= 0; i--) {
      if (i < daftarKoin.size()) {
        Koin k = daftarKoin.get(i);
        if (dist(mouseX, mouseY, k.pos.x, k.pos.y) < k.ukuran/2) {
          uang += k.nilai; // Tambah uang
          daftarKoin.remove(i); // Hapus koin
          if (suaraKoin != null) suaraKoin.play();
          return;
        }
      }
    }

    // Jika klik kosong → jatuhkan makanan
    daftarMakanan.add(new Makanan(mouseX, mouseY));
    if (suaraPlop != null) suaraPlop.play();
  }
}
