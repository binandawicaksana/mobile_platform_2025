import 'mahasiswa.dart';

main(List<String> args) {
  var myData01 = new Mahasiswa.nim("A1B01073");
  var myData02 = new Mahasiswa.name("Binanda Wicaksana");
  var myData03 = new Mahasiswa.jurusan("Teknik Informatika");

  print(myData01.nim);
  print(myData02.name);
  print(myData03.jurusan);



}