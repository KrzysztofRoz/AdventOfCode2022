import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //only for color in terminal for debbuging

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
}

processLinesTask(List<String> lines) {
  Set<Point> matrix = Set();
  Point point0 = Point(0, 0);
  point0.setVisited();
  matrix.add(point0);
  var head = MainHead();
  List<Tail> tailes = [];
  for (int i = 0; i < 9; i++) {
    tailes.add(Tail());
  }

  for (var line in lines) {
    var elements = line.split(' ');
    Direction direction = Direction.UP;
    var repetition = int.parse(elements.elementAt(1));
    switch (elements.elementAt(0)) {
      case 'R':
        direction = Direction.RIGHT;
        break;
      case 'U':
        direction = Direction.UP;
        break;
      case 'L':
        direction = Direction.LEFT;
        break;
      case 'D':
        direction = Direction.DOWN;
        break;
    }
    for (int i = 0; i < repetition; i++) {
      var currentHead = head.move(direction);

      for (var tail in tailes) {
        currentHead = tail.moveTail(currentHead);
      }
      currentHead.setVisited();
      matrix.add(currentHead);
      print(
          '${matrix.length} kierunek $direction i powtorzenie $i : last tail position ${currentHead.getX()} ${currentHead.getY()}');
    }
  }

  print(matrix.length);
}

enum Direction { UP, DOWN, RIGHT, LEFT }

//this is head object for first task, it got move functionality
/*
class MainHead {
  Point _position = Point(0, 0);
  Point _tail = Point(0, 0);

  MainHead();

  Point move(Direction direction) {
    Point newPosition = _position;
    switch (direction) {
      case Direction.UP:
        newPosition = Point(_position.getX(), _position.getY() + 1);
        if (_position.getY() > _tail.getY()) {
          if (_position.getX() == _tail.getX())
            _tail = Point(_tail.getX(), _tail.getY() + 1);
          if (_position.getX() > _tail.getX())
            _tail = Point(_tail.getX() + 1, _tail.getY() + 1);
          if (_position.getX() < _tail.getX())
            _tail = Point(_tail.getX() - 1, _tail.getY() + 1);
        }
        break;
      case Direction.DOWN:
        newPosition = Point(_position.getX(), _position.getY() - 1);
        if (_position.getY() < _tail.getY()) {
          if (_position.getX() == _tail.getX())
            _tail = Point(_tail.getX(), _tail.getY() - 1);
          if (_position.getX() > _tail.getX())
            _tail = Point(_tail.getX() + 1, _tail.getY() - 1);
          if (_position.getX() < _tail.getX())
            _tail = Point(_tail.getX() - 1, _tail.getY() - 1);
        }
        break;
      case Direction.RIGHT:
        newPosition = Point(_position.getX() + 1, _position.getY());
        if (_position.getX() > _tail.getX()) {
          if (_position.getY() == _tail.getY())
            _tail = Point(_tail.getX() + 1, _tail.getY());
          if (_position.getY() > _tail.getY())
            _tail = Point(_tail.getX() + 1, _tail.getY() + 1);
          if (_position.getY() < _tail.getY())
            _tail = Point(_tail.getX() + 1, _tail.getY() - 1);
        }

        break;
      case Direction.LEFT:
        newPosition = Point(_position.getX() - 1, _position.getY());

        if (_position.getX() < _tail.getX()) {
          if (_position.getY() == _tail.getY())
            _tail = Point(_tail.getX() - 1, _tail.getY());
          if (_position.getY() > _tail.getY())
            _tail = Point(_tail.getX() - 1, _tail.getY() + 1);
          if (_position.getY() < _tail.getY())
            _tail = Point(_tail.getX() - 1, _tail.getY() - 1);
        }

        break;
    }
    _position = newPosition;
    return getTail();
  }

  Point getTail() => _tail;
}

*/

class MainHead {
  Point _position = Point(0, 0);

  MainHead();
  Point move(Direction direction) {
    Point newPosition = _position;
    switch (direction) {
      case Direction.UP:
        newPosition = Point(_position.getX(), _position.getY() + 1);
        break;
      case Direction.DOWN:
        newPosition = Point(_position.getX(), _position.getY() - 1);
        break;
      case Direction.RIGHT:
        newPosition = Point(_position.getX() + 1, _position.getY());
        break;
      case Direction.LEFT:
        newPosition = Point(_position.getX() - 1, _position.getY());

        break;
    }
    _position = newPosition;
    return _position;
  }
}

class Tail {
  Point _position = Point(0, 0);

  Tail();

  Point moveTail(Point headPosition) {
    Point newPosition = _position;
    var X = _position.getX();
    var Y = _position.getY();
    var headX = headPosition.getX();
    var headY = headPosition.getY();
    int xTranslation = 1;
    int yTranslation = 1;
    var deltaX = (headX - X);
    var deltaY = (headY - Y);
    if (deltaX.abs() < 2 && deltaY.abs() < 2) {
      return newPosition;
    }
    if (headX == X) {
      yTranslation = deltaY > 0 ? 1 : -1;
      newPosition = Point(X, Y + yTranslation);
    }
    if (headY == Y) {
      xTranslation = deltaX > 0 ? 1 : -1;
      newPosition = Point(X + xTranslation, Y);
    }
    if (deltaX > 0 && deltaY > 0) {
      newPosition = Point(X + xTranslation, Y + yTranslation);
    }
    if (deltaX < 0 && deltaY > 0) {
      newPosition = Point(X - xTranslation, Y + yTranslation);
    }
    if (deltaX < 0 && deltaY < 0) {
      newPosition = Point(X - xTranslation, Y - yTranslation);
    }
    if (deltaX > 0 && deltaY < 0) {
      newPosition = Point(X + xTranslation, Y - yTranslation);
    }
    _position = newPosition;
    return newPosition;
  }
}

class Point {
  int _x;
  int _y;
  bool _visited = false;

  Point(this._x, this._y);

  void setVisited() {
    _visited = true;
  }

  int getX() => _x;
  int getY() => _y;
  bool isVisited() => _visited;

  @override
  bool operator ==(Object other) {
    if (other is! Point) return false;
    if (_x != other._x) return false;
    if (_y != other._y) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _x.hashCode;
    result = 37 * result + _y.hashCode;
    return result;
  }
}
