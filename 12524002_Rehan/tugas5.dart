void main() {
  // Contoh input (list multidimensi)
  var input = [
    ["0001", "Roman Alamsyah", "Bandar Lampung", "21/05/1989", "Membaca"],
    ["0002", "Dika Sembiring", "Medan", "10/10/1992", "Bermain Gitar"],
    ["0003", "Winona", "Ambon", "25/12/1965", "Memasak"],
    ["0004", "Bintang Senjaya", "Martapura", "6/4/1970", "Berkebun"]
  ];

  // Loop untuk menampilkan output sesuai format
  for (var data in input) {
    print("Nomor ID: ${data[0]}");
    print("Nama Lengkap: ${data[1]}");
    print("TTL: ${data[2]} ${data[3]}");
    print("Hobi: ${data[4]}");
    print(""); // baris kosong antar data
  }
}
