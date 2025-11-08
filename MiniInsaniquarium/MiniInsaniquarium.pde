import processing.sound.*; // Mengimpor library Processing Sound untuk mengelola file audio.
SoundFile suaraPlop; // Mendeklarasikan variabel untuk menyimpan file suara 'plop' (saat memberi makan).
SoundFile suaraKoin; // Mendeklarasikan variabel untuk menyimpan file suara 'coin' (saat mengambil koin).
SoundFile suaraBeli; // Mendeklarasikan variabel untuk menyimpan file suara 'purchase' (saat membeli).
SoundFile bgm; // Mendeklarasikan variabel untuk menyimpan file suara 'background music'.

ArrayList<Ikan> daftarIkan = new ArrayList<Ikan>(); // Membuat daftar (ArrayList) untuk menyimpan semua objek Ikan.
ArrayList<MakananIkan> MakananIkanIkan = new ArrayList<MakananIkan>(); // Membuat daftar untuk menyimpan semua objek MakananIkan.
ArrayList<Koin> daftarKoin = new ArrayList<Koin>(); // Membuat daftar untuk menyimpan semua objek Koin.

int uang = 100; // Mendeklarasikan variabel untuk melacak jumlah uang pemain, dimulai dari 100.
int hargaIkan = 50; // Menetapkan harga untuk membeli satu ikan baru (50 koin).
int hargaGantiBg = 300; // Menetapkan harga untuk mengganti background (300 koin).

PImage bg; // Mendeklarasikan variabel untuk menyimpan gambar background yang sedang aktif.
MenuSystem menuScreen; // Mendeklarasikan variabel untuk objek MenuSystem (layar menu utama).

int levelMakananIkan = 1; // Mendeklarasikan variabel untuk level makanan ikan (mungkin mempengaruhi kecepatan jatuhnya).
boolean dekorAktif = false; // Variabel boolean untuk melacak apakah dekorasi tambahan aktif atau tidak.
int bgIndex = 0; // Variabel untuk melacak indeks background yang sedang digunakan dari array.
PImage[] daftarBG; // Mendeklarasikan sebuah array yang akan menyimpan semua gambar background.
enum GameState { // Mendefinisikan tipe data 'GameState' untuk mengelola status permainan.
  MENU, // Status saat berada di menu utama.
  GAMEPLAY, // Status saat sedang bermain.
  HOW_TO_PLAY, // Status saat melihat layar 'Cara Bermain'.
  SETTINGS, // Status saat melihat layar 'Pengaturan'.
  SHOP, // Status saat melihat layar 'Toko' (tidak terpakai di kode ini).
  CONFIRM_EXIT, // Status saat popup konfirmasi keluar muncul.
  GAME_OVER // Status saat permainan berakhir.
}

GameState gameState = GameState.MENU; // Mengatur status permainan awal ke MENU.
GameState stateBeforeConfirm; // Variabel untuk menyimpan status sebelum popup konfirmasi muncul.

float topBarH = 65; // Menetapkan tinggi dari 'top bar' (area UI di atas) ke 65 piksel.
float btnBeliX, btnBeliY, btnBeliW, btnBeliH; // Variabel untuk posisi (x,y) dan ukuran (width, height) tombol 'Beli Ikan'.
float btnGantiBgX, btnGantiBgY, btnGantiBgW, btnGantiBgH; // Variabel untuk posisi dan ukuran tombol 'Ganti BG'.
float btnMenuX, btnMenuY, btnMenuW, btnMenuH; // Variabel untuk posisi dan ukuran tombol 'Menu'.

float goBtnMainLagiX, goBtnMainLagiY, goBtnMenuX, goBtnMenuY, goBtnW, goBtnH; // Variabel untuk tombol di layar Game Over.
color goModalBgColor, goModalBorderColor, goGameOverTextColor, goDescriptionTextColor; // Variabel warna untuk layar Game Over.
color goBtnMainLagiBg, goBtnMainLagiText, goBtnMenuBg, goBtnMenuText; // Variabel warna untuk tombol di layar Game Over.

float cfModalX, cfModalY, cfModalW, cfModalH; // Variabel untuk modal (popup) konfirmasi.
float cfBtnYesX, cfBtnYesY, cfBtnNoX, cfBtnNoY, cfBtnW, cfBtnH; // Variabel untuk tombol 'Ya' dan 'Tidak' di popup konfirmasi.
color cfModalBgColor, cfModalBorderColor, cfTitleTextColor, cfDescTextColor; // Variabel warna untuk popup konfirmasi.
color cfBtnYesBg, cfBtnYesText, cfBtnNoBg, cfBtnNoText; // Variabel warna untuk tombol di popup konfirmasi.

color btnBiru, btnKuning, btnMerah, btnDisabled; // Variabel warna untuk berbagai status tombol.
color borderCerah, borderHover, borderDisabled; // Variabel warna untuk border tombol.
color textDisabled, textCerah; // Variabel warna untuk teks.


void setup() { // Fungsi setup(), dijalankan sekali saat program pertama kali dimulai.
  size(800, 600, P3D); // Mengatur ukuran jendela aplikasi menjadi 800x600 piksel dengan renderer P3D (untuk 3D).

  try { // Memulai blok 'try' untuk menangani error jika file tidak ditemukan.
    daftarBG = new PImage[10]; // Menginisialisasi array 'daftarBG' untuk menampung 10 gambar.
daftarBG[0] = loadImage("img/bg1.png"); // Memuat gambar 'bg1.png' ke indeks 0.
    daftarBG[1] = loadImage("img/bg2.png"); // Memuat gambar 'bg2.png' ke indeks 1.
    daftarBG[2] = loadImage("img/bg3.png"); // Memuat gambar 'bg3.png' ke indeks 2.
    daftarBG[3] = loadImage("img/bg4.jpg"); // Memuat gambar 'bg4.jpg' ke indeks 3.
    daftarBG[4] = loadImage("img/bg5.png"); // Memuat gambar 'bg5.png' ke indeks 4.
    daftarBG[5] = loadImage("img/bg6.png"); // Memuat gambar 'bg6.png' ke indeks 5.
daftarBG[6] = loadImage("img/bg7.png"); // Memuat gambar 'bg7.png' ke indeks 6.
    daftarBG[7] = loadImage("img/bg8.png"); // Memuat gambar 'bg8.png' ke indeks 7.
    daftarBG[8] = loadImage("img/bg9.jpg"); // Memuat gambar 'bg9.jpg' ke indeks 8.
    daftarBG[9] = loadImage("img/bg10.png"); // Memuat gambar 'bg10.png' ke indeks 9.
    bg = daftarBG[0]; // Mengatur background awal (bg) ke gambar di indeks 0.
} catch (Exception e) { // Menangkap error jika terjadi (misal, file tidak ada).
    println("Background image not found - using solid color"); // Mencetak pesan error ke konsol.
    bg = null; // Mengatur background menjadi null (tidak ada) agar bisa digambar warna solid.
}

  menuScreen = new MenuSystem(width, height); // Membuat objek baru dari class MenuSystem.

  try { // Memulai blok 'try' untuk menangani error pemuatan suara.
    suaraPlop = new SoundFile(this, "SE/plop.mp3"); // Memuat file 'plop.mp3'.
suaraKoin = new SoundFile(this, "SE/coin.mp3"); // Memuat file 'coin.mp3'.
    suaraBeli = new SoundFile(this, "SE/purchase.mp3"); // Memuat file 'purchase.mp3'.
    bgm = new SoundFile(this, "SE/bgm_gameplay.mp3"); // Memuat file 'bgm_gameplay.mp3'.
    bgm.loop(); // Memulai memutar background music secara berulang (loop).
} catch (Exception e) { // Menangkap error jika file suara tidak ditemukan.
    println("Audio files not found. Game will run without sound."); // Mencetak pesan error ke konsol.
}

  btnBiru = color(20, 100, 160); // Mengatur nilai warna untuk 'btnBiru'.
  btnKuning = color(200, 160, 0); // Mengatur nilai warna untuk 'btnKuning'.
  btnMerah = color(180, 50, 70); // Mengatur nilai warna untuk 'btnMerah'.
btnDisabled = color(100, 110, 120, 200); // Mengatur nilai warna untuk 'btnDisabled' (sedikit transparan).
  
  borderCerah = color(0, 212, 255); // Mengatur nilai warna untuk 'borderCerah'.
  borderHover = color(255, 255, 255, 200); // Mengatur nilai warna untuk 'borderHover' (putih transparan).
borderDisabled = color(80, 90, 100); // Mengatur nilai warna untuk 'borderDisabled'.
  
  textDisabled = color(180); // Mengatur nilai warna untuk 'textDisabled' (abu-abu).
  textCerah = color(230); // Mengatur nilai warna untuk 'textCerah' (putih keabuan).

  btnMenuW = 90; // Menetapkan lebar tombol Menu.
  btnGantiBgW = 110; // Menetapkan lebar tombol Ganti BG.
  btnBeliW = 110; // Menetapkan lebar tombol Beli Ikan.
btnMenuH = 40; // Menetapkan tinggi tombol Menu.
  btnGantiBgH = 40; // Menetapkan tinggi tombol Ganti BG.
  btnBeliH = 40; // Menetapkan tinggi tombol Beli Ikan.
  goModalBgColor = color(18, 43, 74); // Mengatur warna background modal Game Over.
  goModalBorderColor = color(101, 214, 173); // Mengatur warna border modal Game Over.
goGameOverTextColor = color(224, 108, 117); // Mengatur warna teks judul Game Over.
  goDescriptionTextColor = color(212, 212, 212); // Mengatur warna teks deskripsi Game Over.
  goBtnMainLagiBg = color(101, 214, 173); // Mengatur warna background tombol 'Main Lagi'.
  goBtnMainLagiText = color(30); // Mengatur warna teks tombol 'Main Lagi'.
goBtnMenuBg = color(74, 107, 138); // Mengatur warna background tombol 'Menu' (Game Over).
  goBtnMenuText = color(230); // Mengatur warna teks tombol 'Menu' (Game Over).
  cfModalBgColor = color(18, 43, 74); // Mengatur warna background modal Konfirmasi.
  cfModalBorderColor = color(200, 160, 0); // Mengatur warna border modal Konfirmasi.
cfTitleTextColor = color(230); // Mengatur warna teks judul modal Konfirmasi.
  cfDescTextColor = color(212); // Mengatur warna teks deskripsi modal Konfirmasi.
  cfBtnYesBg = color(180, 50, 70); // Mengatur warna background tombol 'Ya'.
  cfBtnYesText = color(230); // Mengatur warna teks tombol 'Ya'.
  cfBtnNoBg = color(74, 107, 138); // Mengatur warna background tombol 'Tidak'.
cfBtnNoText = color(230); // Mengatur warna teks tombol 'Tidak'.

  surface.setResizable(true); // Mengizinkan jendela aplikasi untuk diubah ukurannya oleh pengguna.
  surface.setLocation(200, 100); // Mengatur posisi awal jendela aplikasi di layar (x=200, y=100).
}

void draw() { // Fungsi draw(), dijalankan berulang kali (default 60x per detik).
  background(10, 20, 40); // Menggambar warna background dasar (biru gelap) untuk membersihkan layar.
switch(gameState) { // Memulai struktur 'switch' untuk mengecek nilai 'gameState'.
  case MENU: // Jika gameState adalah MENU:
    drawMenu(); // Panggil fungsi drawMenu().
    break; // Hentikan switch.
  case GAMEPLAY: // Jika gameState adalah GAMEPLAY:
    drawGameplay(); // Panggil fungsi drawGameplay().
    break; // Hentikan switch.
case HOW_TO_PLAY: // Jika gameState adalah HOW_TO_PLAY:
    menuScreen.display(); // Gambar menu utama di belakang.
    menuScreen.drawHowToPlay(); // Gambar layar 'Cara Bermain' di atasnya.
    break; // Hentikan switch.
  case SETTINGS: // Jika gameState adalah SETTINGS:
    menuScreen.display(); // Gambar menu utama di belakang.
    menuScreen.drawSettings(); // Gambar layar 'Pengaturan' di atasnya.
    break; // Hentikan switch.
case CONFIRM_EXIT: // Jika gameState adalah CONFIRM_EXIT:
    if (stateBeforeConfirm == GameState.GAMEPLAY) drawGameplay(); // Jika sebelumnya di gameplay, gambar gameplay di belakang.
else if (stateBeforeConfirm == GameState.HOW_TO_PLAY) { // Jika sebelumnya di 'Cara Bermain':
      menuScreen.display(); // Gambar menu.
      menuScreen.drawHowToPlay(); // Gambar layar 'Cara Bermain'.
} else if (stateBeforeConfirm == GameState.SETTINGS) { // Jika sebelumnya di 'Pengaturan':
      menuScreen.display(); // Gambar menu.
      menuScreen.drawSettings(); // Gambar layar 'Pengaturan'.
} else if (stateBeforeConfirm == GameState.SHOP) { // Jika sebelumnya di 'Toko':
      menuScreen.display(); // Gambar menu.
    }
    drawConfirmPopup(); // Gambar popup konfirmasi di atas semuanya.
    break; // Hentikan switch.
case GAME_OVER: // Jika gameState adalah GAME_OVER:
    drawGameplay(); // Gambar gameplay (yang sudah berakhir) di belakang.
    drawGameOverScreen(); // Gambar layar Game Over di atasnya.
    break; // Hentikan switch.
  }
}

void drawMenu() { // Fungsi untuk menggambar menu utama.
  menuScreen.display(); // Memanggil metode 'display' dari objek menuScreen.
}

void drawGameplay() { // Fungsi untuk menggambar layar permainan utama.
  lights(); // Menyalakan pencahayaan default (diperlukan jika menggunakan P3D).
if (bg != null) image(bg, 0, 0, width, height); // Jika gambar 'bg' ada, gambar di layar (penuh).
  else background(20, 40, 80); // Jika tidak, gambar background warna solid (biru).

  if (dekorAktif) { // Jika 'dekorAktif' bernilai true:
    drawDekorasiKecil(); // Panggil fungsi untuk menggambar dekorasi tambahan.
}

  // Draw MakananIkan
  for (int i = MakananIkanIkan.size() - 1; i >= 0; i--) { // Loop mundur melalui daftar MakananIkanIkan.
    if (i < MakananIkanIkan.size()) { // Cek keamanan (meskipun loop mundur sudah aman).
      MakananIkan m = MakananIkanIkan.get(i); // Ambil objek makanan di indeks 'i'.
m.jatuh(levelMakananIkan); // Panggil metode 'jatuh' pada makanan (dengan parameter level).
      m.tampil(); // Panggil metode 'tampil' untuk menggambar makanan.
      if (m.pos.y > height) MakananIkanIkan.remove(i); // Jika makanan keluar layar (di bawah), hapus dari daftar.
    }
  }

  // Manage Ikan
  for (int i = daftarIkan.size() - 1; i >= 0; i--) { // Loop mundur melalui daftarIkan.
    if (i < daftarIkan.size()) { // Cek keamanan.
      Ikan ikan = daftarIkan.get(i); // Ambil objek ikan di indeks 'i'.
ikan.update(); // Panggil metode 'update' (logika gerak, lapar, dll).
      ikan.tampil(); // Panggil metode 'tampil' untuk menggambar ikan.
      ikan.findFood(MakananIkanIkan); // Panggil metode 'findFood' (AI untuk mencari makan).
      if (!ikan.isAlive && ikan.alpha <= 0) daftarIkan.remove(i); // Jika ikan mati DAN animasinya selesai (alpha=0), hapus.
}
  }
  
  //Manage Koin
  for (int i = daftarKoin.size() - 1; i >= 0; i--) { // Loop mundur melalui daftarKoin.
    if (i < daftarKoin.size()) { // Cek keamanan.
      Koin k = daftarKoin.get(i); // Ambil objek koin di indeks 'i'.
k.tampil(); // Panggil metode 'tampil' untuk menggambar koin.
      k.jatuh(); // Panggil metode 'jatuh' (logika gerak koin).
      if (k.pos.y > height) daftarKoin.remove(i); // Jika koin keluar layar (di bawah), hapus.
    }
  }

  hint(DISABLE_DEPTH_TEST); // Mematikan 'depth test' agar UI 2D bisa digambar di atas 3D.
  perspective(); // Mengatur ulang perspektif (mungkin tidak perlu di sini).

  drawTopBar(); // Panggil fungsi untuk menggambar UI di bagian atas.

  hint(ENABLE_DEPTH_TEST); // Menyalakan kembali 'depth test'.
if (gameState == GameState.GAMEPLAY && daftarIkan.isEmpty() && uang < hargaIkan) { // Cek kondisi Game Over:
    // (Jika sedang gameplay, DAN tidak ada ikan, DAN uang tidak cukup beli ikan baru)
    gameState = GameState.GAME_OVER; // Ubah status permainan ke GAME_OVER.
}
}

void drawDekorasiKecil() { // Fungsi untuk menggambar dekorasi (tanaman).
  noStroke(); // Tidak menggunakan garis pinggir.

  float dekorY = topBarH + 20; // Menghitung posisi Y untuk dekorasi (di bawah top bar).

  fill(40, 120, 60, 150); // Mengatur warna (hijau tua transparan).
ellipse(60, dekorY + 8, 25, 12); // Menggambar 'batu' (elips).
  fill(60, 200, 80, 180); // Mengatur warna (hijau cerah transparan).
  rect(56, dekorY - 5, 4, 12); // Menggambar 'rumput' (persegi panjang).
rect(64, dekorY - 8, 4, 15); // Menggambar 'rumput' (persegi panjang).

  fill(40, 120, 60, 150); // Warna batu (tengah).
  ellipse(width/2, dekorY + 8, 30, 13); // Gambar batu (tengah).
  fill(60, 200, 80, 180); // Warna rumput (tengah).
rect(width/2 - 12, dekorY - 8, 5, 16); // Gambar rumput (tengah-kiri).
  rect(width/2, dekorY - 10, 5, 18); // Gambar rumput (tengah).
rect(width/2 + 10, dekorY - 7, 5, 15); // Gambar rumput (tengah-kanan).

  if (dekorAktif) { // Jika dekorasi aktif (untuk yang di kanan).
    fill(40, 120, 60, 150); // Warna batu (kanan).
ellipse(width - 60, dekorY + 8, 25, 12); // Gambar batu (kanan).
    fill(60, 200, 80, 180); // Warna rumput (kanan).
    rect(width - 65, dekorY - 5, 4, 12); // Gambar rumput (kanan-kiri).
rect(width - 57, dekorY - 8, 4, 15); // Gambar rumput (kanan-kanan).
  }
}

void drawTopBar() { // Fungsi untuk menggambar UI bar di atas.
  hint(DISABLE_DEPTH_TEST); // Matikan depth test untuk UI 2D.
  perspective(); // Setel ulang perspektif.
  noLights(); // Matikan pencahayaan untuk UI 2D.

  float topBarY = 0; // Posisi Y top bar (di paling atas).
fill(10, 31, 63, 220); // Mengatur warna (biru gelap transparan).
  stroke(borderCerah); // Mengatur warna garis pinggir (cyan).
  strokeWeight(2); // Mengatur ketebalan garis pinggir.
  rect(0, topBarY, width, topBarH, 0, 0, 15, 15); // Gambar kotak top bar (sudut bawah tumpul).

  noStroke(); // Matikan garis pinggir untuk teks dan tombol.

  fill(255, 255, 0); // Mengatur warna (kuning) untuk teks uang.
  textSize(32); // Mengatur ukuran teks uang.
textAlign(LEFT, CENTER); // Mengatur perataan teks (kiri, tengah vertikal).
  text("$" + uang, 20, topBarH / 2 + 5); // Gambar teks uang (misal: "$100").

  fill(textCerah); // Mengatur warna teks default (putih keabuan).
  textSize(11); // Mengatur ukuran teks kecil.
  textAlign(LEFT, CENTER); // Mengatur perataan teks (kiri, tengah).
fill(dekorAktif ? color(100, 255, 100) : color(150)); // (Baris ini tampaknya tidak berpengaruh pada apa pun).


  btnMenuX = width - btnMenuW - 15; // Hitung posisi X tombol Menu (kanan).
btnMenuY = (topBarH - btnMenuH) / 2; // Hitung posisi Y tombol Menu (tengah vertikal).

  boolean hoverMenu = (mouseX > btnMenuX && mouseX < btnMenuX + btnMenuW && // Cek apakah mouse di atas tombol Menu.
    mouseY > btnMenuY && mouseY < btnMenuY + btnMenuH);
if (hoverMenu) { // Jika mouse di atas tombol:
    fill(btnMerah, 240); // Warna merah (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika mouse tidak di atas tombol:
    fill(btnMerah); // Warna merah solid.
    stroke(btnMerah, 255); // Border merah (agar tidak terlihat).
    strokeWeight(1); // Border tipis.
}
  rect(btnMenuX, btnMenuY, btnMenuW, btnMenuH, 8); // Gambar kotak tombol Menu.

  noStroke(); // Matikan border.
  fill(255); // Warna teks (putih).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(14); // Ukuran teks.
text("MENU", btnMenuX + btnMenuW / 2, btnMenuY + btnMenuH / 2); // Gambar teks "MENU".

  btnGantiBgX = btnMenuX - btnGantiBgW - 10; // Hitung posisi X tombol Ganti BG (kiri tombol Menu).
btnGantiBgY = (topBarH - btnGantiBgH) / 2; // Hitung posisi Y tombol Ganti BG.

  boolean hoverGantiBg = (mouseX > btnGantiBgX && mouseX < btnGantiBgX + btnGantiBgW && // Cek hover tombol Ganti BG.
    mouseY > btnGantiBgY && mouseY < btnGantiBgY + btnGantiBgH);
boolean canGantiBg = (uang >= hargaGantiBg); // Cek apakah uang cukup.

  if (!canGantiBg) { // Jika uang tidak cukup:
    fill(btnDisabled); // Warna abu-abu (disabled).
    stroke(borderDisabled); // Border abu-abu gelap.
    strokeWeight(1); // Border tipis.
} else if (hoverGantiBg) { // Jika uang cukup DAN di-hover:
    fill(btnKuning, 240); // Warna kuning (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika uang cukup dan tidak di-hover:
    fill(btnKuning); // Warna kuning solid.
stroke(btnKuning, 255); // Border kuning (tidak terlihat).
    strokeWeight(1); // Border tipis.
  }
  rect(btnGantiBgX, btnGantiBgY, btnGantiBgW, btnGantiBgH, 8); // Gambar kotak tombol Ganti BG.

  noStroke(); // Matikan border.
  fill(canGantiBg ? 255 : textDisabled); // Warna teks (putih jika bisa, abu-abu jika tidak).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(13); // Ukuran teks.
text("GANTI BG", btnGantiBgX + btnGantiBgW / 2, btnGantiBgY + 12); // Gambar teks "GANTI BG" (agak ke atas).
  textSize(11); // Ukuran teks kecil (untuk harga).
  fill(canGantiBg ? color(220) : textDisabled); // Warna teks harga.
text("(" + hargaGantiBg + "$)", btnGantiBgX + btnGantiBgW / 2, btnGantiBgY + 28); // Gambar teks harga (agak ke bawah).


  btnBeliX = btnGantiBgX - btnBeliW - 10; // Hitung posisi X tombol Beli Ikan (kiri tombol Ganti BG).
btnBeliY = (topBarH - btnBeliH) / 2; // Hitung posisi Y tombol Beli Ikan.

  boolean hoverBeliIkan = (mouseX > btnBeliX && mouseX < btnBeliX + btnBeliW && // Cek hover tombol Beli Ikan.
    mouseY > btnBeliY && mouseY < btnBeliY + btnBeliH);
boolean canBeliIkan = (uang >= hargaIkan); // Cek apakah uang cukup.

  if (!canBeliIkan) { // Jika uang tidak cukup:
    fill(btnDisabled); // Warna abu-abu (disabled).
    stroke(borderDisabled); // Border abu-abu gelap.
    strokeWeight(1); // Border tipis.
} else if (hoverBeliIkan) { // Jika uang cukup DAN di-hover:
    fill(btnBiru, 240); // Warna biru (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika uang cukup dan tidak di-hover:
    fill(btnBiru); // Warna biru solid.
stroke(btnBiru, 255); // Border biru (tidak terlihat).
    strokeWeight(1); // Border tipis.
  }
  rect(btnBeliX, btnBeliY, btnBeliW, btnBeliH, 8); // Gambar kotak tombol Beli Ikan.

  noStroke(); // Matikan border.
  fill(canBeliIkan ? 255 : textDisabled); // Warna teks (putih jika bisa, abu-abu jika tidak).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(13); // Ukuran teks.
text("BELI IKAN", btnBeliX + btnBeliW / 2, btnBeliY + 12); // Gambar teks "BELI IKAN" (agak ke atas).
  textSize(11); // Ukuran teks kecil (untuk harga).
  fill(canBeliIkan ? color(220) : textDisabled); // Warna teks harga.
text("(" + hargaIkan + "$)", btnBeliX + btnBeliW / 2, btnBeliY + 28); // Gambar teks harga (agak ke bawah).


  hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
  lights(); // Nyalakan kembali pencahayaan.
}
 
void drawConfirmPopup() { // Fungsi untuk menggambar popup konfirmasi keluar.
  hint(DISABLE_DEPTH_TEST); // Matikan depth test.
  noLights(); // Matikan pencahayaan.
  perspective(); // Setel ulang perspektif.

  // Latar belakang gelap transparan
  fill(0, 0, 0, 200); // Warna hitam transparan (200 dari 255 alpha).
rect(0, 0, width, height); // Gambar kotak menutupi seluruh layar.

  // Kalkulasi Ukuran & Posisi Modal
  cfModalW = width * 0.6; // Lebar modal 60% dari lebar layar.
cfModalH = height * 0.4; // Tinggi modal 40% dari tinggi layar.
  cfModalX = (width - cfModalW) / 2; // Posisi X modal (di tengah).
  cfModalY = (height - cfModalH) / 2; // Posisi Y modal (di tengah).
// Latar belakang modal
  fill(cfModalBgColor); // Warna background modal (biru gelap).
  stroke(cfModalBorderColor); // Warna border modal (kuning).
  strokeWeight(3); // Tebal border.
  rect(cfModalX, cfModalY, cfModalW, cfModalH, 20); // Gambar kotak modal (sudut tumpul).
// === Pengaturan Posisi (Y) ===
  float titleY = cfModalY + 50; // Posisi Y untuk judul.
  float descY = titleY + 45; // Posisi Y untuk deskripsi (di bawah judul).
float buttonY = descY + 60; // Posisi Y untuk tombol (di bawah deskripsi).

  // Teks Judul
  fill(cfTitleTextColor); // Warna teks judul (putih keabuan).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(26); // Ukuran teks judul.
text("Kembali ke Menu?", width / 2, titleY); // Gambar teks judul.

  // Teks Deskripsi
  fill(cfDescTextColor); // Warna teks deskripsi (putih keabuan).
  textSize(17); // Ukuran teks deskripsi.
text("Anda yakin ingin keluar dari permainan?", width / 2, descY); // Gambar teks deskripsi.
// Pengaturan Tombol
  cfBtnW = (cfModalW / 2) - 70; // Lebar tombol (setengah modal dikurangi padding).
  cfBtnH = 45; // Tinggi tombol.
// Dibuat 45px
  cfBtnYesX = cfModalX + 50; // Posisi X tombol 'Ya' (kiri).
  cfBtnYesY = buttonY; // Posisi Y tombol 'Ya'.
cfBtnNoX = cfModalX + cfModalW - cfBtnW - 50; // Posisi X tombol 'Tidak' (kanan).
  cfBtnNoY = buttonY; // Posisi Y tombol 'Tidak'.
boolean hoverYes = (mouseX > cfBtnYesX && mouseX < cfBtnYesX + cfBtnW && // Cek hover tombol 'Ya'.
    mouseY > cfBtnYesY && mouseY < cfBtnYesY + cfBtnH);
if (hoverYes) { // Jika tombol 'Ya' di-hover:
    fill(cfBtnYesBg, 220); // Warna merah (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika tidak di-hover:
    fill(cfBtnYesBg); // Warna merah solid.
    noStroke(); // Tidak ada border.
}
  rect(cfBtnYesX, cfBtnYesY, cfBtnW, cfBtnH, 12); // Gambar kotak tombol 'Ya'.
  fill(cfBtnYesText); // Warna teks tombol 'Ya' (putih keabuan).
  textSize(16); // Ukuran teks tombol.
  text("YA, KEMBALI", cfBtnYesX + cfBtnW / 2, cfBtnYesY + cfBtnH / 2); // Gambar teks "YA, KEMBALI".
boolean hoverNo = (mouseX > cfBtnNoX && mouseX < cfBtnNoX + cfBtnW && // Cek hover tombol 'Tidak'.
    mouseY > cfBtnNoY && mouseY < cfBtnNoY + cfBtnH);
if (hoverNo) { // Jika tombol 'Tidak' di-hover:
    fill(cfBtnNoBg, 220); // Warna biru abu-abu (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika tidak di-hover:
    fill(cfBtnNoBg); // Warna biru abu-abu solid.
    noStroke(); // Tidak ada border.
}
  rect(cfBtnNoX, cfBtnNoY, cfBtnW, cfBtnH, 12); // Gambar kotak tombol 'Tidak'.
  fill(cfBtnNoText); // Warna teks tombol 'Tidak' (putih keabuan).
  text("TIDAK, BATAL", cfBtnNoX + cfBtnW / 2, cfBtnNoY + cfBtnH / 2); // Gambar teks "TIDAK, BATAL".
hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
}

void drawGameOverScreen() { // Fungsi untuk menggambar layar Game Over.
  hint(DISABLE_DEPTH_TEST); // Matikan depth test.
  noLights(); // Matikan pencahayaan.
  perspective(); // Setel ulang perspektif.

  fill(0, 0, 0, 200); // Latar belakang hitam transparan.
  rect(0, 0, width, height); // Gambar kotak menutupi layar.
float modalWidth = width * 0.7; // Lebar modal 70% dari layar.
  float modalHeight = height * 0.45; // Tinggi modal 45% dari layar.
  float modalX = (width - modalWidth) / 2; // Posisi X modal (tengah).
float modalY = (height - modalHeight) / 2; // Posisi Y modal (tengah).

  // Latar belakang modal
  fill(goModalBgColor); // Warna background modal (biru gelap).
  stroke(goModalBorderColor); // Warna border modal (hijau).
  strokeWeight(3); // Tebal border.
rect(modalX, modalY, modalWidth, modalHeight, 20); // Gambar kotak modal.
  float paddingAtas = 60; // Jarak dari atas modal ke judul.
  float spasiAntarElemen = 60; // Jarak antar elemen (Judul -> Deskripsi -> Tombol).
// Jarak antar elemen (Judul -> Deskripsi -> Tombol)

  goBtnH = 50; // Tinggi tombol di layar Game Over.
  float titleY = modalY + paddingAtas; // Posisi Y judul.
float descY = titleY + spasiAntarElemen; // Posisi Y deskripsi.
  float buttonY = descY + spasiAntarElemen; // Posisi Y tombol.
// Tombol akan *dimulai* dari posisi ini

  fill(goGameOverTextColor); // Warna teks judul (merah).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(36); // Ukuran teks judul.
  text("GAME OVER", width / 2, titleY); // Gambar teks "GAME OVER".


  fill(goDescriptionTextColor); // Warna teks deskripsi (putih keabuan).
textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
  textSize(18); // Ukuran teks deskripsi.
  text("Semua ikanmu telah tiada...", width / 2, descY); // Gambar teks deskripsi.

  goBtnW = (modalWidth / 2) - 70; // Lebar tombol (setengah modal dikurangi padding).
goBtnMainLagiX = modalX + 50; // Posisi X tombol 'Main Lagi' (kiri).
  goBtnMainLagiY = buttonY; // Posisi Y tombol 'Main Lagi'.
  
  goBtnMenuX = modalX + modalWidth - goBtnW - 50; // Posisi X tombol 'Menu Utama' (kanan).
  goBtnMenuY = buttonY; // Posisi Y tombol 'Menu Utama'.
boolean hoverMainLagi = (mouseX > goBtnMainLagiX && mouseX < goBtnMainLagiX + goBtnW && // Cek hover 'Main Lagi'.
    mouseY > goBtnMainLagiY && mouseY < goBtnMainLagiY + goBtnH);
if (hoverMainLagi) { // Jika di-hover:
    fill(goBtnMainLagiBg, 220); // Warna hijau (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika tidak di-hover:
    fill(goBtnMainLagiBg); // Warna hijau solid.
    noStroke(); // Tidak ada border.
}
  rect(goBtnMainLagiX, goBtnMainLagiY, goBtnW, goBtnH, 12); // Gambar kotak tombol 'Main Lagi'.
  fill(goBtnMainLagiText); // Warna teks 'Main Lagi' (gelap).
  textSize(16); // Ukuran teks tombol.
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
text("MAIN LAGI", goBtnMainLagiX + goBtnW / 2, goBtnMainLagiY + goBtnH / 2); // Gambar teks "MAIN LAGI".
boolean hoverMenuUtama = (mouseX > goBtnMenuX && mouseX < goBtnMenuX + goBtnW && // Cek hover 'Menu Utama'.
    mouseY > goBtnMenuY && mouseY < goBtnMenuY + goBtnH);
if (hoverMenuUtama) { // Jika di-hover:
    fill(goBtnMenuBg, 220); // Warna biru abu-abu (hover, transparan).
    stroke(borderHover); // Border putih (hover).
    strokeWeight(2); // Border tebal.
  } else { // Jika tidak di-hover:
    fill(goBtnMenuBg); // Warna biru abu-abu solid.
    noStroke(); // Tidak ada border.
}
  rect(goBtnMenuX, goBtnMenuY, goBtnW, goBtnH, 12); // Gambar kotak tombol 'Menu Utama'.
  fill(goBtnMenuText); // Warna teks 'Menu Utama' (putih keabuan).
  textAlign(CENTER, CENTER); // Perataan teks (tengah, tengah).
// Pastikan Text Align untuk tombol
  text("MENU UTAMA", goBtnMenuX + goBtnW / 2, goBtnMenuY + goBtnH / 2); // Gambar teks "MENU UTAMA".

  hint(ENABLE_DEPTH_TEST); // Nyalakan kembali depth test.
}


void mousePressed() { // Fungsi yang dijalankan sekali setiap kali mouse diklik.
   if (gameState == GameState.MENU) { // Jika sedang di MENU:
    int buttonClicked = menuScreen.checkButtonClick(mouseX, mouseY); // Cek apakah tombol menu diklik.
if (buttonClicked == 1) { // Jika tombol "MULAI" (ID=1) diklik:
      gameState = GameState.GAMEPLAY; // Ubah status ke GAMEPLAY.
      uang = 500; // Atur ulang uang ke 500.
      daftarIkan.clear(); // Kosongkan daftar ikan.
      MakananIkanIkan.clear(); // Kosongkan daftar makanan.
      daftarKoin.clear(); // Kosongkan daftar koin.
dekorAktif = false; // Nonaktifkan dekorasi.
      levelMakananIkan = 1; // Atur ulang level makanan.
    } else if (buttonClicked == 2) gameState = GameState.HOW_TO_PLAY; // Jika tombol "CARA BERMAIN" (ID=2) diklik.
else if (buttonClicked == 3) gameState = GameState.SETTINGS; // Jika tombol "PENGATURAN" (ID=3) diklik.
    else if (buttonClicked == 4) { // Jika tombol "KELUAR" (ID=4) diklik:
  if (bgm != null) bgm.stop(); // Hentikan musik jika ada.
if (suaraPlop != null) suaraPlop.stop(); // Hentikan suara plop jika ada.
  if (suaraKoin != null) suaraKoin.stop(); // Hentikan suara koin jika ada.
  if (suaraBeli != null) suaraBeli.stop(); // Hentikan suara beli jika ada.
  noLoop(); // Hentikan draw loop.
  exit(); // Tutup aplikasi.
}
    return; // Keluar dari fungsi mousePressed().
  }
  if (gameState == GameState.HOW_TO_PLAY) { // Jika sedang di 'Cara Bermain':
    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU; // Cek tombol kembali.
return; // Keluar.
  }

  if (gameState == GameState.SETTINGS) { // Jika sedang di 'Pengaturan':
    if (menuScreen.checkMuteButton(mouseX, mouseY)) { // Cek tombol Mute.
      menuScreen.toggleMute(); // Panggil fungsi toggleMute.
return; // Keluar.
    }
    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU; // Cek tombol kembali.
    return; // Keluar.
}

  if (gameState == GameState.SHOP) { // Jika sedang di 'Toko' (tidak terpakai):
    int itemClicked = menuScreen.checkShopItemClick(mouseX, mouseY); // Cek item toko.
if (itemClicked == 1) { // Jika item 1 diklik:
      if (uang >= 100) { // Cek uang.
        uang -= 100; // Kurangi uang.
levelMakananIkan++; // Naikkan level makanan.
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli.
      }
    } else if (itemClicked == 2) { // Jika item 2 diklik:
      if (uang >= 200) { // Cek uang.
        uang -= 200; // Kurangi uang.
dekorAktif = true; // Aktifkan dekorasi.
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli.
      }
    } else if (itemClicked == 3) { // Jika item 3 diklik:
      if (uang >= hargaGantiBg) { // Cek uang (harga ganti bg).
        uang -= hargaGantiBg; // Kurangi uang.
bgIndex = (bgIndex + 1) % daftarBG.length; // Pindah ke background berikutnya (looping).
        if (daftarBG != null && bgIndex < daftarBG.length) { // Cek keamanan array.
          bg = daftarBG[bgIndex]; // Terapkan background baru.
}
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli.
}
    }

    if (menuScreen.checkBackButton(mouseX, mouseY)) gameState = GameState.MENU; // Cek tombol kembali.
    return; // Keluar.
}
  if (gameState == GameState.CONFIRM_EXIT) { // Jika sedang di popup konfirmasi:
    if (mouseX > cfBtnYesX && mouseX < cfBtnYesX + cfBtnW && // Cek apakah tombol 'Ya' diklik.
      mouseY > cfBtnYesY && mouseY < cfBtnYesY + cfBtnH) {
      gameState = GameState.MENU; // Kembali ke MENU.
return; // Keluar.
    }
    if (mouseX > cfBtnNoX && mouseX < cfBtnNoX + cfBtnW && // Cek apakah tombol 'Tidak' diklik.
      mouseY > cfBtnNoY && mouseY < cfBtnNoY + cfBtnH) {
      gameState = stateBeforeConfirm; // Kembali ke status permainan sebelumnya.
return; // Keluar.
    }
  }

  if (gameState == GameState.GAME_OVER) { // Jika sedang di layar Game Over:
    if (mouseX > goBtnMainLagiX && mouseX < goBtnMainLagiX + goBtnW && // Cek tombol 'Main Lagi'.
      mouseY > goBtnMainLagiY && mouseY < goBtnMainLagiY + goBtnH) {
      uang = 500; // Atur ulang uang.
// Mulai lagi dengan uang 500
      daftarIkan.clear(); // Kosongkan daftar ikan.
      MakananIkanIkan.clear(); // Kosongkan daftar makanan.
      daftarKoin.clear(); // Kosongkan daftar koin.
      dekorAktif = false; // Matikan dekorasi.
      levelMakananIkan = 1; // Atur ulang level makanan.
gameState = GameState.GAMEPLAY; // Mulai GAMEPLAY baru.
      return; // Keluar.
    }
    if (mouseX > goBtnMenuX && mouseX < goBtnMenuX + goBtnW && // Cek tombol 'Menu Utama'.
      mouseY > goBtnMenuY && mouseY < goBtnMenuY + goBtnH) {
      gameState = GameState.MENU; // Kembali ke MENU.
return; // Keluar.
    }
    return; // Keluar (jika klik di luar tombol).
  }

  if (gameState == GameState.GAMEPLAY) { // Jika sedang GAMEPLAY:
    if (mouseX > btnMenuX && mouseX < btnMenuX + btnMenuW && // Cek tombol 'Menu' di top bar.
      mouseY > btnMenuY && mouseY < btnMenuY + btnMenuH) {
      stateBeforeConfirm = GameState.GAMEPLAY; // Simpan status saat ini.
gameState = GameState.CONFIRM_EXIT; // Tampilkan popup konfirmasi.
      return; // Keluar.
    }
    if (mouseX > btnBeliX && mouseX < btnBeliX + btnBeliW && // Cek tombol 'Beli Ikan'.
      mouseY > btnBeliY && mouseY < btnBeliY + btnBeliH) {
      if (uang >= hargaIkan) { // Jika uang cukup:
        uang -= hargaIkan; // Kurangi uang.
daftarIkan.add(new Ikan(random(100, width-100), random(topBarH + 50, height-100))); // Tambah ikan baru di posisi acak.
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli.
      }
      return; // Keluar (agar tidak jatuhkan makanan).
}
    if (mouseX > btnGantiBgX && mouseX < btnGantiBgX + btnGantiBgW && // Cek tombol 'Ganti BG'.
      mouseY > btnGantiBgY && mouseY < btnGantiBgY + btnGantiBgH) {
      if (uang >= hargaGantiBg) { // Jika uang cukup:
        uang -= hargaGantiBg; // Kurangi uang.
bgIndex = (bgIndex + 1) % daftarBG.length; // Pindah ke background berikutnya (looping).
        if (daftarBG != null && bgIndex < daftarBG.length) { // Cek keamanan array.
          bg = daftarBG[bgIndex]; // Terapkan background baru.
}
        if (suaraBeli != null) suaraBeli.play(); // Mainkan suara beli.
      }
      return; // Keluar (agar tidak jatuhkan makanan).
}
    for (int i = daftarKoin.size() - 1; i >= 0; i--) { // Loop mundur daftar koin (untuk mengambil koin).
      if (i < daftarKoin.size()) { // Cek keamanan.
        Koin k = daftarKoin.get(i); // Ambil koin.
if (dist(mouseX, mouseY, k.pos.x, k.pos.y) < k.ukuran / 2) { // Cek jarak mouse ke koin (klik).
          uang += k.nilai; // Tambah uang.
daftarKoin.remove(i); // Hapus koin dari daftar.
          if (suaraKoin != null) suaraKoin.play(); // Mainkan suara koin.
          return; // Keluar (agar tidak jatuhkan makanan setelah ambil koin).
        }
      }
    }
    if (mouseY > topBarH) { // Jika klik di bawah top bar (dan tidak kena tombol/koin):
      MakananIkanIkan.add(new MakananIkan(mouseX, mouseY)); // Tambah makanan baru di posisi mouse.
if (suaraPlop != null) suaraPlop.play(); // Mainkan suara plop.
    }
  }
}
