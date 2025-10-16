
1
void main() {
2
  var input = [
3
    ["0001", "Roman Alamsyah", "Bandar Lampung", "21/05/1989", "Membaca"],
4
    ["0002", "Dika Sembiring", "Medan", "10/10/1992", "Bermain Gitar"],
5
    ["0003", "Winona", "Ambon", "25/12/1965", "Memasak"],
6
    ["0004", "Bintang Senjaya", "Martapura", "6/4/1970", "Berkebun"]
7
  ];
8
​
9
  for (var data in input) {
10
    print("Nomor ID: ${data[0]}");
11
    print("Nama Lengkap: ${data[1]}");
12
    print("TTL: ${data[2]} ${data[3]}");
13
    print("Hobi: ${data[4]}");
14
    print(""); // baris kosong antar data
15
  }
16
}
