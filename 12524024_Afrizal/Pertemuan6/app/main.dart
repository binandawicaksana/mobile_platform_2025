import 'dart:io';
import '../models/persegi_panjang.dart';
import '../models/segitiga.dart';
import '../models/lingkaran.dart';

void main() {
  print('✨ Program Perhitungan Luas Bangun Datar ✨');
  var ulang = true;

  while (ulang) {
    print('\nPilih bangun datar:');
    print('1. Persegi Panjang');
    print('2. Segitiga');
    print('3. Lingkaran');
    print('4. Keluar');
    stdout.write('Masukkan pilihan (1-4): ');
    var pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        var pp = PersegiPanjang();
        stdout.write('Masukkan panjang: ');
        pp.panjang = double.parse(stdin.readLineSync()!);
        stdout.write('Masukkan lebar: ');
        pp.lebar = double.parse(stdin.readLineSync()!);
        pp.info();
        break;

      case '2':
        var sg = Segitiga();
        stdout.write('Masukkan alas: ');
        sg.alas = double.parse(stdin.readLineSync()!);
        stdout.write('Masukkan tinggi: ');
        sg.tinggi = double.parse(stdin.readLineSync()!);
        sg.info();
        break;

      case '3':
        var lk = Lingkaran();
        stdout.write('Masukkan jari-jari: ');
        lk.jariJari = double.parse(stdin.readLineSync()!);
        lk.info();
        break;

      case '4':
        ulang = false;
        print('\nTerima kasih sudah menghitung bareng 💫');
        break;

      default:
        print('😅 Pilihan tidak valid, coba lagi ya~');
    }
  }
}
