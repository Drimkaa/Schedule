import 'dart:async';

import 'package:flutter/material.dart';

final  dayBloc = DayBloc();

class DayBlock{

  final int id;
  final bool current;
  final GlobalKey key;
  DayBlock(this.key, this.current, this.id);
}
class DayBloc{
  List<StreamController<DayBlock>> _drawStatus = [];


  Stream<DayBlock> get(int id){
    return _drawStatus[id].stream;

  }
  update(int id,DayBlock status){
    if (!_drawStatus[id].isClosed)
      _drawStatus[id].sink.add(status);
  }
  add(){
    _drawStatus.add(StreamController<DayBlock>());
  }
  get length => _drawStatus.length;
  dispose() {
    for(var stream in _drawStatus) {
      stream.close();
      stream = StreamController<DayBlock>();
    }
    _drawStatus = [];
  }
  disposeOn(int id ){
    _drawStatus[id].close();
    _drawStatus[id] = StreamController<DayBlock>();
  }
}