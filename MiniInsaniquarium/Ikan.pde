class Ikan {
  PVector pos;
  PVector vel;
  PVector targetPos;
  float hunger;
  float ukuran;
  boolean isAlive;
  float alpha;
  int makanCount;
  int makanThreshold = 5;
  float ukuranMax = 50;
  boolean useBezier;

  color warnaDasar;
  color warnaEkor;

  Ikan(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    hunger = 50;
    ukuran = 20;
    isAlive = true;
    alpha = 255;
    makanCount = 0;
    useBezier = random(1) < 0.5;

    warnaDasar = color(random(80, 255), random(80, 255), random(80, 255));
    warnaEkor = color(random(80, 255), random(80, 255), random(80, 255));

    setNewRandomTarget();
  }

  void setNewRandomTarget() {
    targetPos = new PVector(random(width), random(height));
  }

  void findFood(ArrayList<MakananIkan> foods) {
    if (!isAlive) return;

    if (hunger < 50 || foods.isEmpty()) {
      if (pos.dist(targetPos) < 15) {
        setNewRandomTarget();
      }
      return;
    }

    MakananIkan closestFood = foods.get(0);
    float minDistance = pos.dist(closestFood.pos);

    for (MakananIkan f : foods) {
      float d = pos.dist(f.pos);
      if (d < minDistance) {
        minDistance = d;
        closestFood = f;
      }
    }

    targetPos = closestFood.pos.copy();

    if (minDistance < ukuran / 2) {
      eat(foods, closestFood);
    }
  }

  void eat(ArrayList<MakananIkan> foods, MakananIkan f) {
  if (!isAlive) return;
  foods.remove(f);
  hunger = 0;
  jatuhkanKoin();
  setNewRandomTarget();
  makanCount++;
  if (makanCount >= makanThreshold && ukuran < ukuranMax) {
    ukuran += 10;
    makanCount = 0;
  }
}

  void jatuhkanKoin() {
    daftarKoin.add(new Koin(pos.x, pos.y, 10));
  }

  void update() {
    if (!isAlive) {
      alpha -= 2;
      alpha = max(alpha, 0);
      return;
    }

    if (hunger >= 100) {
      isAlive = false;
      return;
    }

    float speed = 1.5;
    PVector arah = PVector.sub(targetPos, pos);

    if (arah.mag() < speed) {
      pos = targetPos.copy();
      vel.set(0, 0);
    } else {
      arah.normalize();
      arah.mult(speed);
      vel = arah.copy();
      pos.add(vel);
    }

    hunger += 0.05;
    hunger = constrain(hunger, 0, 100);
  }

  void tampil() {
    if (alpha <= 0) return;
    pushMatrix();
    translate(pos.x, pos.y);

    float angle = atan2(vel.y, vel.x);
    rotate(angle);
    noStroke();

    color tubuh = lerpColor(warnaDasar, color(255, 0, 0), hunger / 100.0);
    fill(tubuh, alpha);
    if (useBezier) {
      beginShape();
      vertex(-ukuran/2, 0);
      bezierVertex(-ukuran/4, -ukuran/3, ukuran/4, -ukuran/3, ukuran/2, 0);
      bezierVertex(ukuran/4, ukuran/3, -ukuran/4, ukuran/3, -ukuran/2, 0);
      endShape(CLOSE);
    } else {
      ellipse(0, 0, ukuran, ukuran * 0.7);
    }

    fill(lerpColor(warnaEkor, color(255, 200, 200), hunger / 120.0), alpha);
    if (useBezier) {
      beginShape();
      vertex(-ukuran/2, 0);
      bezierVertex(-ukuran, -ukuran/4, -ukuran * 1.2, 0, -ukuran, ukuran/4);
      endShape();
    } else {
      triangle(-ukuran/2, 0, -ukuran, -ukuran/3, -ukuran, ukuran/3);
    }

    if (isAlive) {
      fill(0, alpha);
      ellipse(ukuran/4, -ukuran/8, 3, 3);
    } else {
      stroke(0, alpha);
      strokeWeight(1);
      line(ukuran/4 - 1.5, -ukuran/8 - 1.5, ukuran/4 + 1.5, -ukuran/8 + 1.5);
      line(ukuran/4 + 1.5, -ukuran/8 - 1.5, ukuran/4 - 1.5, -ukuran/8 + 1.5);
      noStroke();
    }

    popMatrix();
  }
}
