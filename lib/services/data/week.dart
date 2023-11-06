class Week {
  late int _number;
  late String _type;
  late int _typeId;
  get typeId => _typeId;
  get number => _number;
  String get type => _type;
  Week({required int number,String ? type, int? typeId}){
    _number = number;
    _type = number%2 == 0? "Четная" :  "Нечётная";
    _typeId = number%2;
  }
  @override
  String toString() {
    return "{number:$number,type:$type,typeId:$typeId}";
  }
}