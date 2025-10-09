//Slide 5
// void main (){
//   var flag = 1;
//   while(flag < 10) { 
//   print ("iterasi ke"+ flag.toString()); 
//   flag++; // Mengubah nilai flag dengan menambahkan 1
//   } 
// }

//Slide 6
// void main() {
//   var deret = 5;
//   var jumlah = 0;
//   while (deret > 0) {
//     // Loop akan terus berjalan selama nilai deret masih di atas 0
//     jumlah += deret; // Menambahkan nilai variable jumlah dengan angka deret
//     deret--; // Mengubah nilai deret dengan mengurangi 1
//     print('Jumlah saat ini: ' + jumlah.toString());
//   }
//   print(jumlah);
// }

//Slide 8
// void main(){
//  for(var angka = 1; angka < 10; angka++) {
//    print('Iterasi ke-' + angka.toString());
//  } 
// }

//Slide 9
// void main() {
//   var jumlah = 0;
//   for (var deret = 5; deret > 0; deret--) {
//     jumlah += deret;
//     print('Jumlah saat ini: ' + jumlah.toString());
//   }
//   print('Jumlah terakhir: ' + jumlah.toString());
// }

//Slide 10
// void main() {
//   for (var deret = 0; deret < 10; deret += 2) {
//     print('Iterasi dengan Increment counter 2: ' + deret.toString());
//   }
//   print('-------------------------------');
//   for (var deret = 15; deret > 0; deret -= 3) {
//     print('Iterasi dengan Decrement counter : ' + deret.toString());
//   }
// }

//Slide 12
// void main(){  
//   tampilkan();
//   print(munculkanangka());
// }
// tampilkan(){ //tanpa return
//   print("Hello Mahasiswa dan Mahasiswi");
// }
// munculkanangka(){ //dengan return
//   return 2;
// }

//Slide 13
// void main(){
//   print(kalikanDua(6));//12
//   print(kalikan(5,6));//30
// }
// kalikanDua(angka){ // Dengan 1 Parameter
//   return angka * 2;
// }
// kalikan(x, y){ //Dengan 2 Parameter
//   return x * y;
// }

//Slide 14
void main(){
  tampilkanangka(5);
  tampilkanangka(5,s1: 10);//Jika ingin merubah nilai s1
}
tampilkanangka(n1,{s1 = 45}){
  print(n1); //hasil akan 5 karena initialisasi 5 didalam value tampilkan
  print(s1); //hasil adalah 45 karena dari parameter diisi 45 Jika tidak ada nilai baru s1
}

