class Character {
  late int _levelPoint;
  int get levelPoint => _levelPoint;
  set levelPoint(int value){
    if(value <=5){
      value = 5;
    }
    _levelPoint = value;
  }
}