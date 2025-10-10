//Slide 3
// void main() {
//   List <int> list = [23, 24, 25];
//   print(list[0]);
//   print(list[1]);
//   print(list[2]);
// }

//Slide 4
// void main() {  
//   List <int> list = [23, 24, 25];  
//   list.add(0);    
//   print(list[0]);  
//   print(list[1]);  
//   print(list[2]);  
//   print(list[3]);
// }

//Slide 5
// void main() {
//   Map<String, String> kota = {'jkt' : 'Jakarta', 'bdg' : 'Bandung', 'sby' : 'Surabaya'};
//   print(kota['jkt']);
//   print(kota['bdg']);
//   print(kota['sby']);
// }

//Slide 6
// void main() {  
//   var languages = ["C", "C++", "Java", "Dart", "Javascript", 2 , 34];
//   for(var language in languages){
//     print(language);  }
//   print("Total bahasa: ${languages.length}");}

//Slide 8
// var arrayMulti = [ 
//     [1, 2, 3],
//     [4, 5, 6],
//     [7, 8, 9]
// ];
// //var arrayMulti = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
// void main(){
// print(arrayMulti[0][0]); // 1 
// print(arrayMulti[1][0]); // 4
// print(arrayMulti[2][1]); // 8
// }

// void main(){
// //forEach()
// var perusahaan = ['bukalapak', 'tokopedia', 'blibli'];
// perusahaan.forEach((data)=> print(data)); 

// //contains()
// var perusahaan1 = ['bukalapak', 'tokopedia', 'blibli', 'salestock'];
//  print(perusahaan1.contains('bukalapak'));

// //sort()
// var randomdata = [1,3,5,20,4,2];
//  randomdata.sort((a, b)=> a.compareTo(b));
//  print(randomdata);

// //reduce(), fold()
//   var randomdata1 = [1, 3, 5, 20, 4, 2];
//   randomdata1.sort((a, b) => a.compareTo(b));
//   print(randomdata1);
//   var sumData = randomdata1.reduce((cur, next) => cur + next);
//   print(sumData);
//   const currentValue = 10;
//   var nextSum =
//       randomdata1.fold<int>(currentValue, (cur, next) => cur + next);
//   print(nextSum);

// //every()
// List<Map<String, dynamic>> listUser = [
//  {'nama': 'bekasi', 'umur': 240},
//  {'nama': 'boyolali', 'umur': 200},
//  {'nama': 'jakarta', 'umur': 100},
//  {'nama': 'surabaya', 'umur': 150},
// ];
// var example = listUser.every((data) => data['umur'] >= 100);
// print(example);

// //where(), firstWhere(), singleWhere()
// var userYoung = listUser.where((data)=> data['umur'] > 100);
// print(userYoung);
// var userFirstYoung = listUser.firstWhere((data)=> data['umur'] < 200);
// print(userFirstYoung); 
// var userSingle = listUser.singleWhere((data)=> data['umur'] <= 100);
// print(userSingle);

// //take(), skip()
// var dataTestCase = [1, 2, 3, 4, 10, 90];
// print(dataTestCase.take(2)); /// (1, 2)
// print(dataTestCase.skip(2)); /// (3, 4, 10, 90)

// //expand()
// var pairs = [[1, 2], [‘='a', 'b'], [3, 4]];
// var flatmaps = pairs.expand((pair)=> pair);
// print(flatmaps);
// }