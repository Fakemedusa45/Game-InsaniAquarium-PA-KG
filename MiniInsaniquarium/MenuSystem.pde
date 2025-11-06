class MenuSystem {
  int screenWidth, screenHeight;
  ArrayList<Menu3DButton> buttons;
  ArrayList<Bubble3D> bubbles;
  float glowAmount = 0;
  float backBtnX, backBtnY, backBtnW = 120, backBtnH = 40;
  float muteBtnX, muteBtnY, muteBtnW = 200, muteBtnH = 50;

  boolean isMuted = false;
  
  PImage logo;

  MenuSystem(int w, int h) {
    screenWidth = w;
    screenHeight = h;
    initializeButtons();
    initializeBubbles();
    
    try {
      logo = loadImage("img/Logo.png");
    } catch (Exception e) {
      println("Gagal memuat file img/Logo.png");
      logo = null;
    }
  }

  void initializeButtons() {
    buttons = new ArrayList<Menu3DButton>();
   int centerX = screenWidth / 2;
  
   int centerY = screenHeight / 2 + (int)(screenHeight * 0.15); // Aslinya: screenHeight / 2
  
    int buttonWidth = (int)(screenWidth * 0.22);
    int buttonHeight = (int)(screenHeight * 0.065);
    int verticalSpacing = (int)(screenHeight * 0.055);
  
    String[] labels = { "MULAI", "CARA BERMAIN", "PENGATURAN", "KELUAR" };
    color[] colors = {
      color(0, 212, 255),
      color(255, 215, 0),
      color(160, 160, 160),
      color(102, 255, 204),
      color(255, 107, 107)
    };
    
    int totalHeight = labels.length * buttonHeight + (labels.length - 1) * verticalSpacing;
    int startY = centerY - totalHeight / 2 + (int)(screenHeight * 0.05);
    
    for (int i = 0; i < labels.length; i++) {
      int y = startY + i * (buttonHeight + verticalSpacing);
      buttons.add(new Menu3DButton(
        centerX - buttonWidth / 2,
        y,
        buttonWidth,
        buttonHeight,
        labels[i],
        colors[i],
        i + 1
        ));
    }
  }

  void initializeBubbles() {
    bubbles = new ArrayList<Bubble3D>();
    for (int i = 0; i < 20; i++) {
      bubbles.add(new Bubble3D(random(screenWidth), random(screenHeight), random(10, 40), screenWidth, screenHeight));
    }
  }

  void display() {
    perspective();
    lights();
    drawGradientBackground();

    for (Bubble3D bubble : bubbles) {
      bubble.update();
      bubble.display();
    }
    
    drawLogo();
    drawTitle();

    for (Menu3DButton btn : buttons) {
      btn.update(mouseX, mouseY);
      btn.display();
    }

    drawFooter();
  }

  void drawGradientBackground() {
    hint(DISABLE_DEPTH_TEST);
    noLights();

    for (int y = 0; y < screenHeight; y++) {
      float inter = map(y, 0, screenHeight, 0, 1);
      int topColor = color(10, 31, 63);
      int midColor = color(26, 77, 122);
      int botColor = color(13, 59, 102);
      int c = inter < 0.5 ? lerpColor(topColor, midColor, inter * 2) : lerpColor(midColor, botColor, (inter - 0.5) * 2);
      stroke(c);
      line(0, y, screenWidth, y);
    }

    hint(ENABLE_DEPTH_TEST);
    lights();
  }

  void drawTitle() {
    hint(DISABLE_DEPTH_TEST);
    glowAmount = sin(frameCount * 0.02) * 0.5 + 0.5;
  
    float titleSize = screenHeight * 0.12;
    float subtitleSize = screenHeight * 0.04;
  
    fill(0, 255, 200);
    textAlign(CENTER);
    textSize((int)titleSize);
  
    float titleY = screenHeight * 0.30;
    float subtitleY = screenHeight * 0.37; // Sub-judul sedikit di bawahnya
  
    for (int i = 0; i < 3; i++) {
      float alpha = 100 * (1 - i * 0.3) * glowAmount;
      fill(0, 255, 200, alpha);
      text("MINI INSANIQUARIUM", screenWidth / 2, titleY - i * 5); // Terapkan titleY
    }
  
    fill(255);
    text("MINI INSANIQUARIUM", screenWidth / 2, titleY); // Terapkan titleY
    textSize((int)subtitleSize);
    fill(160, 230, 229);
    text("~ Simulasikan Akuarium mu ~", screenWidth / 2, subtitleY); // Terapkan subtitleY
  
    hint(ENABLE_DEPTH_TEST);
  }
  
  void drawLogo() {
    if (logo == null) {
      return; 
    }

   hint(DISABLE_DEPTH_TEST);
    noLights();

    pushMatrix();
    
    imageMode(CENTER);
    float logoWidth = 250;
    float logoHeight = logo.height * (logoWidth / logo.width); // Menjaga rasio aspek

    float logoY = screenHeight * 0.15;
   image(logo, screenWidth / 2, logoY, logoWidth, logoHeight);
    imageMode(CORNER); 
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
    lights();
  }

  void drawFooter() {
    hint(DISABLE_DEPTH_TEST);
    fill(255, 255, 255, 150);
    textSize(12);
    textAlign(RIGHT);
    text("Dibuat dengan Processing", screenWidth - 20, screenHeight - 20);
    text("Mini Insaniquarium v1.0", screenWidth - 20, screenHeight - 5);
    hint(ENABLE_DEPTH_TEST);
  }

  int checkButtonClick(float mx, float my) {
    for (Menu3DButton btn : buttons) {
      if (btn.isClicked(mx, my)) {
        return btn.id;
      }
    }
    return 0;
  }

  void drawHowToPlay() {
    hint(DISABLE_DEPTH_TEST);
    fill(0, 0, 0, 150);
    rect(0, 0, screenWidth, screenHeight);

    float modalWidth = screenWidth * 0.85;
    float modalHeight = screenHeight * 0.85;
    float modalX = (screenWidth - modalWidth) / 2;
    float modalY = (screenHeight - modalHeight) / 2;

    fill(10, 31, 63);
    stroke(0, 212, 255);
    strokeWeight(3);
    rect(modalX, modalY, modalWidth, modalHeight, 20);

    fill(0, 212, 255);
    textAlign(CENTER);
    textSize((int)(screenHeight * 0.06));
    text("CARA BERMAIN", screenWidth / 2, modalY + 50);

    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.03));
    textAlign(LEFT);

    float textX = modalX + 40;
    float textY = modalY + 110;
    float lineH = screenHeight * 0.045;

    text("TUJUAN PERMAINAN:", textX, textY);
    textY += lineH;
    text("Beli ikan, beri mereka makan, dan kumpulkan koin!", textX, textY);
    textY += lineH * 1.5;

    text("LANGKAH BERMAIN:", textX, textY);
    textY += lineH;
    text("1. Klik tombol 'Beli Ikan' untuk membeli ikan (harga 50 koin)", textX, textY);
    textY += lineH;
    text("2. Klik di mana saja di akuarium untuk memberi makan", textX, textY);
    textY += lineH;
    text("3. Ikan akan makan otomatis saat lapar", textX, textY);
    textY += lineH;
    text("4. Ambil koin yang dijatuhkan ikan untuk mendapat uang", textX, textY);
    textY += lineH;
    text("5. Ikan tumbuh besar setelah makan 5 kali!", textX, textY);

    drawBackButton(modalY + modalHeight);

    hint(ENABLE_DEPTH_TEST);
  }

  void drawSettings() {
    drawModal("PENGATURAN", 
      new String[]{
        "Suara: " + (isMuted ? "Nonaktif" : "Aktif"),
        "Kualitas: Tinggi",
        "Kesulitan: Normal"
      });

    muteBtnX = screenWidth / 2 - muteBtnW / 2;
    muteBtnY = screenHeight / 2 + 100;
    fill(isMuted ? color(255, 107, 107) : color(100, 200, 100));
    rect(muteBtnX, muteBtnY, muteBtnW, muteBtnH, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(isMuted ? "Unmute Musik" : "Mute Musik", screenWidth / 2, muteBtnY + muteBtnH / 2);

    drawBackButton(screenHeight * 0.9);
  }

  void drawShop() {
    hint(DISABLE_DEPTH_TEST);
    fill(0, 0, 0, 150);
    rect(0, 0, screenWidth, screenHeight);

    float modalWidth = screenWidth * 0.9;
    float modalHeight = screenHeight * 0.9;
    float modalX = (screenWidth - modalWidth) / 2;
    float modalY = (screenHeight - modalHeight) / 2;

    fill(10, 31, 63);
    stroke(102, 255, 204);
    strokeWeight(3);
    rect(modalX, modalY, modalWidth, modalHeight, 20);

    fill(102, 255, 204);
    textAlign(CENTER);
    textSize((int)(screenHeight * 0.07));
    text("TOKO UPGRADE", screenWidth / 2, modalY + 50);

    float leftPanelX = modalX + 30;
    float leftPanelY = modalY + 100;
    float leftPanelW = modalWidth * 0.45;
    float leftPanelH = modalHeight - 150;

    float rightPanelX = leftPanelX + leftPanelW + 30;
    float rightPanelY = leftPanelY;
    float rightPanelW = modalWidth * 0.45;
    float rightPanelH = modalHeight - 150;

    // LEFT PANEL: PREVIEW
    fill(30, 60, 90);
    stroke(0, 212, 255);
    strokeWeight(2);
    rect(leftPanelX, leftPanelY, leftPanelW, leftPanelH, 10);

    fill(0, 212, 255);
    textAlign(CENTER);
    textSize((int)(screenHeight * 0.04));
    text("PREVIEW", leftPanelX + leftPanelW / 2, leftPanelY + 25);

    float previewW = leftPanelW - 30;
    float previewH = leftPanelH - 80;
    float previewX = leftPanelX + 15;
    float previewY = leftPanelY + 50;

    fill(20, 40, 80);
    stroke(0, 150, 180);
    strokeWeight(1);
    rect(previewX, previewY, previewW, previewH, 5);

    if (daftarBG != null && bgIndex < daftarBG.length && daftarBG[bgIndex] != null) {
      image(daftarBG[bgIndex], previewX, previewY, previewW, previewH);
    }

    fill(255);
    textAlign(CENTER);
    textSize((int)(screenHeight * 0.025));
    text("Background #" + (bgIndex + 1), leftPanelX + leftPanelW / 2, previewY + previewH + 25);

    // RIGHT PANEL: ITEMS
    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.03));
    textAlign(LEFT);

    float itemX = rightPanelX + 15;
    float itemY = rightPanelY + 30;
    float itemSpacing = (rightPanelH - 50) / 3;

    drawShopItem(itemX, itemY, rightPanelW - 30, 50, 
      "UPGRADE MakananIkan", "Lv. " + levelMakananIkan, "100 $");

    drawShopItem(itemX, itemY + itemSpacing, rightPanelW - 30, 50, 
      "BELI DEKORASI", "Tambah Tanaman", "200 $");

    drawShopItem(itemX, itemY + itemSpacing * 2, rightPanelW - 30, 50, 
      "GANTI BACKGROUND", "Next BG", "300 $");

    drawBackButton(modalY + modalHeight);

    hint(ENABLE_DEPTH_TEST);
  }

  void drawShopItem(float x, float y, float w, float h, String title, String desc, String price) {
    fill(40, 80, 120);
    stroke(102, 255, 204);
    strokeWeight(2);
    rect(x, y, w, h, 8);

    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      fill(60, 120, 160, 100);
      rect(x, y, w, h, 8);
    }

    fill(102, 255, 204);
    textAlign(LEFT);
    textSize(14);
    text(title, x + 15, y + 20);

    fill(200, 200, 200);
    textSize(12);
    text(desc, x + 15, y + 35);

    fill(255, 220, 100);
    textAlign(RIGHT);
    textSize(13);
    text(price, x + w - 15, y + 22);
  }

  void drawModal(String title, String[] lines) {
    hint(DISABLE_DEPTH_TEST);
    fill(0, 0, 0, 150);
    rect(0, 0, screenWidth, screenHeight);

    float modalWidth = screenWidth * 0.8;
    float modalHeight = screenHeight * 0.75;
    float modalX = (screenWidth - modalWidth) / 2;
    float modalY = (screenHeight - modalHeight) / 2;

    fill(10, 31, 63);
    stroke(0, 212, 255);
    strokeWeight(3);
    rect(modalX, modalY, modalWidth, modalHeight, 20);

    fill(0, 212, 255);
    textAlign(CENTER);
    textSize((int)(screenHeight * 0.06));
    text(title, screenWidth / 2, modalY + 50);

    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.03));
    textAlign(LEFT);

    float textX = modalX + 40;
    float textY = modalY + 120;
    float lineH = screenHeight * 0.045;

    for (String line : lines) {
      text(line, textX, textY);
      textY += lineH;
    }

    hint(ENABLE_DEPTH_TEST);
  }

  void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      if (bgm != null && bgm.isPlaying()) bgm.stop();
    } else {
      if (bgm != null && !bgm.isPlaying()) bgm.loop();
    }
  }

  boolean checkMuteButton(float mx, float my) {
    return (mx > muteBtnX && mx < muteBtnX + muteBtnW && my > muteBtnY && my < muteBtnY + muteBtnH);
  }

  void drawBackButton(float modalBottomY) {
    backBtnW = 140;
    backBtnH = 45;
    backBtnX = screenWidth / 2 - backBtnW / 2;
    backBtnY = modalBottomY - backBtnH - 20;

    fill(255, 107, 107);
    stroke(255);
    strokeWeight(2);
    rect(backBtnX, backBtnY, backBtnW, backBtnH, 12);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("KEMBALI", backBtnX + backBtnW / 2, backBtnY + backBtnH / 2);
  }

  boolean checkBackButton(float mx, float my) {
    return (mx > backBtnX && mx < backBtnX + backBtnW && my > backBtnY && my < backBtnY + backBtnH);
  }

  int checkShopItemClick(float mx, float my) {
    float modalWidth = screenWidth * 0.9;
    float modalHeight = screenHeight * 0.9;
    float modalX = (screenWidth - modalWidth) / 2;
    float modalY = (screenHeight - modalHeight) / 2;

    float leftPanelW = modalWidth * 0.45;
    float rightPanelX = modalX + 30 + leftPanelW + 30;
    float rightPanelY = modalY + 100;
    float rightPanelW = modalWidth * 0.45;
    float rightPanelH = modalHeight - 150;

    float itemX = rightPanelX + 15;
    float itemY = rightPanelY + 30;
    float itemSpacing = (rightPanelH - 50) / 3;
    float itemW = rightPanelW - 30;
    float itemH = 50;

    if (mx > itemX && mx < itemX + itemW && my > itemY && my < itemY + itemH) return 1;
    if (mx > itemX && mx < itemX + itemW && my > itemY + itemSpacing && my < itemY + itemSpacing + itemH) return 2;
    if (mx > itemX && mx < itemX + itemW && my > itemY + itemSpacing * 2 && my < itemY + itemSpacing * 2 + itemH) return 3;

    return 0;
  }
}
class Bubble3D {
  float x, y, size, speedY, wobble;
  int screenWidth, screenHeight;

  Bubble3D(float x, float y, float s, int w, int h) {
    this.x = x;
    this.y = y;
    this.size = s;
    this.speedY = random(0.5, 2);
    this.wobble = random(TWO_PI);
    this.screenWidth = w;
    this.screenHeight = h;
  }

  void update() {
    y -= speedY;
    wobble += 0.05;
    x += sin(wobble) * 0.5;

    if (y < -50) {
      y = screenHeight + 50;
      x = random(screenWidth);
    }
  }

  void display() {
    pushMatrix();
    translate(x, y, 0);
    noStroke();
    fill(255, 255, 255, 60);
    sphere(size);
    fill(255, 255, 255, 100);
    pushMatrix();
    translate(-size / 3, -size / 3, size / 2);
    sphere(size / 4);
    popMatrix();
    popMatrix();
  }
}

class Menu3DButton {
  float x, y, w, h;
  String label;
  color baseColor;
  int id;
  boolean isHovered;
  float hoverAmount;

  Menu3DButton(float x, float y, float w, float h, String label, color c, int id) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.baseColor = c;
    this.id = id;
    this.isHovered = false;
    this.hoverAmount = 0;
  }

  void update(float mx, float my) {
    isHovered = (mx > x && mx < x + w && my > y && my < y + h);
    hoverAmount = constrain(hoverAmount + (isHovered ? 0.1 : -0.1), 0, 1);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);
    float scale = 1 + hoverAmount * 0.1;
    float scaledW = w * scale;
    float scaledH = h * scale;
    float offsetX = x + (w - scaledW) / 2;
    float offsetY = y + (h - scaledH) / 2;

    fill(0, 0, 0, 100);
    rect(offsetX + 5, offsetY + 5, scaledW, scaledH, 15);

    fill(baseColor);
    stroke(255, 255, 255, 150 + hoverAmount * 105);
    strokeWeight(3 + hoverAmount * 2);
    rect(offsetX, offsetY, scaledW, scaledH, 15);

    if (isHovered) {
      noFill();
      stroke(255, 255, 255, 100 * hoverAmount);
      strokeWeight(2);
      rect(offsetX - 5, offsetY - 5, scaledW + 10, scaledH + 10, 15);
    }

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16 + hoverAmount * 2);
    text(label, offsetX + scaledW / 2, offsetY + scaledH / 2);

    hint(ENABLE_DEPTH_TEST);
  }

  boolean isClicked(float mx, float my) {
    return (mx > x && mx < x + w && my > y && my < y + h);
  }
}
