void main() {
  // list data
  var input = [
    ["0001", "Roman Alamsyah", "Bandar Lampung", "21/05/1989", "Membaca"],
    ["0002", "Dika Sembiring", "Medan", "10/10/1992", "Bermain Gitar"],
    ["0003", "Winona", "Ambon", "25/12/1965", "Memasak"],
    ["0004", "Bintang Senjaya", "Martapura", "6/4/1970", "Berkebun"]
  ];

  input.forEach((data) {

    Map<String, String> biodata = {
      "Nomor ID": data[0],
      "Nama Lengkap": data[1],
      "TTL": "${data[2]} ${data[3]}",
      "Hobi": data[4],
    };
    // hasil
    biodata.forEach((key, value) {
      print("$key: $value");
    });

    print("");
  });
}