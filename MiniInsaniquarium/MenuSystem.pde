// ==================================
// MENU SYSTEM - 3D Menu (RESPONSIVE) - FIXED
// ==================================

class MenuSystem {
  int screenWidth, screenHeight;
  ArrayList<Menu3DButton> buttons;
  ArrayList<Bubble3D> bubbles;
  float glowAmount = 0;

  // Simpan posisi back button
  float backBtnX, backBtnY, backBtnW = 120, backBtnH = 40;

  MenuSystem(int w, int h) {
    screenWidth = w;
    screenHeight = h;
    initializeButtons();
    initializeBubbles();
  }

 void initializeButtons() {
  buttons = new ArrayList<Menu3DButton>();
  int centerX = screenWidth / 2;
  int centerY = screenHeight / 2;

  int buttonWidth = (int)(screenWidth * 0.3);
  int buttonHeight = (int)(screenHeight * 0.08);
  int verticalSpacing = (int)(screenHeight * 0.07); // 🔹 lebih rapat dari sebelumnya (0.12 → 0.07)

  String[] labels = { "MULAI", "CARA BERMAIN", "PENGATURAN", "KELUAR" };
  color[] colors = {
    color(0, 212, 255),
    color(255, 215, 0),
    color(160, 160, 160),
    color(255, 107, 107)
  };

  // Hitung total tinggi semua tombol (untuk posisi tengah vertikal)
  int totalHeight = labels.length * buttonHeight + (labels.length - 1) * verticalSpacing;
  int startY = centerY - totalHeight / 2;

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

    for (int i = 0; i < 3; i++) {
      float alpha = 100 * (1 - i * 0.3) * glowAmount;
      fill(0, 255, 200, alpha);
      text("MINI INSANIQUARIUM", screenWidth/2, screenHeight * 0.15 - i*5);
    }

    fill(255);
    text("MINI INSANIQUARIUM", screenWidth/2, screenHeight * 0.15);
    textSize((int)subtitleSize);
    fill(160, 230, 229);
    text("~ Kelola Akuarium Impianmu ~", screenWidth/2, screenHeight * 0.22);

    hint(ENABLE_DEPTH_TEST);
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
    text("CARA BERMAIN", screenWidth/2, modalY + 40);

    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.03));
    textAlign(LEFT);

    float textX = modalX + 30;
    float textY = modalY + 90;
    float lineH = screenHeight * 0.04;

    text("TUJUAN PERMAINAN:", textX, textY);
    textY += lineH;
    text("Beli ikan, beri mereka makan, dan kumpulkan koin untuk memperbesar akuariummu!", textX, textY);
    textY += lineH * 1.3;

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
    text("5. Ikan akan tumbuh besar setelah makan 5 kali!", textX, textY);

    drawBackButton(modalY + modalHeight);

    hint(ENABLE_DEPTH_TEST);
  }

  void drawSettings() {
    hint(DISABLE_DEPTH_TEST);
    fill(0, 0, 0, 150);
    rect(0, 0, screenWidth, screenHeight);

    float modalWidth = screenWidth * 0.7;
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
    text("PENGATURAN", screenWidth/2, modalY + 40);

    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.04));
    textAlign(LEFT);

    float textX = modalX + 40;
    float textY = modalY + 110;
    float lineH = screenHeight * 0.06;

    text("Suara: Aktif", textX, textY);
    textY += lineH;
    text("Kualitas: Tinggi", textX, textY);
    textY += lineH;
    text("Kesulitan: Normal", textX, textY);

    drawBackButton(modalY + modalHeight);

    hint(ENABLE_DEPTH_TEST);
  }

  void drawBackButton(float modalBottomY) {
    backBtnY = modalBottomY - 50;
    backBtnX = screenWidth/2 - backBtnW/2;

    fill(255, 107, 107);
    rect(backBtnX, backBtnY, backBtnW, backBtnH, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("KEMBALI", screenWidth/2, backBtnY + backBtnH/2);
  }

  boolean checkBackButton(float mx, float my) {
    return (mx > backBtnX && mx < backBtnX + backBtnW && my > backBtnY && my < backBtnY + backBtnH);
  }
}

// ==================================
// BUBBLE 3D CLASS
// ==================================

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
    translate(-size/3, -size/3, size/2);
    sphere(size/4);
    popMatrix();
    popMatrix();
  }
}

// ==================================
// MENU 3D BUTTON CLASS
// ==================================

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
    if (isHovered) {
      hoverAmount += 0.1;
    } else {
      hoverAmount -= 0.1;
    }
    hoverAmount = constrain(hoverAmount, 0, 1);
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
    text(label, offsetX + scaledW/2, offsetY + scaledH/2);

    hint(ENABLE_DEPTH_TEST);
  }

  boolean isClicked(float mx, float my) {
    return (mx > x && mx < x + w && my > y && my < y + h);
  }
}
