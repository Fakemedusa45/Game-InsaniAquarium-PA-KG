import processing.sound.*;
SoundFile suaraPlop;
SoundFile suaraKoin;
SoundFile suaraBeli;
SoundFile bgm;

ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>();
ArrayList<MakananIkan> MakananIkanIkan = new ArrayList<MakananIkan>();
ArrayList<Koin> daftarKoin = new ArrayList<Koin>();

int uang = 100;
int hargaIkan = 50;
int hargaGantiBg = 300; 

PImage bg;
MenuSystem menuScreen; 

int levelMakananIkan = 1;
boolean dekorAktif = false;
int bgIndex = 0;
PImage[] daftarBG;

enum GameState {
  MENU,
  GAMEPLAY,
  HOW_TO_PLAY,
  SETTINGS,
  SHOP,
  CONFIRM_EXIT,
  GAME_OVER 
}

GameState gameState = GameState.MENU;
GameState stateBeforeConfirm;

float topBarH = 65; 
float btnBeliX, btnBeliY, btnBeliW, btnBeliH;
float btnGantiBgX, btnGantiBgY, btnGantiBgW, btnGantiBgH;
float btnMenuX, btnMenuY, btnMenuW, btnMenuH;

float goBtnMainLagiX, goBtnMainLagiY, goBtnMenuX, goBtnMenuY, goBtnW, goBtnH;
color goModalBgColor, goModalBorderColor, goGameOverTextColor, goDescriptionTextColor;
color goBtnMainLagiBg, goBtnMainLagiText, goBtnMenuBg, goBtnMenuText;

float cfModalX, cfModalY, cfModalW, cfModalH;
float cfBtnYesX, cfBtnYesY, cfBtnNoX, cfBtnNoY, cfBtnW, cfBtnH;
color cfModalBgColor, cfModalBorderColor, cfTitleTextColor, cfDescTextColor;
color cfBtnYesBg, cfBtnYesText, cfBtnNoBg, cfBtnNoText;

color btnBiru, btnKuning, btnMerah, btnDisabled;
color borderCerah, borderHover, borderDisabled;
color textDisabled, textCerah;


void setup() {
  size(800, 600, P3D);

  try {
    daftarBG = new PImage[10]; 
    daftarBG[0] = loadImage("img/bg1.png");
    daftarBG[1] = loadImage("img/bg2.png");
    daftarBG[2] = loadImage("img/bg3.png");
    daftarBG[3] = loadImage("img/bg4.jpg");
    daftarBG[4] = loadImage("img/bg5.png");
    daftarBG[5] = loadImage("img/bg6.png"); 
    daftarBG[6] = loadImage("img/bg7.png");
    daftarBG[7] = loadImage("img/bg8.png");
    daftarBG[8] = loadImage("img/bg9.jpg");
    daftarBG[9] = loadImage("img/bg10.png");
    bg = daftarBG[0];
  } catch (Exception e) {
    println("Background image not found - using solid color");
    bg = null;
  }

  menuScreen = new MenuSystem(width, height); 

  try {
    suaraPlop = new SoundFile(this, "SE/plop.mp3");
    suaraKoin = new SoundFile(this, "SE/coin.mp3");
    suaraBeli = new SoundFile(this, "SE/purchase.mp3");
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3");
    bgm.loop();
  } catch (Exception e) {
    println("Audio files not found. Game will run without sound.");
  }

  btnBiru = color(20, 100, 160);
  btnKuning = color(200, 160, 0);
  btnMerah = color(180, 50, 70);
  btnDisabled = color(100, 110, 120, 200);
  
  borderCerah = color(0, 212, 255);
  borderHover = color(255, 255, 255, 200);
  borderDisabled = color(80, 90, 100);
  
  textDisabled = color(180);
  textCerah = color(230);

  btnMenuW = 90; 
  btnGantiBgW = 110; 
  btnBeliW = 110; 
  btnMenuH = 40; 
  btnGantiBgH = 40; 
  btnBeliH = 40; 
  goModalBgColor = color(18, 43, 74); 
  goModalBorderColor = color(101, 214, 173); 
  goGameOverTextColor = color(224, 108, 117); 
  goDescriptionTextColor = color(212, 212, 212); 
  goBtnMainLagiBg = color(101, 214, 173); 
  goBtnMainLagiText = color(30); 
  goBtnMenuBg = color(74, 107, 138); 
  goBtnMenuText = color(230); 
  cfModalBgColor = color(18, 43, 74);        
  cfModalBorderColor = color(200, 160, 0);    
  cfTitleTextColor = color(230);              
  cfDescTextColor = color(212);               
  cfBtnYesBg = color(180, 50, 70);            
  cfBtnYesText = color(230);
  cfBtnNoBg = color(74, 107, 138);           
  cfBtnNoText = color(230);

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
  case CONFIRM_EXIT:
    if (stateBeforeConfirm == GameState.GAMEPLAY) drawGameplay();
    else if (stateBeforeConfirm == GameState.HOW_TO_PLAY) {
      menuScreen.display(); 
      menuScreen.drawHowToPlay();
    } else if (stateBeforeConfirm == GameState.SETTINGS) {
      menuScreen.display(); 
      menuScreen.drawSettings();
    } else if (stateBeforeConfirm == GameState.SHOP) {
      menuScreen.display(); 
    }
    drawConfirmPopup();
    break;

  case GAME_OVER:
    drawGameplay(); 
    drawGameOverScreen(); 
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

  if (dekorAktif) {
    drawDekorasiKecil();
  }

  // Draw MakananIkan
  for (int i = MakananIkanIkan.size() - 1; i >= 0; i--) {
    if (i < MakananIkanIkan.size()) {
      MakananIkan m = MakananIkanIkan.get(i);
      m.jatuh(levelMakananIkan);
      m.tampil();
      if (m.pos.y > height) MakananIkanIkan.remove(i);
    }
  }

  // Manage Ikan
  for (int i = daftarIkan.size() - 1; i >= 0; i--) {
    if (i < daftarIkan.size()) {
      Ikan ikan = daftarIkan.get(i);
      ikan.update();
      ikan.tampil();
      ikan.findFood(MakananIkanIkan);
      if (!ikan.isAlive && ikan.alpha <= 0) daftarIkan.remove(i);
    }
  }
  
  //Manage Koin
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

  drawTopBar(); 

  hint(ENABLE_DEPTH_TEST);

  if (gameState == GameState.GAMEPLAY && daftarIkan.isEmpty() && uang < hargaIkan) {
    gameState = GameState.GAME_OVER;
  }
}

void drawDekorasiKecil() {
  noStroke();

  float dekorY = topBarH + 20; 

  fill(40, 120, 60, 150);
  ellipse(60, dekorY + 8, 25, 12);
  fill(60, 200, 80, 180);
  rect(56, dekorY - 5, 4, 12);
  rect(64, dekorY - 8, 4, 15);

  fill(40, 120, 60, 150);
  ellipse(width/2, dekorY + 8, 30, 13);
  fill(60, 200, 80, 180);
  rect(width/2 - 12, dekorY - 8, 5, 16);
  rect(width/2, dekorY - 10, 5, 18);
  rect(width/2 + 10, dekorY - 7, 5, 15);

  if (dekorAktif) {
    fill(40, 120, 60, 150);
    ellipse(width - 60, dekorY + 8, 25, 12);
    fill(60, 200, 80, 180);
    rect(width - 65, dekorY - 5, 4, 12);
    rect(width - 57, dekorY - 8, 4, 15);
  }
}

void drawTopBar() {
  hint(DISABLE_DEPTH_TEST);
  perspective();
  noLights();

  float topBarY = 0;

  fill(10, 31, 63, 220); 
  stroke(borderCerah);
  strokeWeight(2);
  rect(0, topBarY, width, topBarH, 0, 0, 15, 15); 

  noStroke();

  fill(255, 255, 0);
  textSize(32);
  textAlign(LEFT, CENTER);
  text("$" + uang, 20, topBarH / 2 + 5);

  fill(textCerah); 
  textSize(11); 
  textAlign(LEFT, CENTER);
  fill(dekorAktif ? color(100, 255, 100) : color(150));


  btnMenuX = width - btnMenuW - 15;
  btnMenuY = (topBarH - btnMenuH) / 2;

  boolean hoverMenu = (mouseX > btnMenuX && mouseX < btnMenuX + btnMenuW && 
    mouseY > btnMenuY && mouseY < btnMenuY + btnMenuH);

  if (hoverMenu) {
    fill(btnMerah, 240); 
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(btnMerah);
    stroke(btnMerah, 255); 
    strokeWeight(1);
  }
  rect(btnMenuX, btnMenuY, btnMenuW, btnMenuH, 8);

  noStroke();
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("MENU", btnMenuX + btnMenuW / 2, btnMenuY + btnMenuH / 2); 

  btnGantiBgX = btnMenuX - btnGantiBgW - 10;
  btnGantiBgY = (topBarH - btnGantiBgH) / 2;

  boolean hoverGantiBg = (mouseX > btnGantiBgX && mouseX < btnGantiBgX + btnGantiBgW && 
    mouseY > btnGantiBgY && mouseY < btnGantiBgY + btnGantiBgH);
  boolean canGantiBg = (uang >= hargaGantiBg);

  if (!canGantiBg) {
    fill(btnDisabled);
    stroke(borderDisabled);
    strokeWeight(1);
  } else if (hoverGantiBg) {
    fill(btnKuning, 240);
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(btnKuning);
    stroke(btnKuning, 255);
    strokeWeight(1);
  }
  rect(btnGantiBgX, btnGantiBgY, btnGantiBgW, btnGantiBgH, 8);

  noStroke();
  fill(canGantiBg ? 255 : textDisabled); 
  textAlign(CENTER, CENTER);
  textSize(13);
  text("GANTI BG", btnGantiBgX + btnGantiBgW / 2, btnGantiBgY + 12);
  textSize(11);
  fill(canGantiBg ? color(220) : textDisabled); 
  text("(" + hargaGantiBg + "$)", btnGantiBgX + btnGantiBgW / 2, btnGantiBgY + 28);


  btnBeliX = btnGantiBgX - btnBeliW - 10;
  btnBeliY = (topBarH - btnBeliH) / 2;

  boolean hoverBeliIkan = (mouseX > btnBeliX && mouseX < btnBeliX + btnBeliW && 
    mouseY > btnBeliY && mouseY < btnBeliY + btnBeliH);
  boolean canBeliIkan = (uang >= hargaIkan);

  if (!canBeliIkan) {
    fill(btnDisabled);
    stroke(borderDisabled);
    strokeWeight(1);
  } else if (hoverBeliIkan) {
    fill(btnBiru, 240);
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(btnBiru);
    stroke(btnBiru, 255);
    strokeWeight(1);
  }
  rect(btnBeliX, btnBeliY, btnBeliW, btnBeliH, 8);

  noStroke();
  fill(canBeliIkan ? 255 : textDisabled);
  textAlign(CENTER, CENTER);
  textSize(13);
  text("BELI IKAN", btnBeliX + btnBeliW / 2, btnBeliY + 12);
  textSize(11);
  fill(canBeliIkan ? color(220) : textDisabled);
  text("(" + hargaIkan + "$)", btnBeliX + btnBeliW / 2, btnBeliY + 28);


  hint(ENABLE_DEPTH_TEST);
  lights();
}
 
void drawConfirmPopup() {
  hint(DISABLE_DEPTH_TEST);
  noLights();
  perspective();

  // Latar belakang gelap transparan
  fill(0, 0, 0, 200);
  rect(0, 0, width, height);

  // Kalkulasi Ukuran & Posisi Modal
  cfModalW = width * 0.6;
  cfModalH = height * 0.4; 
  cfModalX = (width - cfModalW) / 2;
  cfModalY = (height - cfModalH) / 2;

  // Latar belakang modal
  fill(cfModalBgColor);
  stroke(cfModalBorderColor);
  strokeWeight(3);
  rect(cfModalX, cfModalY, cfModalW, cfModalH, 20);

  // === Pengaturan Posisi (Y) ===
  float titleY = cfModalY + 50;
  float descY = titleY + 45;
  float buttonY = descY + 60;

  // Teks Judul
  fill(cfTitleTextColor);
  textAlign(CENTER, CENTER);
  textSize(26);
  text("Kembali ke Menu?", width / 2, titleY);

  // Teks Deskripsi
  fill(cfDescTextColor);
  textSize(17);
  text("Anda yakin ingin keluar dari permainan?", width / 2, descY);

  // Pengaturan Tombol
  cfBtnW = (cfModalW / 2) - 70;
  cfBtnH = 45; // Dibuat 45px
  cfBtnYesX = cfModalX + 50; // Padding 50px
  cfBtnYesY = buttonY;
  
  cfBtnNoX = cfModalX + cfModalW - cfBtnW - 50; // Padding 50px
  cfBtnNoY = buttonY;

  boolean hoverYes = (mouseX > cfBtnYesX && mouseX < cfBtnYesX + cfBtnW && 
    mouseY > cfBtnYesY && mouseY < cfBtnYesY + cfBtnH);

  if (hoverYes) {
    fill(cfBtnYesBg, 220); 
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(cfBtnYesBg);
    noStroke();
  }
  rect(cfBtnYesX, cfBtnYesY, cfBtnW, cfBtnH, 12);
  fill(cfBtnYesText);
  textSize(16);
  text("YA, KEMBALI", cfBtnYesX + cfBtnW / 2, cfBtnYesY + cfBtnH / 2);
  boolean hoverNo = (mouseX > cfBtnNoX && mouseX < cfBtnNoX + cfBtnW && 
    mouseY > cfBtnNoY && mouseY < cfBtnNoY + cfBtnH);

  if (hoverNo) {
    fill(cfBtnNoBg, 220); 
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(cfBtnNoBg);
    noStroke();
  }
  rect(cfBtnNoX, cfBtnNoY, cfBtnW, cfBtnH, 12);
  fill(cfBtnNoText);
  text("TIDAK, BATAL", cfBtnNoX + cfBtnW / 2, cfBtnNoY + cfBtnH / 2);

  hint(ENABLE_DEPTH_TEST);
}

void drawGameOverScreen() {
  hint(DISABLE_DEPTH_TEST);
  noLights();
  perspective();

  fill(0, 0, 0, 200); 
  rect(0, 0, width, height);

  float modalWidth = width * 0.7;
  float modalHeight = height * 0.45;
  float modalX = (width - modalWidth) / 2;
  float modalY = (height - modalHeight) / 2;

  // Latar belakang modal
  fill(goModalBgColor);
  stroke(goModalBorderColor); 
  strokeWeight(3);
  rect(modalX, modalY, modalWidth, modalHeight, 20);
  float paddingAtas = 60; // Jarak dari atas modal ke judul
  float spasiAntarElemen = 60; // Jarak antar elemen (Judul -> Deskripsi -> Tombol)

  goBtnH = 50; 
  float titleY = modalY + paddingAtas;
  float descY = titleY + spasiAntarElemen;
  float buttonY = descY + spasiAntarElemen; // Tombol akan *dimulai* dari posisi ini

  fill(goGameOverTextColor);
  textAlign(CENTER, CENTER); 
  textSize(36);
  text("GAME OVER", width / 2, titleY);


  fill(goDescriptionTextColor);
  textAlign(CENTER, CENTER); 
  textSize(18);
  text("Semua ikanmu telah tiada...", width / 2, descY);

  goBtnW = (modalWidth / 2) - 70;
  goBtnMainLagiX = modalX + 50; 
  goBtnMainLagiY = buttonY; 
  
  goBtnMenuX = modalX + modalWidth - goBtnW - 50; 
  goBtnMenuY = buttonY; 

  boolean hoverMainLagi = (mouseX > goBtnMainLagiX && mouseX < goBtnMainLagiX + goBtnW && 
    mouseY > goBtnMainLagiY && mouseY < goBtnMainLagiY + goBtnH);

  if (hoverMainLagi) {
    fill(goBtnMainLagiBg, 220); 
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(goBtnMainLagiBg);
    noStroke(); 
  }
  rect(goBtnMainLagiX, goBtnMainLagiY, goBtnW, goBtnH, 12); 
  fill(goBtnMainLagiText);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("MAIN LAGI", goBtnMainLagiX + goBtnW / 2, goBtnMainLagiY + goBtnH / 2);
  boolean hoverMenuUtama = (mouseX > goBtnMenuX && mouseX < goBtnMenuX + goBtnW && 
    mouseY > goBtnMenuY && mouseY < goBtnMenuY + goBtnH);

  if (hoverMenuUtama) {
    fill(goBtnMenuBg, 220); 
    stroke(borderHover);
    strokeWeight(2);
  } else {
    fill(goBtnMenuBg);
    noStroke(); 
  }
  rect(goBtnMenuX, goBtnMenuY, goBtnW, goBtnH, 12); 
  fill(goBtnMenuText);
  textAlign(CENTER, CENTER); // Pastikan Text Align untuk tombol
  text("MENU UTAMA", goBtnMenuX + goBtnW / 2, goBtnMenuY + goBtnH / 2);

  hint(ENABLE_DEPTH_TEST);
}


void mousePressed() {
   if (gameState == GameState.MENU) {
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY);
    if (buttonClicked == 1) { 
      gameState = GameState.GAMEPLAY;
      uang = 500;
      daftarIkan.clear();
      MakananIkanIkan.clear();
      daftarKoin.clear();
      dekorAktif = false;
      levelMakananIkan = 1;
    } else if (buttonClicked == 2) gameState = GameState.HOW_TO_PLAY;
    else if (buttonClicked == 3) gameState = GameState.SETTINGS;
    else if (buttonClicked == 4) {
  if (bgm != null) bgm.stop();
  if (suaraPlop != null) suaraPlop.stop();
  if (suaraKoin != null) suaraKoin.stop();
  if (suaraBeli != null) suaraBeli.stop();
  noLoop();
  exit();
}
    return;
  }
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
    int itemClicked = menuScreen.checkShopItemClick(mouseX, mouseY);

    if (itemClicked == 1) {
      if (uang >= 100) {
        uang -= 100;
        levelMakananIkan++;
        if (suaraBeli != null) suaraBeli.play();
      }
    } else if (itemClicked == 2) {
      if (uang >= 200) {
        uang -= 200;
        dekorAktif = true;
        if (suaraBeli != null) suaraBeli.play();
      }
    } else if (itemClicked == 3) {
      if (uang >= hargaGantiBg) { 
        uang -= hargaGantiBg;
        bgIndex = (bgIndex + 1) % daftarBG.length;
        if (daftarBG != null && bgIndex < daftarBG.length) {
          bg = daftarBG[bgIndex];
        }
        if (suaraBeli != null) suaraBeli.play();
      }
    }

    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU;
    return;
  }
  if (gameState == GameState.CONFIRM_EXIT) {
    if (mouseX > cfBtnYesX && mouseX < cfBtnYesX + cfBtnW && 
      mouseY > cfBtnYesY && mouseY < cfBtnYesY + cfBtnH) {
      gameState = GameState.MENU;
      return;
    }
    if (mouseX > cfBtnNoX && mouseX < cfBtnNoX + cfBtnW && 
      mouseY > cfBtnNoY && mouseY < cfBtnNoY + cfBtnH) {
      gameState = stateBeforeConfirm;
      return;
    }
  }

  if (gameState == GameState.GAME_OVER) {
    if (mouseX > goBtnMainLagiX && mouseX < goBtnMainLagiX + goBtnW && 
      mouseY > goBtnMainLagiY && mouseY < goBtnMainLagiY + goBtnH) {
      uang = 500; // Mulai lagi dengan uang 500
      daftarIkan.clear();
      MakananIkanIkan.clear();
      daftarKoin.clear();
      dekorAktif = false;
      levelMakananIkan = 1;
      gameState = GameState.GAMEPLAY;
      return;
    }
    if (mouseX > goBtnMenuX && mouseX < goBtnMenuX + goBtnW && 
      mouseY > goBtnMenuY && mouseY < goBtnMenuY + goBtnH) {
      gameState = GameState.MENU;
      return;
    }
    return; 
  }

  if (gameState == GameState.GAMEPLAY) {
    if (mouseX > btnMenuX && mouseX < btnMenuX + btnMenuW && 
      mouseY > btnMenuY && mouseY < btnMenuY + btnMenuH) {
      stateBeforeConfirm = GameState.GAMEPLAY;
      gameState = GameState.CONFIRM_EXIT;
      return;
    }
    if (mouseX > btnBeliX && mouseX < btnBeliX + btnBeliW && 
      mouseY > btnBeliY && mouseY < btnBeliY + btnBeliH) {
      if (uang >= hargaIkan) { 
        uang -= hargaIkan;
        daftarIkan.add(new Ikan(random(100, width-100), random(topBarH + 50, height-100))); 
        if (suaraBeli != null) suaraBeli.play();
      }
      return;
    }
    if (mouseX > btnGantiBgX && mouseX < btnGantiBgX + btnGantiBgW && 
      mouseY > btnGantiBgY && mouseY < btnGantiBgY + btnGantiBgH) {
      if (uang >= hargaGantiBg) { 
        uang -= hargaGantiBg;
        bgIndex = (bgIndex + 1) % daftarBG.length;
        if (daftarBG != null && bgIndex < daftarBG.length) {
          bg = daftarBG[bgIndex];
        }
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
    if (mouseY > topBarH) { 
      MakananIkanIkan.add(new MakananIkan(mouseX, mouseY));
      if (suaraPlop != null) suaraPlop.play();
    }
  }
}
