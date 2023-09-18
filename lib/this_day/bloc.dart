import 'dart:async';


final  timeBloc = TimePropertiesBloc();

class TimePropertiesBloc {
  List<StreamController<List<double>>> _lessonGradients = [];


  Stream<List<double>> get(int id) {
    return _lessonGradients[id].stream;
  }

  updateGradient(int id, List<double> newGradient) {
    if (!_lessonGradients[id].isClosed) {
      _lessonGradients[id].sink.add(newGradient);
    }
  }

  add() {
    _lessonGradients.add(StreamController<List<double>>());
  }

  get length => _lessonGradients.length;

  dispose() {
    for (var stream in _lessonGradients) {
      stream.close();
      stream = StreamController<List<double>>();
    }
    _lessonGradients = [];
  }

  disposeOn(int id) {
    _lessonGradients[id].close();
    _lessonGradients[id] = StreamController<List<double>>();
  }
}