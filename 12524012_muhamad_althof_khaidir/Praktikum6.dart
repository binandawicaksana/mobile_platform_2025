import 'dart:math';
import 'dart:io';

// Kelas abstrak untuk Bangun Datar
abstract class BangunDatar {
  double hitungLuas();
  void tampilkanLuas() {
    print("Luas bangun datar: ${hitungLuas()}");
  }
}

// Kelas Persegi Panjang
class PersegiPanjang extends BangunDatar {
  double panjang;
  double lebar;

  PersegiPanjang(this.panjang, this.lebar);

  @override
  double hitungLuas() => panjang * lebar;
}

// Kelas Segitiga
class Segitiga extends BangunDatar {
  double alas;
  double tinggi;

  Segitiga(this.alas, this.tinggi);

  @override
  double hitungLuas() => 0.5 * alas * tinggi;
}

// Kelas Lingkaran
class Lingkaran extends BangunDatar {
  double jariJari;

  Lingkaran(this.jariJari);

  @override
  double hitungLuas() => pi * pow(jariJari, 2);
}

void main() {
  while (true) {
    print("\n=== Program Hitung Luas Bangun Datar ===");
    print("1. Persegi Panjang");
    print("2. Segitiga");
    print("3. Lingkaran");
    print("4. Keluar");
    stdout.write("Pilih bangun datar (1-4): ");
    int? pilihan = int.tryParse(stdin.readLineSync()!);

    if (pilihan == 4) {
      print("Program selesai.");
      break;
    }

    switch (pilihan) {
      case 1:
        stdout.write("Masukkan panjang: ");
        double p = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan lebar: ");
        double l = double.parse(stdin.readLineSync()!);
        PersegiPanjang persegiPanjang = PersegiPanjang(p, l);
        print("Luas Persegi Panjang: ${persegiPanjang.hitungLuas()}");
        break;

      case 2:
        stdout.write("Masukkan alas: ");
        double a = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan tinggi: ");
        double t = double.parse(stdin.readLineSync()!);
        Segitiga segitiga = Segitiga(a, t);
        print("Luas Segitiga: ${segitiga.hitungLuas()}");
        break;

      case 3:
        stdout.write("Masukkan jari-jari: ");
        double r = double.parse(stdin.readLineSync()!);
        Lingkaran lingkaran = Lingkaran(r);
        print("Luas Lingkaran: ${lingkaran.hitungLuas()}");
        break;

      default:
        print("Pilihan tidak valid!");
    }
  }
}
