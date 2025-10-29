// ==================================
// MENU SYSTEM - 3D Menu (RESPONSIVE)
// ==================================

class MenuSystem {
  int screenWidth, screenHeight;
  ArrayList<Menu3DButton> buttons;
  ArrayList<Bubble3D> bubbles;
  float glowAmount = 0;
  
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
    
    // RESPONSIVE SIZING - Skala sesuai screen size
    int buttonWidth = (int)(screenWidth * 0.3);  // 30% dari screen width
    int buttonHeight = (int)(screenHeight * 0.08); // 8% dari screen height
    
    // RESPONSIVE POSITIONING - Spacing sesuai screen size
    int verticalSpacing = (int)(screenHeight * 0.15); // 15% vertical spacing
    
    buttons.add(new Menu3DButton(
      centerX - buttonWidth/2, 
      centerY - verticalSpacing - verticalSpacing, 
      buttonWidth, 
      buttonHeight, 
      "START GAME", 
      color(0, 212, 255), 
      1
    ));
    
    buttons.add(new Menu3DButton(
      centerX - buttonWidth/2, 
      centerY - verticalSpacing, 
      buttonWidth, 
      buttonHeight, 
      "HOW TO PLAY", 
      color(255, 215, 0), 
      2
    ));
    
    buttons.add(new Menu3DButton(
      centerX - buttonWidth/2, 
      centerY + verticalSpacing, 
      buttonWidth, 
      buttonHeight, 
      "SETTINGS", 
      color(160, 160, 160), 
      3
    ));
    
    buttons.add(new Menu3DButton(
      centerX - buttonWidth/2, 
      centerY + verticalSpacing + verticalSpacing, 
      buttonWidth, 
      buttonHeight, 
      "EXIT", 
      color(255, 107, 107), 
      4
    ));
  }
  
  void initializeBubbles() {
    bubbles = new ArrayList<Bubble3D>();
    for (int i = 0; i < 20; i++) {
      bubbles.add(new Bubble3D(random(screenWidth), random(screenHeight), random(10, 40)));
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
    
    // RESPONSIVE TEXT SIZE
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
    text("~ Manage Your Dream Aquarium ~", screenWidth/2, screenHeight * 0.22);
    
    hint(ENABLE_DEPTH_TEST);
  }
  
  void drawFooter() {
    hint(DISABLE_DEPTH_TEST);
    fill(255, 255, 255, 150);
    textSize(12);
    textAlign(RIGHT);
    text("Made with Processing", screenWidth - 20, screenHeight - 20);
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
    
    // RESPONSIVE MODAL SIZE
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
    text("HOW TO PLAY", screenWidth/2, modalY + 40);
    
    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.03));
    textAlign(LEFT);
    
    float textX = modalX + 30;
    float textY = modalY + 90;
    float lineH = screenHeight * 0.04;
    
    text("GAME OBJECTIVE:", textX, textY);
    textY += lineH;
    text("Buy fish, feed them, and collect coins to expand your aquarium!", textX, textY);
    textY += lineH * 1.3;
    
    text("HOW TO PLAY:", textX, textY);
    textY += lineH;
    text("1. Click 'Beli Ikan' button to buy a fish (costs 50 coins)", textX, textY);
    textY += lineH;
    text("2. Click anywhere in the aquarium to drop food", textX, textY);
    textY += lineH;
    text("3. Fish will automatically eat when hungry", textX, textY);
    textY += lineH;
    text("4. Collect coins dropped by fish to earn more money", textX, textY);
    textY += lineH;
    text("5. Fish grow bigger after eating 5 times!", textX, textY);
    
    // RESPONSIVE BACK BUTTON
    float btnY = modalY + modalHeight - 50;
    float btnWidth = 120;
    float btnHeight = 40;
    fill(255, 107, 107);
    rect(screenWidth/2 - btnWidth/2, btnY, btnWidth, btnHeight, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("BACK", screenWidth/2, btnY + btnHeight/2);
    
    hint(ENABLE_DEPTH_TEST);
  }
  
  void drawSettings() {
    hint(DISABLE_DEPTH_TEST);
    fill(0, 0, 0, 150);
    rect(0, 0, screenWidth, screenHeight);
    
    // RESPONSIVE MODAL SIZE
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
    text("SETTINGS", screenWidth/2, modalY + 40);
    
    fill(224, 224, 224);
    textSize((int)(screenHeight * 0.04));
    textAlign(LEFT);
    
    float textX = modalX + 40;
    float textY = modalY + 110;
    float lineH = screenHeight * 0.06;
    
    text("Sound: Enabled", textX, textY);
    textY += lineH;
    text("Quality: High", textX, textY);
    textY += lineH;
    text("Difficulty: Normal", textX, textY);
    
    // RESPONSIVE BACK BUTTON
    float btnY = modalY + modalHeight - 50;
    float btnWidth = 120;
    float btnHeight = 40;
    fill(255, 107, 107);
    rect(screenWidth/2 - btnWidth/2, btnY, btnWidth, btnHeight, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("BACK", screenWidth/2, btnY + btnHeight/2);
    
    hint(ENABLE_DEPTH_TEST);
  }
  
  boolean checkBackButton(float mx, float my) {
    float btnY = screenHeight - 50;
    float btnWidth = 120;
    float btnHeight = 40;
    return (mx > screenWidth/2 - btnWidth/2 && mx < screenWidth/2 + btnWidth/2 && my > btnY && my < btnY + btnHeight);
  }
}

// ==================================
// BUBBLE 3D CLASS
// ==================================

class Bubble3D {
  float x, y, size, speedY, wobble;
  
  Bubble3D(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.size = s;
    this.speedY = random(0.5, 2);
    this.wobble = random(TWO_PI);
  }
  
  void update() {
    y -= speedY;
    wobble += 0.05;
    x += sin(wobble) * 0.5;
    if (y < -50) {
      y = 800;
      x = random(1000);
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
