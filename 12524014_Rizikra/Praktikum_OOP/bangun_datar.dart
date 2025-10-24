// kelas induk (abstrak)
abstract class BangunDatar {
  double hitungLuas();

  void tampilkanLuas() {
    print("Luas bangun datar: ${hitungLuas()}");
  }
}
