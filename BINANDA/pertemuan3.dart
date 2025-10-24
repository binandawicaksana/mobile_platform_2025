// void main() {
//   var isThisWahyu = true;
//   if (isThisWahyu) {
//     print("wahyu");
//   } else {
//     print("bukan");
//   }
// }

// void main() {
//   var isThisWahyu = true;
//   isThisWahyu ? print("wahyu") : print("bukan");
// }


// void main() {
//   var minimarketStatus = "close";
//   var minuteRemainingToOpen = 5;
//   if (minimarketStatus == "open") {
//     print("saya akan membeli telur dan buah");
//   } else if (minuteRemainingToOpen <= 5) {
//     print("minimarket buka sebentar lagi, saya tungguin");
//   } else {
//     print("minimarket tutup, saya pulang lagi");
//   }
// }

// void main() {
//   var minimarketStatus = "open";
//   var telur = "ada";
//   var buah = "soldout";
//   if (minimarketStatus == "open") {
//     print("saya akan membeli telur dan buah");
//     if (telur == "soldout" && buah == "soldout") {
//       print("belanjaan saya tidak lengkap");
//     } else if (telur == "soldout") {
//       print("telur habis");
//     } else if (buah == "soldout") {
//       print("buah habis");
//     } 
//   } else {
//     print("minimarket tutup, saya pulang lagi");
//   }
// }

void main() { 
var buttonPushed = 2;
switch(buttonPushed) {
  case 1:   { print('matikan TV!'); break; }
  case 2:   { print('turunkan volume TV!'); break; }
  case 3:   { print('tingkatkan volume TV!'); break; }
  case 4:   { print('matikan suara TV!'); break; }
  default:  { print('Tidak terjadi apa-apa'); }}
}