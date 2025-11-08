class MenuSystem { // Memulai definisi class 'MenuSystem'.
  int screenWidth, screenHeight; // Variabel untuk menyimpan ukuran layar.
  ArrayList<Menu3DButton> buttons; // Daftar untuk menyimpan semua tombol menu.
  ArrayList<Bubble3D> bubbles; // Daftar untuk menyimpan semua gelembung 3D.
  float glowAmount = 0; // Variabel untuk animasi cahaya (glow) pada judul.
float backBtnX, backBtnY, backBtnW = 120, backBtnH = 40; // Variabel untuk tombol "Kembali".
  float muteBtnX, muteBtnY, muteBtnW = 200, muteBtnH = 50; // Variabel untuk tombol "Mute".
boolean isMuted = false; // Variabel status untuk melacak apakah suara dimatikan.
  
  PImage logo; // Variabel untuk menyimpan gambar logo.

  MenuSystem(int w, int h) { // Konstruktor class MenuSystem.
    screenWidth = w; // Simpan lebar layar.
    screenHeight = h; // Simpan tinggi layar.
initializeButtons(); // Panggil fungsi untuk membuat tombol-tombol.
    initializeBubbles(); // Panggil fungsi untuk membuat gelembung.
    
    try { // Coba muat gambar logo.
      logo = loadImage("img/Logo.png"); // Memuat file 'Logo.png'.
} catch (Exception e) { // Jika gagal (file tidak ada):
      println("Gagal memuat file img/Logo.png"); // Cetak pesan error.
      logo = null; // Atur logo ke null.
}
  }

  void initializeButtons() { // Fungsi untuk membuat objek tombol-tombol menu.
    buttons = new ArrayList<Menu3DButton>(); // Buat ArrayList baru (kosong).
   int centerX = screenWidth / 2; // Hitung posisi tengah layar (X).
int centerY = screenHeight / 2 + (int)(screenHeight * 0.15); // Hitung posisi tengah (Y), sedikit ke bawah.
// Aslinya: screenHeight / 2
  
    int buttonWidth = (int)(screenWidth * 0.22); // Lebar tombol (22% lebar layar).
int buttonHeight = (int)(screenHeight * 0.065); // Tinggi tombol (6.5% tinggi layar).
    int verticalSpacing = (int)(screenHeight * 0.055); // Jarak vertikal antar tombol.
String[] labels = { "MULAI", "CARA BERMAIN", "PENGATURAN", "KELUAR" }; // Teks untuk setiap tombol.
color[] colors = { // Warna untuk setiap tombol.
      color(0, 212, 255), // Cyan (Mulai)
      color(255, 215, 0), // Kuning (Cara Bermain)
      color(160, 160, 160), // Abu-abu (Pengaturan)
      color(255, 107, 107) // Merah (Keluar)
    };
int totalHeight = labels.length * buttonHeight + (labels.length - 1) * verticalSpacing; // Hitung total tinggi blok tombol.
int startY = centerY - totalHeight / 2 + (int)(screenHeight * 0.05); // Hitung posisi Y tombol pertama.
for (int i = 0; i < labels.length; i++) { // Loop sebanyak jumlah tombol.
      int y = startY + i * (buttonHeight + verticalSpacing); // Hitung posisi Y untuk tombol ke-'i'.
buttons.add(new Menu3DButton( // Tambahkan tombol baru ke ArrayList 'buttons'.
        centerX - buttonWidth / 2, // Posisi X (tengah).
        y, // Posisi Y.
        buttonWidth, // Lebar.
        buttonHeight, // Tinggi.
        labels[i], // Teks label.
        colors[i], // Warna.
        i + 1 // ID Tombol (1, 2, 3, 4).
        ));
}
  }
  void initializeBubbles() { // Fungsi untuk membuat gelembung.
    bubbles = new ArrayList<Bubble3D>(); // Buat ArrayList baru (kosong).
for (int i = 0; i < 20; i++) { // Buat 20 gelembung.
      bubbles.add(new Bubble3D(random(screenWidth), random(screenHeight), random(10, 40), screenWidth, screenHeight)); // Tambahkan gelembung baru.
}
  }
  void display() { // Fungsi utama untuk menggambar seluruh layar menu.
    updateScreenSize(); // Perbarui ukuran layar (jika di-resize).
    initializeButtons(); // Inisialisasi ulang tombol (agar responsif).
    perspective(); // Atur perspektif 3D.
    lights(); // Nyalakan pencahayaan 3D.
    drawGradientBackground(); // Gambar latar belakang gradien.
for (Bubble3D bubble : bubbles) { // Loop melalui semua gelembung.
      bubble.update(); // Update posisi gelembung.
      bubble.display(); // Gambar gelembung.
    }
    drawLogo(); // Gambar logo.
    drawTitle(); // Gambar judul "MINI INSANIQUARIUM".
for (Menu3DButton btn : buttons) { // Loop melalui semua tombol.
      btn.update(mouseX, mouseY); // Update status hover tombol.
      btn.display(); // Gambar tombol.
    }

    drawFooter(); // Gambar teks footer (v1.0).
}
  void updateScreenSize() { // Fungsi untuk memperbarui variabel ukuran layar.
  screenWidth = width; // Ambil lebar layar saat ini.
  screenHeight = height; // Ambil tinggi layar saat ini.
}


  void drawGradientBackground() { // Fungsi untuk menggambar latar belakang gradien.
    hint(DISABLE_DEPTH_TEST); // Matikan depth test (untuk 2D).
    noLights(); // Matikan pencahayaan (untuk 2D).
for (int y = 0; y < screenHeight; y++) { // Loop untuk setiap baris piksel (y).
      float inter = map(y, 0, screenHeight, 0, 1); // Hitung interpolasi (0 di atas, 1 di bawah).
int topColor = color(10, 31, 63); // Warna biru sangat gelap (atas).
      int midColor = color(26, 77, 122); // Warna biru tengah.
      int botColor = color(13, 59, 102); // Warna biru gelap (bawah).
int c = inter < 0.5 ? lerpColor(topColor, midColor, inter * 2) : lerpColor(midColor, botColor, (inter - 0.5) * 2); // Hitung warna gradien.
stroke(c); // Atur warna garis ke warna gradien 'c'.
      line(0, y, screenWidth, y); // Gambar garis horizontal sepanjang layar.
    }

    hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
    lights(); // Nyalakan kembali pencahayaan.
  }

  void drawTitle() { // Fungsi untuk menggambar judul.
    hint(DISABLE_DEPTH_TEST); // Matikan depth test.
glowAmount = sin(frameCount * 0.02) * 0.5 + 0.5; // Hitung animasi 'glow' (nilai 0-1 bergelombang).
  
    float titleSize = screenHeight * 0.12; // Ukuran teks judul (12% tinggi layar).
float subtitleSize = screenHeight * 0.04; // Ukuran teks sub-judul (4% tinggi layar).
  
    fill(0, 255, 200); // Warna cyan.
    textAlign(CENTER); // Perataan teks tengah.
    textSize((int)titleSize); // Atur ukuran teks judul.
  
    float titleY = screenHeight * 0.30; // Posisi Y judul (30% dari atas).
float subtitleY = screenHeight * 0.37; // Posisi Y sub-judul (37% dari atas).
  
    for (int i = 0; i < 3; i++) { // Loop untuk menggambar efek 'glow'.
      float alpha = 100 * (1 - i * 0.3) * glowAmount; // Hitung transparansi glow.
fill(0, 255, 200, alpha); // Warna cyan transparan.
      text("MINI INSANIQUARIUM", screenWidth / 2, titleY - i * 5); // Gambar teks glow (sedikit di atas).
// Terapkan titleY
    }
  
    fill(255); // Warna putih.
    text("MINI INSANIQUARIUM", screenWidth / 2, titleY); // Gambar teks judul utama (putih).
// Terapkan titleY
    textSize((int)subtitleSize); // Atur ukuran teks sub-judul.
    fill(160, 230, 229); // Warna cyan pucat.
    text("~ Simulasikan Akuarium mu ~", screenWidth / 2, subtitleY); // Gambar teks sub-judul.
// Terapkan subtitleY
  
    hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
  }
  
  void drawLogo() { // Fungsi untuk menggambar logo.
    if (logo == null) { // Jika logo gagal dimuat:
      return; // Hentikan fungsi.
}

   hint(DISABLE_DEPTH_TEST); // Matikan depth test.
    noLights(); // Matikan pencahayaan.

    pushMatrix(); // Simpan sistem koordinat.
    
    imageMode(CENTER); // Atur mode gambar ke CENTER (posisi x,y adalah tengah gambar).
    float logoWidth = 250; // Lebar logo yang diinginkan.
    float logoHeight = logo.height * (logoWidth / logo.width); // Hitung tinggi logo agar rasio terjaga.
// Menjaga rasio aspek

    float logoY = screenHeight * 0.15; // Posisi Y logo (15% dari atas).
   image(logo, screenWidth / 2, logoY, logoWidth, logoHeight); // Gambar logo.
imageMode(CORNER); // Kembalikan mode gambar ke CORNER (default).
    popMatrix(); // Kembalikan sistem koordinat.
    hint(ENABLE_DEPTH_TEST); // Nyalakan depth test.
    lights(); // Nyalakan pencahayaan.
  }

  void drawFooter() { // Fungsi untuk menggambar teks di pojok kanan bawah.
    hint(DISABLE_DEPTH_TEST); // Matikan depth test.
    fill(255, 255, 255, 150); // Warna putih transparan.
    textSize(12); // Ukuran teks kecil.
    textAlign(RIGHT); // Perataan teks kanan.
text("Dibuat dengan Processing", screenWidth - 20, screenHeight - 20); // Teks kredit.
    text("Mini Insaniquarium v1.0", screenWidth - 20, screenHeight - 5); // Teks versi.
    hint(ENABLE_DEPTH_TEST); // Nyalakan depth test.
}

  int checkButtonClick(float mx, float my) { // Fungsi untuk mengecek klik tombol.
    for (Menu3DButton btn : buttons) { // Loop melalui semua tombol.
      if (btn.isClicked(mx, my)) { // Jika tombol ini diklik:
        return btn.id; // Kembalikan ID tombol (1-4).
}
    }
    return 0; // Jika tidak ada tombol diklik, kembalikan 0.
  }

  void drawHowToPlay() { // Fungsi untuk menggambar layar 'Cara Bermain'.
    hint(DISABLE_DEPTH_TEST); // Matikan depth test.
fill(0, 0, 0, 150); // Latar belakang hitam transparan.
    rect(0, 0, screenWidth, screenHeight); // Gambar kotak menutupi layar.

    float modalWidth = screenWidth * 0.85; // Lebar modal 85%.
    float modalHeight = screenHeight * 0.85; // Tinggi modal 85%.
float modalX = (screenWidth - modalWidth) / 2; // Posisi X modal (tengah).
    float modalY = (screenHeight - modalHeight) / 2; // Posisi Y modal (tengah).

    fill(10, 31, 63); // Warna background modal (biru gelap).
stroke(0, 212, 255); // Warna border modal (cyan).
    strokeWeight(3); // Tebal border.
    rect(modalX, modalY, modalWidth, modalHeight, 20); // Gambar kotak modal.

    fill(0, 212, 255); // Warna teks judul (cyan).
    textAlign(CENTER); // Perataan tengah.
    textSize((int)(screenHeight * 0.06)); // Ukuran teks judul.
text("CARA BERMAIN", screenWidth / 2, modalY + 50); // Gambar teks judul.

    fill(224, 224, 224); // Warna teks isi (putih keabuan).
    textSize((int)(screenHeight * 0.03)); // Ukuran teks isi.
    textAlign(LEFT); // Perataan kiri.
float textX = modalX + 40; // Posisi X teks (dengan padding).
    float textY = modalY + 110; // Posisi Y teks awal.
    float lineH = screenHeight * 0.045; // Tinggi baris (jarak antar teks).
text("TUJUAN PERMAINAN:", textX, textY); // Gambar teks.
    textY += lineH; // Pindah ke baris berikutnya.
    text("Beli ikan, beri mereka makan, dan kumpulkan koin!", textX, textY); // Gambar teks.
textY += lineH * 1.5; // Beri spasi ekstra.

    text("LANGKAH BERMAIN:", textX, textY); // Gambar teks.
    textY += lineH; // Pindah baris.
text("1. Klik tombol 'Beli Ikan' untuk membeli ikan (harga 50 koin)", textX, textY); // Gambar teks.
    textY += lineH; // Pindah baris.
text("2. Klik di mana saja di akuarium untuk memberi makan", textX, textY); // Gambar teks.
    textY += lineH; // Pindah baris.
text("3. Ikan akan makan otomatis saat lapar", textX, textY); // Gambar teks.
    textY += lineH; // Pindah baris.
text("4. Ambil koin yang dijatuhkan ikan untuk mendapat uang", textX, textY); // Gambar teks.
    textY += lineH; // Pindah baris.
text("5. Ikan tumbuh besar setelah makan 5 kali!", textX, textY); // Gambar teks.

    drawBackButton(modalY + modalHeight); // Gambar tombol "Kembali".

    hint(ENABLE_DEPTH_TEST); // Nyalakan depth test.
}

  void drawSettings() { // Fungsi untuk menggambar layar 'Pengaturan'.
    drawModal("PENGATURAN", // Panggil fungsi drawModal (generik).
      new String[]{ // Dengan isi teks berikut:
        "Suara: " + (isMuted ? "Nonaktif" : "Aktif"), // Tampilkan status mute.
        "Kualitas: Tinggi", // Teks placeholder.
        "Kesulitan: Normal" // Teks placeholder.
      });
muteBtnX = screenWidth / 2 - muteBtnW / 2; // Hitung posisi X tombol Mute (tengah).
    muteBtnY = screenHeight / 2 + 100; // Hitung posisi Y tombol Mute.
fill(isMuted ? color(255, 107, 107) : color(100, 200, 100)); // Warna tombol (merah jika mute, hijau jika tidak).
    rect(muteBtnX, muteBtnY, muteBtnW, muteBtnH, 10); // Gambar kotak tombol Mute.
    fill(255); // Warna teks (putih).
    textAlign(CENTER, CENTER); // Perataan tengah.
    textSize(20); // Ukuran teks.
text(isMuted ? "Unmute Musik" : "Mute Musik", screenWidth / 2, muteBtnY + muteBtnH / 2); // Gambar teks tombol Mute.

    drawBackButton(screenHeight * 0.9); // Gambar tombol "Kembali".
}

  void drawShopItem(float x, float y, float w, float h, String title, String desc, String price) { // Fungsi (tidak terpakai) untuk item toko.
    fill(40, 80, 120); // Warna background item.
stroke(102, 255, 204); // Warna border item.
    strokeWeight(2); // Tebal border.
    rect(x, y, w, h, 8); // Gambar kotak item.

    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) { // Cek hover.
      fill(60, 120, 160, 100); // Warna overlay hover.
rect(x, y, w, h, 8); // Gambar overlay hover.
    }

    fill(102, 255, 204); // Warna teks judul.
    textAlign(LEFT); // Perataan kiri.
    textSize(14); // Ukuran teks.
text(title, x + 15, y + 20); // Gambar judul item.

    fill(200, 200, 200); // Warna teks deskripsi.
    textSize(12); // Ukuran teks.
    text(desc, x + 15, y + 35); // Gambar deskripsi item.
fill(255, 220, 100); // Warna teks harga.
    textAlign(RIGHT); // Perataan kanan.
    textSize(13); // Ukuran teks.
    text(price, x + w - 15, y + 22); // Gambar harga item.
}

  void drawModal(String title, String[] lines) { // Fungsi generik untuk menggambar modal (popup).
    hint(DISABLE_DEPTH_TEST); // Matikan depth test.
    fill(0, 0, 0, 150); // Latar belakang hitam transparan.
    rect(0, 0, screenWidth, screenHeight); // Gambar kotak menutupi layar.
float modalWidth = screenWidth * 0.8; // Lebar modal 80%.
    float modalHeight = screenHeight * 0.75; // Tinggi modal 75%.
    float modalX = (screenWidth - modalWidth) / 2; // Posisi X modal (tengah).
float modalY = (screenHeight - modalHeight) / 2; // Posisi Y modal (tengah).

    fill(10, 31, 63); // Warna background modal (biru gelap).
    stroke(0, 212, 255); // Warna border modal (cyan).
    strokeWeight(3); // Tebal border.
    rect(modalX, modalY, modalWidth, modalHeight, 20); // Gambar kotak modal.
fill(0, 212, 255); // Warna teks judul (cyan).
    textAlign(CENTER); // Perataan tengah.
    textSize((int)(screenHeight * 0.06)); // Ukuran teks judul.
    text(title, screenWidth / 2, modalY + 50); // Gambar teks judul.

    fill(224, 224, 224); // Warna teks isi (putih keabuan).
    textSize((int)(screenHeight * 0.03)); // Ukuran teks isi.
textAlign(LEFT); // Perataan kiri.

    float textX = modalX + 40; // Posisi X teks (dengan padding).
    float textY = modalY + 120; // Posisi Y teks awal.
    float lineH = screenHeight * 0.045; // Tinggi baris.
for (String line : lines) { // Loop untuk setiap baris teks dalam array 'lines'.
      text(line, textX, textY); // Gambar teks baris.
      textY += lineH; // Pindah ke baris berikutnya.
}

    hint(ENABLE_DEPTH_TEST); // Nyalakan depth test.
  }

  void toggleMute() { // Fungsi untuk membalik status mute.
    isMuted = !isMuted; // Balik nilai boolean (true jadi false, false jadi true).
if (isMuted) { // Jika baru saja di-mute:
      if (bgm != null && bgm.isPlaying()) bgm.stop(); // Hentikan BGM jika sedang main.
} else { // Jika baru saja di-unmute:
      if (bgm != null && !bgm.isPlaying()) bgm.loop(); // Mulai BGM jika sedang tidak main.
}
  }

  boolean checkMuteButton(float mx, float my) { // Fungsi cek klik tombol Mute.
    return (mx > muteBtnX && mx < muteBtnX + muteBtnW && my > muteBtnY && my < muteBtnY + muteBtnH); // Cek area kotak.
}

  void drawBackButton(float modalBottomY) { // Fungsi untuk menggambar tombol "Kembali".
    backBtnW = 140; // Lebar tombol.
    backBtnH = 45; // Tinggi tombol.
backBtnX = screenWidth / 2 - backBtnW / 2; // Posisi X (tengah).
    backBtnY = modalBottomY - backBtnH - 20; // Posisi Y (di atas 'modalBottomY' dengan padding 20).

    fill(255, 107, 107); // Warna tombol (merah).
    stroke(255); // Warna border (putih).
strokeWeight(2); // Tebal border.
    rect(backBtnX, backBtnY, backBtnW, backBtnH, 12); // Gambar kotak tombol.

    fill(255); // Warna teks (putih).
    textAlign(CENTER, CENTER); // Perataan tengah.
    textSize(18); // Ukuran teks.
text("KEMBALI", backBtnX + backBtnW / 2, backBtnY + backBtnH / 2); // Gambar teks "KEMBALI".
}

  boolean checkBackButton(float mx, float my) { // Fungsi cek klik tombol "Kembali".
    return (mx > backBtnX && mx < backBtnX + backBtnW && my > backBtnY && my < backBtnY + backBtnH); // Cek area kotak.
}

  int checkShopItemClick(float mx, float my) { // Fungsi (tidak terpakai) cek klik item toko.
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

    if (mx > itemX && mx < itemX + itemW && my > itemY && my < itemY + itemH) return 1; // Cek item 1.
if (mx > itemX && mx < itemX + itemW && my > itemY + itemSpacing && my < itemY + itemSpacing + itemH) return 2; // Cek item 2.
if (mx > itemX && mx < itemX + itemW && my > itemY + itemSpacing * 2 && my < itemY + itemSpacing * 2 + itemH) return 3; // Cek item 3.
return 0; // Tidak ada item diklik.
  }
}
class Bubble3D { // Memulai definisi class 'Bubble3D'.
  float x, y, size, speedY, wobble; // Variabel untuk gelembung.
  int screenWidth, screenHeight; // Variabel ukuran layar.
Bubble3D(float x, float y, float s, int w, int h) { // Konstruktor Bubble3D.
    this.x = x; // Simpan posisi X.
    this.y = y; // Simpan posisi Y.
this.size = s; // Simpan ukuran.
    this.speedY = random(0.5, 2); // Atur kecepatan naik (Y) acak.
    this.wobble = random(TWO_PI); // Atur nilai awal 'wobble' (goyangan) acak.
    this.screenWidth = w; // Simpan lebar layar.
    this.screenHeight = h; // Simpan tinggi layar.
}

  void update() { // Fungsi update (logika) gelembung.
    y -= speedY; // Gerakkan gelembung ke atas (kurangi Y).
    wobble += 0.05; // Tambah nilai wobble (untuk goyangan).
    x += sin(wobble) * 0.5; // Gerakkan X sedikit ke kiri/kanan (goyangan).
if (y < -50) { // Jika gelembung keluar layar (di atas):
      y = screenHeight + 50; // Atur ulang posisi Y ke bawah layar.
      x = random(screenWidth); // Atur ulang posisi X acak.
}
  }

  void display() { // Fungsi untuk menggambar gelembung.
    pushMatrix(); // Simpan sistem koordinat.
    translate(x, y, 0); // Pindahkan 0,0,0 ke posisi gelembung.
    noStroke(); // Tidak ada garis pinggir.
    fill(255, 255, 255, 60); // Warna putih sangat transparan (badan gelembung).
    sphere(size); // Gambar bola (sphere) 3D.
fill(255, 255, 255, 100); // Warna putih transparan (untuk highlight).
    pushMatrix(); // Simpan sistem koordinat (untuk highlight).
    translate(-size / 3, -size / 3, size / 2); // Pindahkan posisi highlight.
    sphere(size / 4); // Gambar bola kecil (highlight).
    popMatrix(); // Kembalikan sistem koordinat (setelah highlight).
    popMatrix(); // Kembalikan sistem koordinat (setelah gelembung).
}
}

class Menu3DButton { // Memulai definisi class 'Menu3DButton'.
  float x, y, w, h; // Variabel posisi (x,y) dan ukuran (width, height).
  String label; // Teks tombol.
  color baseColor; // Warna tombol.
  int id; // ID unik tombol (1-4).
  boolean isHovered; // Status apakah mouse di atas tombol.
  float hoverAmount; // Variabel animasi hover (0-1).
Menu3DButton(float x, float y, float w, float h, String label, color c, int id) { // Konstruktor.
    this.x = x; // Simpan x.
this.y = y; // Simpan y.
    this.w = w; // Simpan w.
    this.h = h; // Simpan h.
    this.label = label; // Simpan label.
    this.baseColor = c; // Simpan warna.
    this.id = id; // Simpan ID.
this.isHovered = false; // Status awal (tidak di-hover).
    this.hoverAmount = 0; // Animasi awal (0).
  }

  void update(float mx, float my) { // Fungsi update (logika) tombol.
    isHovered = (mx > x && mx < x + w && my > y && my < y + h); // Cek apakah mouse (mx, my) di atas area tombol.
hoverAmount = constrain(hoverAmount + (isHovered ? 0.1 : -0.1), 0, 1); // Animasi hover (naik ke 1 jika hover, turun ke 0 jika tidak).
  }

  void display() { // Fungsi untuk menggambar tombol.
    hint(DISABLE_DEPTH_TEST); // Matikan depth test (untuk 2D).
float scale = 1 + hoverAmount * 0.1; // Hitung skala tombol (membesar sedikit saat hover).
    float scaledW = w * scale; // Lebar tombol (setelah diskala).
    float scaledH = h * scale; // Tinggi tombol (setelah diskala).
float offsetX = x + (w - scaledW) / 2; // Posisi X (agar tetap di tengah saat membesar).
    float offsetY = y + (h - scaledH) / 2; // Posisi Y (agar tetap di tengah saat membesar).
fill(0, 0, 0, 100); // Warna hitam transparan (untuk bayangan).
    rect(offsetX + 5, offsetY + 5, scaledW, scaledH, 15); // Gambar bayangan (sedikit di kanan bawah).

    fill(baseColor); // Atur warna isi ke warna dasar tombol.
stroke(255, 255, 255, 150 + hoverAmount * 105); // Warna border (putih, makin cerah saat hover).
    strokeWeight(3 + hoverAmount * 2); // Tebal border (makin tebal saat hover).
    rect(offsetX, offsetY, scaledW, scaledH, 15); // Gambar kotak tombol utama.
if (isHovered) { // Jika sedang di-hover:
      noFill(); // Tidak ada isi.
      stroke(255, 255, 255, 100 * hoverAmount); // Warna border (putih transparan) untuk 'glow' luar.
      strokeWeight(2); // Tebal border 'glow'.
rect(offsetX - 5, offsetY - 5, scaledW + 10, scaledH + 10, 15); // Gambar kotak 'glow' di luar tombol.
    }

    fill(255); // Warna teks (putih).
    textAlign(CENTER, CENTER); // Perataan tengah.
textSize(16 + hoverAmount * 2); // Ukuran teks (sedikit membesar saat hover).
    text(label, offsetX + scaledW / 2, offsetY + scaledH / 2); // Gambar teks tombol.

    hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
}

  boolean isClicked(float mx, float my) { // Fungsi cek klik (sama dengan cek hover).
    return (mx > x && mx < x + w && my > y && my < y + h); // Cek area kotak.
}
}
