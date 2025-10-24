import 'dart:io';
import 'dart:math';

// ====================
// KELAS ABSTRAK (INDUK)
// ====================
abstract class BangunDatar {
  double hitungLuas();
  void tampilkanLuas();
}

// ====================
// KELAS PERSEGI PANJANG
// ====================
class PersegiPanjang extends BangunDatar {
  late double panjang;
  late double lebar;

  PersegiPanjang(this.panjang, this.lebar);

  @override
  double hitungLuas() {
    return panjang * lebar;
  }

  @override
  void tampilkanLuas() {
    print("Luas Persegi Panjang = ${hitungLuas()}");
  }
}

// ====================
// KELAS SEGITIGA
// ====================
class Segitiga extends BangunDatar {
  late double alas;
  late double tinggi;

  Segitiga(this.alas, this.tinggi);

  @override
  double hitungLuas() {
    return 0.5 * alas * tinggi;
  }

  @override
  void tampilkanLuas() {
    print("Luas Segitiga = ${hitungLuas()}");
  }
}

// ====================
// KELAS LINGKARAN
// ====================
class Lingkaran extends BangunDatar {
  late double jariJari;

  Lingkaran(this.jariJari);

  @override
  double hitungLuas() {
    return pi * pow(jariJari, 2);
  }

  @override
  void tampilkanLuas() {
    print("Luas Lingkaran = ${hitungLuas().toStringAsFixed(2)}");
  }
}

// ====================
// PROGRAM UTAMA
// ====================
void main() {
  print("=== PROGRAM OOP: HITUNG LUAS BANGUN DATAR ===");

  while (true) {
    print("\nPilih bangun datar yang ingin dihitung:");
    print("1. Persegi Panjang");
    print("2. Segitiga");
    print("3. Lingkaran");
    print("0. Keluar");
    stdout.write("Masukkan pilihan (0-3): ");
    String? pilihan = stdin.readLineSync();

    if (pilihan == '0' || pilihan?.toLowerCase() == 'exit') {
      print("\nTerima kasih! Program dihentikan.");
      break;
    }

    switch (pilihan) {
      case '1':
        stdout.write("Masukkan panjang: ");
        double panjang = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan lebar: ");
        double lebar = double.parse(stdin.readLineSync()!);

        PersegiPanjang pp = PersegiPanjang(panjang, lebar);
        pp.tampilkanLuas();
        break;

      case '2':
        stdout.write("Masukkan alas: ");
        double alas = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan tinggi: ");
        double tinggi = double.parse(stdin.readLineSync()!);

        Segitiga sgt = Segitiga(alas, tinggi);
        sgt.tampilkanLuas();
        break;

      case '3':
        stdout.write("Masukkan jari-jari: ");
        double r = double.parse(stdin.readLineSync()!);

        Lingkaran lkr = Lingkaran(r);
        lkr.tampilkanLuas();
        break;

      default:
        print("⚠️ Pilihan tidak valid! Silakan coba lagi.");
    }
  }
}
