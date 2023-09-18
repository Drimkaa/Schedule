import 'dart:async';

import 'package:flutter/material.dart';

final  sizeBloc = SizeBloc();

class contentBlock{
  final String type;
  final int id;
  final GlobalKey key;
  contentBlock(this.key, this.type, this.id);
}

class SizeBloc{
  List<StreamController<contentBlock>> _drawStatus = [];
  Map<int,contentBlock> lastValues = {};

  Stream<contentBlock> get(int id){
    return _drawStatus[id].stream;

  }
  createGroup(String groupName){

  }
  update(int id,contentBlock status){
    if (!_drawStatus[id].isClosed)
      _drawStatus[id].sink.add(status);
  }
  add(){
    _drawStatus.add(StreamController<contentBlock>());
  }
  get length => _drawStatus.length;
  dispose() {
    for(var stream in _drawStatus)
      stream.close();
    _drawStatus = [];
  }
  disposeOn(int id ){
    _drawStatus[id].close();
    _drawStatus[id] = StreamController<contentBlock>();
  }
}