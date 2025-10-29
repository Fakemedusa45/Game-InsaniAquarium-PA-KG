// ==================================
// MINI INSANIQUARIUM - MAIN FILE
// Versi dengan Pop-up Konfirmasi Global
// Tombol MENU dipindah ke kanan bawah
// ==================================

import processing.sound.*;

// MODUL 4: Sound
SoundFile suaraPlop;
SoundFile suaraKoin;
SoundFile suaraBeli;
SoundFile bgm;

// MODUL 5: Game Objects
// PASTIKAN ANDA MEMILIKI FILE: Ikan.pde, Makanan.pde, Koin.pde, Tombol.pde
ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>();
ArrayList<Makanan> daftarMakanan = new ArrayList<Makanan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();

// Variabel Game
int uang = 100;
int hargaIkan = 50;
Tombol tombolBeliIkan;

// Background
PImage bg;

// ===== MENU SYSTEM =====
MenuSystem menuScreen;
enum GameState {
  MENU,
  GAMEPLAY,
  HOW_TO_PLAY,
  SETTINGS,
  CONFIRM_EXIT // State untuk pop-up
}
GameState gameState = GameState.MENU;
GameState stateBeforeConfirm; // <-- Menyimpan state sebelum pop-up

void setup() {
  size(800, 600, P3D);

  // Load background
  try {
    bg = loadImage("img/bg2.png");
  }
  catch (Exception e) {
    println("Background image not found - akan pakai warna solid");
    bg = null;
  }

  // Initialize Menu
  menuScreen = new MenuSystem(width, height);

  // Initialize Game Button
  tombolBeliIkan = new Tombol(20, 20, 150, 40, "Beli Ikan (50)");

  // Load sounds
  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3");
    bgm.loop();
  }
  catch (Exception e) {
    println("File audio tidak ditemukan. Permainan lanjut tanpa suara.");
  }
  surface.setResizable(true);    
  surface.setLocation(200, 100);
}

void draw() {
  background(10, 20, 40);

  // STATE MANAGEMENT
  switch(gameState) {
  case MENU:
    drawMenu();
    break;
  case GAMEPLAY:
    drawGameplay();
    break;
  case HOW_TO_PLAY:
    menuScreen.display();
    menuScreen.drawHowToPlay();
    break;
  case SETTINGS:
    menuScreen.display();
    menuScreen.drawSettings();
    break;
    
  case CONFIRM_EXIT:
    // Gambar layar sebelumnya di belakang
    if (stateBeforeConfirm == GameState.GAMEPLAY) {
      drawGameplay();
    } else if (stateBeforeConfirm == GameState.HOW_TO_PLAY) {
      menuScreen.display();
      menuScreen.drawHowToPlay();
    } else if (stateBeforeConfirm == GameState.SETTINGS) {
      menuScreen.display();
      menuScreen.drawSettings();
    }
    // Gambar pop-up di atasnya
    drawConfirmPopup(); 
    break;
  }
}

// ===== MENU RENDERING =====
void drawMenu() {
  menuScreen.display();
}

// ===== GAMEPLAY RENDERING =====
void drawGameplay() {
  lights();

  if (bg != null) {
    image(bg, 0, 0, width, height);
  } else {
    background(20, 40, 80);
  }

  // Update dan render Makanan, Ikan, Koin...
  // (Semua loop for... Anda tetap sama)
  for (int i = daftarMakanan.size() - 1; i >= 0; i--) {
    if (i < daftarMakanan.size()) {
      Makanan m = daftarMakanan.get(i);
      m.tampil();
      m.jatuh();
      if (m.pos.y > height) {
        daftarMakanan.remove(i);
      }
    }
  }
  for (int i = daftarIkan.size() - 1; i >= 0; i--) {
    if (i < daftarIkan.size()) {
      Ikan ikan = daftarIkan.get(i);
      ikan.update();
      ikan.tampil();
      ikan.findFood(daftarMakanan);
      if (!ikan.isAlive && ikan.alpha <= 0) {
        daftarIkan.remove(i);
      }
    }
  }
  for (int i = daftarKoin.size() - 1; i >= 0; i--) {
    if (i < daftarKoin.size()) {
      Koin k = daftarKoin.get(i);
      k.tampil();
      k.jatuh();
      if (k.pos.y > height) {
        daftarKoin.remove(i);
      }
    }
  }

  // RENDER 2D UI (di atas 3D)
  hint(DISABLE_DEPTH_TEST);
  perspective();

  tombolBeliIkan.tampil(); // Tombol "Beli Ikan" di kiri atas

  fill(255, 255, 0);
  textSize(32);
  textAlign(LEFT);
  text("$" + uang, 710, 50); // Uang di kanan atas

  // --- PERUBAHAN DI SINI ---
  // Tombol "MENU" dipindah ke pojok kanan Bawah
  fill(255, 100, 100);
  rect(width - 110, height - 60, 90, 40, 5); // x: kanan, y: bawah
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("MENU", width - 65, height - 40); // x: kanan, y: bawah
  // --- AKHIR PERUBAHAN ---

  hint(ENABLE_DEPTH_TEST);
}

// ===== FUNGSI POP-UP KONFIRMASI =====
void drawConfirmPopup() {
  // 1. Gambar overlay gelap
  hint(DISABLE_DEPTH_TEST);
  noLights(); 
  perspective(); 

  fill(0, 0, 0, 150);
  rect(0, 0, width, height);

  // 2. Gambar kotak modal
  float modalWidth = width * 0.6;
  float modalHeight = height * 0.35;
  float modalX = (width - modalWidth) / 2;
  float modalY = (height - modalHeight) / 2;

  fill(10, 31, 63);
  stroke(255, 107, 107); 
  strokeWeight(3);
  rect(modalX, modalY, modalWidth, modalHeight, 20);

  // 3. Gambar Teks (Dinamis)
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Kembali ke Menu?", width/2, modalY + 40);

  textSize(16);
  if (stateBeforeConfirm == GameState.GAMEPLAY) {
    text("Semua kemajuan di permainan ini akan hilang.", width/2, modalY + 85);
  } else {
    text("Anda yakin ingin kembali ke menu utama?", width/2, modalY + 85);
  }

  // 4. Tombol "YA" (Keluar)
  float yaX = modalX + 50;
  float yaY = modalY + modalHeight - 70;
  float btnW = (modalWidth / 2) - 70;
  float btnH = 40;

  fill(255, 107, 107);
  rect(yaX, yaY, btnW, btnH, 10);
  fill(255);
  text("YA, KEMBALI", yaX + btnW/2, yaY + btnH/2);

  // 5. Tombol "TIDAK" (Batal)
  float tidakX = modalX + modalWidth - btnW - 50;
  float tidakY = yaY;

  fill(100, 200, 100);
  rect(tidakX, tidakY, btnW, btnH, 10);
  fill(0);
  text("TIDAK, BATAL", tidakX + btnW/2, tidakY + btnH/2);

  hint(ENABLE_DEPTH_TEST); 
}


// ===== MOUSE INTERACTION (Logika Pop-up Global) =====
void mousePressed() {
  
  // 1. Logika saat di MENU UTAMA
  if (gameState == GameState.MENU) {
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY);
    
    if (buttonClicked == 1) { // MULAI
      gameState = GameState.GAMEPLAY;
      uang = 100;
      daftarIkan.clear();
      daftarMakanan.clear();
      daftarKoin.clear();
    } else if (buttonClicked == 2) { // CARA BERMAIN
      gameState = GameState.HOW_TO_PLAY;
    } else if (buttonClicked == 3) { // PENGATURAN
      gameState = GameState.SETTINGS;
    } else if (buttonClicked == 4) { // KELUAR
      exit();
    }
    return;
  }
  
  // 2. Logika "KEMBALI" di HOW_TO_PLAY
  if (gameState == GameState.HOW_TO_PLAY) {
    if (menuScreen.checkBackButton(mouseX, mouseY)) {
      stateBeforeConfirm = GameState.HOW_TO_PLAY; 
      gameState = GameState.CONFIRM_EXIT;
    }
    return;
  }
  
  // 3. Logika "KEMBALI" di SETTINGS
  if (gameState == GameState.SETTINGS) {
    if (menuScreen.checkBackButton(mouseX, mouseY)) {
      stateBeforeConfirm = GameState.SETTINGS;
      gameState = GameState.CONFIRM_EXIT;
    }
    return;
  }

  // 4. Logika saat di layar KONFIRMASI
  if (gameState == GameState.CONFIRM_EXIT) {
    float modalWidth = width * 0.6;
    float modalHeight = height * 0.35;
    float modalX = (width - modalWidth) / 2;
    float modalY = (height - modalHeight) / 2;
    float btnW = (modalWidth / 2) - 70;
    float btnH = 40;
    
    float yaX = modalX + 50;
    float yaY = modalY + modalHeight - 70;
    if (mouseX > yaX && mouseX < yaX + btnW && mouseY > yaY && mouseY < yaY + btnH) {
      gameState = GameState.MENU; // Selalu kembali ke MENU
      return;
    }
    
    float tidakX = modalX + modalWidth - btnW - 50;
    float tidakY = yaY;
    if (mouseX > tidakX && mouseX < tidakX + btnW && mouseY > tidakY && mouseY < tidakY + btnH) {
      gameState = stateBeforeConfirm; // KEMBALI KE LAYAR SEBELUMNYA
      return;
    }
    return; 
  }
  
  // 5. Logika INTERAKSI GAMEPLAY
  if (gameState == GameState.GAMEPLAY) {
    
    // --- PERUBAHAN DI SINI ---
    // Tombol "MENU" di pojok kanan Bawah
    if (mouseX > width - 110 && mouseX < width - 20 && mouseY > height - 60 && mouseY < height - 20) {
      stateBeforeConfirm = GameState.GAMEPLAY; 
      gameState = GameState.CONFIRM_EXIT;
      return; 
    }
    // --- AKHIR PERUBAHAN ---
    
    // Tombol Beli Ikan
    if (tombolBeliIkan.isDiKlik(mouseX, mouseY)) {
      if (uang >= hargaIkan) {
        uang -= hargaIkan;
        daftarIkan.add(new Ikan(width / 2, height / 2));
        if (suaraBeli != null) suaraBeli.play();
      }
      return; 
    }
    
    // Koin pickup
    for (int i = daftarKoin.size() - 1; i >= 0; i--) {
      if (i < daftarKoin.size()) { 
        Koin k = daftarKoin.get(i);
        if (dist(mouseX, mouseY, k.pos.x, k.pos.y) < k.ukuran/2) {
          uang += k.nilai;
          daftarKoin.remove(i);
          if (suaraKoin != null) suaraKoin.play();
          return; 
        }
      }
    }
    
    // Drop makanan
    daftarMakanan.add(new Makanan(mouseX, mouseY));
    if (suaraPlop != null) suaraPlop.play();
  }
}
