void main() {
  List<Map<String, String>> data = [
    {
      'Nomor ID': '0001',
      'Nama Lengkap': 'Roman Alamsyah',
      'TTL': 'Bandar Lampung 21/05/1989',
      'Hobi': 'Membaca'
    },
    {
      'Nomor ID': '0002',
      'Nama Lengkap': 'Dika Sembiring',
      'TTL': 'Medan 10/10/1992',
      'Hobi': 'Bermain Gitar'
    },
    {
      'Nomor ID': '0003',
      'Nama Lengkap': 'Winona',
      'TTL': 'Ambon 25/12/1965',
      'Hobi': 'Memasak'
    },
    {
      'Nomor ID': '0004',
      'Nama Lengkap': 'Bintang Senjaya',
      'TTL': 'Martapura 6/4/1970',
      'Hobi': 'Berkebun'
    },
  ];

  for (var person in data) {
    print('Nomor ID:  ${person['Nomor ID']}');
    print('Nama Lengkap:  ${person['Nama Lengkap']}');
    print('TTL:  ${person['TTL']}');
    print('Hobi:  ${person['Hobi']}');
    print('');
  }
}

//Daud Zulfikar
//12524020
//Teknik Informatika Semester 3