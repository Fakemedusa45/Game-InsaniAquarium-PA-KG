  // ==================================
// MINI INSANIQUARIUM - MAIN FILE (RESPONSIVE)
// Dengan 3D Menu dan Gameplay Integration
// ==================================

import processing.sound.*;

// MODUL 4: Sound
SoundFile suaraPlop;
SoundFile suaraKoin;
SoundFile suaraBeli;
SoundFile bgm;

// MODUL 5: Game Objects
ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>();
ArrayList<Makanan> daftarMakanan = new ArrayList<Makanan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();

// Variabel Game
int uang = 100;
int hargaIkan = 50;
Tombol tombolBeliIkan;

// Background
PImage bg;

// ===== MENU SYSTEM (NEW) =====
MenuSystem menuScreen;
enum GameState {
  MENU,
  GAMEPLAY,
  HOW_TO_PLAY,
  SETTINGS
}
GameState gameState = GameState.MENU;

void setup() {
  // RESPONSIVE SIZE - Lebih pas dengan layar
  size(800, 600, P3D); // 4:3 aspect ratio - lebih balanced!
  
  // Load background
  try {
    bg = loadImage("img/bg2.png");
  } catch (Exception e) {
    println("Background image not found - akan pakai warna solid");
    bg = null;
  }
  
  // Initialize Menu
  menuScreen = new MenuSystem(width, height);
  
  // Initialize Game Button
  tombolBeliIkan = new Tombol(20, 20, 150, 40, "Beli Ikan (50)");
  
  // Load sounds (safe dengan try-catch)
  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3");
    bgm.loop();
  } catch (Exception e) {
    println("Audio files not found. Game continues without sound.");
  }
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
      menuScreen.drawHowToPlay();
      if (mousePressed && menuScreen.checkBackButton(mouseX, mouseY)) {
        gameState = GameState.MENU;
        mousePressed = false;
      }
      break;
    case SETTINGS:
      menuScreen.drawSettings();
      if (mousePressed && menuScreen.checkBackButton(mouseX, mouseY)) {
        gameState = GameState.MENU;
        mousePressed = false;
      }
      break;
  }
}

// ===== MENU RENDERING =====
void drawMenu() {
  menuScreen.display();
  
  if (mousePressed) {
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY);
    
    if (buttonClicked == 1) { // START GAME
      gameState = GameState.GAMEPLAY;
      uang = 100;
      daftarIkan.clear();
      daftarMakanan.clear();
      daftarKoin.clear();
      mousePressed = false;
    } else if (buttonClicked == 2) { // HOW TO PLAY
      gameState = GameState.HOW_TO_PLAY;
      mousePressed = false;
    } else if (buttonClicked == 3) { // SETTINGS
      gameState = GameState.SETTINGS;
      mousePressed = false;
    } else if (buttonClicked == 4) { // EXIT
      exit();
    }
  }
}

// ===== GAMEPLAY RENDERING =====
void drawGameplay() {
  // RENDER 3D GAMEWORLD
  lights();
  
  // Background
  if (bg != null) {
    // PERBAIKAN: Gunakan image() untuk merentangkan gambar
    image(bg, 0, 0, width, height);
  } else {
    background(20, 40, 80);
  }
  
 
  
  // Update dan render Makanan
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
  
  // Update dan render Ikan
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
  
  // Update dan render Koin
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
  
  // ===== RENDER 2D UI (di atas 3D) =====
  hint(DISABLE_DEPTH_TEST);
  perspective();
  
  // Tombol Beli Ikan
  tombolBeliIkan.tampil();
  
  // Display money
  fill(255, 255, 0);
  textSize(32);
  textAlign(LEFT);
  text("$" + uang, 30, 50);
  
  // Back to menu button (top-right corner)
  fill(255, 100, 100);
  rect(width - 110, 20, 90, 40, 5);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("MENU", width - 65, 40);
  
  if (mousePressed && mouseX > width - 110 && mouseX < width - 20 && mouseY > 20 && mouseY < 60) {
    gameState = GameState.MENU;
    mousePressed = false;
  }
  
  hint(ENABLE_DEPTH_TEST);
}

// ===== MOUSE INTERACTION =====
void mousePressed() {
  if (gameState == GameState.GAMEPLAY) {
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
