import 'dart:io';

void main() {
  // Input tanggal
  stdout.write("Masukkan tanggal: ");
  var tgl = int.tryParse(stdin.readLineSync()!);

  // Input bulan
  stdout.write("Masukkan bulan: ");
  var bln = int.tryParse(stdin.readLineSync()!);

  // Input tahun
  stdout.write("Masukkan tahun: ");
  var thn = int.tryParse(stdin.readLineSync()!);

  // Jika ada yang bukan angka
  if (tgl == null || bln == null || thn == null) {
    print("Hanya menerima format Angka");
    return; // hentikan program
  }

  // Buat list untuk menampung error
  List<String> errors = [];

  // Validasi tanggal
  if (tgl < 1 || tgl > 31) {
    errors.add("Anda Salah Memasukan Tanggal");
  }

  // Validasi bulan
  if (bln < 1 || bln > 12) {
    errors.add("Anda Salah Memasukan Bulan");
  }

  // Validasi tahun
  if (thn < 1000 || thn > 2999) {
    errors.add("Anda Salah Memasukan Tahun");
  }

  // Tampilkan hasil
  if (errors.isNotEmpty) {
    // Jika ada error, tampilkan semuanya
    for (var e in errors) {
      print(e);
    }
  } else {
    // Jika tidak ada error
    print("[$tgl] - [$bln] - [$thn]");
  }
}
