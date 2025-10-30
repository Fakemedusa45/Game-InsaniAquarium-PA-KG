import processing.sound.*;
SoundFile suaraPlop;
SoundFile suaraKoin;
SoundFile suaraBeli;
SoundFile bgm;

ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>();
ArrayList<Makanan> daftarMakanan = new ArrayList<Makanan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();

int uang = 100;
int hargaIkan = 50;

Tombol tombolBeliIkan;
PImage bg;
MenuSystem menuScreen;

// === Variabel tambahan untuk TOKO ===
int levelMakanan = 1;
boolean dekorAktif = false;
int bgIndex = 0;
PImage[] daftarBG;

// === State permainan ===
enum GameState {
  MENU,
  GAMEPLAY,
  HOW_TO_PLAY,
  SETTINGS,
  SHOP,
  CONFIRM_EXIT
}

GameState gameState = GameState.MENU;
GameState stateBeforeConfirm;

void setup() {
  size(800, 600, P3D);

  try {
    daftarBG = new PImage[3];
    daftarBG[0] = loadImage("img/bg2.png");
    daftarBG[1] = loadImage("img/bg3.png");
    daftarBG[2] = loadImage("img/bg4.png");
    bg = daftarBG[0];
  } catch (Exception e) {
    println("Background image not found - using solid color");
    bg = null;
  }

  menuScreen = new MenuSystem(width, height);
  tombolBeliIkan = new Tombol(20, 20, 150, 40, "Beli Ikan (50)");

  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3");
    bgm.loop();
  } catch (Exception e) {
    println("Audio files not found. Game will run without sound.");
  }

  surface.setResizable(true);
  surface.setLocation(200, 100);
}

void draw() {
  background(10, 20, 40);

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
  case SHOP:
    menuScreen.display();
    menuScreen.drawShop();
    break;
  case CONFIRM_EXIT:
    if (stateBeforeConfirm == GameState.GAMEPLAY) drawGameplay();
    else if (stateBeforeConfirm == GameState.HOW_TO_PLAY) {menuScreen.display(); menuScreen.drawHowToPlay();}
    else if (stateBeforeConfirm == GameState.SETTINGS) {menuScreen.display(); menuScreen.drawSettings();}
    else if (stateBeforeConfirm == GameState.SHOP) {menuScreen.display(); menuScreen.drawShop();}
    drawConfirmPopup();
    break;
  }
}

void drawMenu() {
  menuScreen.display();
}

void drawGameplay() {
  lights();

  if (bg != null) image(bg, 0, 0, width, height);
  else background(20, 40, 80);

  // === Dekorasi akuarium jika aktif ===
  if (dekorAktif) {
    noStroke();
    fill(40, 120, 60, 180);
    ellipse(150, height - 40, 120, 40);
    ellipse(400, height - 30, 200, 50);
    ellipse(650, height - 35, 140, 40);
    fill(60, 200, 80, 200);
    rect(130, height - 80, 20, 50);
    rect(390, height - 100, 25, 70);
    rect(640, height - 90, 20, 60);
  }

  // === Makanan ===
  for (int i = daftarMakanan.size() - 1; i >= 0; i--) {
    if (i < daftarMakanan.size()) {
      Makanan m = daftarMakanan.get(i);
      m.jatuh(levelMakanan);
      m.tampil();
      if (m.pos.y > height) daftarMakanan.remove(i);
    }
  }

  // === Ikan ===
  for (int i = daftarIkan.size() - 1; i >= 0; i--) {
    if (i < daftarIkan.size()) {
      Ikan ikan = daftarIkan.get(i);
      ikan.update();
      ikan.tampil();
      ikan.findFood(daftarMakanan);
      if (!ikan.isAlive && ikan.alpha <= 0) daftarIkan.remove(i);
    }
  }

  // === Koin ===
  for (int i = daftarKoin.size() - 1; i >= 0; i--) {
    if (i < daftarKoin.size()) {
      Koin k = daftarKoin.get(i);
      k.tampil();
      k.jatuh();
      if (k.pos.y > height) daftarKoin.remove(i);
    }
  }

  hint(DISABLE_DEPTH_TEST);
  perspective();

  tombolBeliIkan.tampil();

  fill(255, 255, 0);
  textSize(32);
  textAlign(LEFT);
  text("$" + uang, 710, 50);

  // Indikator level makanan
  fill(255);
  textSize(14);
  textAlign(LEFT);
  text("Lv. Makanan: " + levelMakanan, 20, 70);

  // Tombol MENU
  fill(255, 100, 100);
  rect(width - 110, height - 60, 90, 40, 5);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("MENU", width - 65, height - 40);

  hint(ENABLE_DEPTH_TEST);
}

void drawConfirmPopup() {
  hint(DISABLE_DEPTH_TEST);
  noLights();
  perspective();

  fill(0, 0, 0, 150);
  rect(0, 0, width, height);

  float modalWidth = width * 0.6;
  float modalHeight = height * 0.35;
  float modalX = (width - modalWidth) / 2;
  float modalY = (height - modalHeight) / 2;

  fill(10, 31, 63);
  stroke(255, 107, 107);
  strokeWeight(3);
  rect(modalX, modalY, modalWidth, modalHeight, 20);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Kembali ke Menu?", width / 2, modalY + 40);
  textSize(16);
  text("Anda yakin ingin kembali ke menu utama?", width / 2, modalY + 85);

  float yaX = modalX + 50;
  float yaY = modalY + modalHeight - 70;
  float btnW = (modalWidth / 2) - 70;
  float btnH = 40;
  fill(255, 107, 107);
  rect(yaX, yaY, btnW, btnH, 10);
  fill(255);
  text("YA, KEMBALI", yaX + btnW / 2, yaY + btnH / 2);

  float tidakX = modalX + modalWidth - btnW - 50;
  float tidakY = yaY;
  fill(100, 200, 100);
  rect(tidakX, tidakY, btnW, btnH, 10);
  fill(0);
  text("TIDAK, BATAL", tidakX + btnW / 2, tidakY + btnH / 2);

  hint(ENABLE_DEPTH_TEST);
}

void mousePressed() {
  if (gameState == GameState.MENU) {
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY);
    if (buttonClicked == 1) {
      gameState = GameState.GAMEPLAY;
      uang = 500;
      daftarIkan.clear();
      daftarMakanan.clear();
      daftarKoin.clear();
    } else if (buttonClicked == 2) gameState = GameState.HOW_TO_PLAY;
    else if (buttonClicked == 3) gameState = GameState.SETTINGS;
    else if (buttonClicked == 4) gameState = GameState.SHOP;
    else if (buttonClicked == 5) exit();
    return;
  }

  // === Langsung kembali tanpa konfirmasi ===
  if (gameState == GameState.HOW_TO_PLAY) {
    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU;
    return;
  }

  if (gameState == GameState.SETTINGS) {
    if (menuScreen.checkMuteButton(mouseX, mouseY)) {
      menuScreen.toggleMute();
      return;
    }
    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU;
    return;
  }

  if (gameState == GameState.SHOP) {
    float btnW = width * 0.35;
    float btnH = height * 0.08;
    float btnX = width / 2 - btnW / 2;
    float startY = height * 0.25 + 150;
    float spacing = height * 0.12;

    // Tombol Upgrade Makanan
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > startY && mouseY < startY + btnH) {
      if (uang >= 100) {
        uang -= 100;
        levelMakanan++;
        if (suaraBeli != null) suaraBeli.play();
      }
      return;
    }

    // Tombol Dekorasi Akuarium
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > startY + spacing && mouseY < startY + spacing + btnH) {
      if (uang >= 200) {
        uang -= 200;
        dekorAktif = true;
        if (suaraBeli != null) suaraBeli.play();
      }
      return;
    }

    // Tombol Ganti Background
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > startY + spacing * 2 && mouseY < startY + spacing * 2 + btnH) {
      if (uang >= 300) {
        uang -= 300;
        bgIndex = (bgIndex + 1) % daftarBG.length;
        bg = daftarBG[bgIndex];
        if (suaraBeli != null) suaraBeli.play();
      }
      return;
    }

    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU;
    return;
  }

  // === Pop-up Konfirmasi keluar ===
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
      gameState = GameState.MENU;
      return;
    }

    float tidakX = modalX + modalWidth - btnW - 50;
    float tidakY = yaY;
    if (mouseX > tidakX && mouseX < tidakX + btnW && mouseY > tidakY && mouseY < tidakY + btnH) {
      gameState = stateBeforeConfirm;
      return;
    }
  }

  // === Gameplay ===
  if (gameState == GameState.GAMEPLAY) {
    if (mouseX > width - 110 && mouseX < width - 20 && mouseY > height - 60 && mouseY < height - 20) {
      stateBeforeConfirm = GameState.GAMEPLAY;
      gameState = GameState.CONFIRM_EXIT;
      return;
    }

    if (tombolBeliIkan.isDiKlik(mouseX, mouseY)) {
      if (uang >= hargaIkan) {
        uang -= hargaIkan;
        daftarIkan.add(new Ikan(width / 2, height / 2));
        if (suaraBeli != null) suaraBeli.play();
      }
      return;
    }

    for (int i = daftarKoin.size() - 1; i >= 0; i--) {
      if (i < daftarKoin.size()) {
        Koin k = daftarKoin.get(i);
        if (dist(mouseX, mouseY, k.pos.x, k.pos.y) < k.ukuran / 2) {
          uang += k.nilai;
          daftarKoin.remove(i);
          if (suaraKoin != null) suaraKoin.play();
          return;
        }
      }
    }

    daftarMakanan.add(new Makanan(mouseX, mouseY));
    if (suaraPlop != null) suaraPlop.play();
  }
}
