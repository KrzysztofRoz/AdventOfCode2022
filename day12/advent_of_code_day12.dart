import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File('/path/file.txt');
  file.readAsLines().then(processLinesTask);
}

//program for parsing monkeys
processLinesTask(List<String> lines) {
  List<List<Point>> points = [];
  var startX;
  var startY;
  //parser of grid to point List
  var width = 0;
  var haight = 0;
  for (var line in lines) {
    var elements = line.split('');
    width = 0;
    List<Point> pointRow = [];
    for (var element in elements) {
      if (element == 'S') {
        pointRow.add(Point(width, haight, 0));
        startX = width;
        startY = haight;
      } else {
        if (element == 'E')
          pointRow.add(Point(width, haight, 27));
        else {
          pointRow.add(Point(width, haight, element.codeUnitAt(0) - 96));
        }
      }
      width++;
    }
    points.add(pointRow);
    haight++;
  }
  //Setting adject points for each points
  width = points.elementAt(0).length;
  haight = points.length;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < haight; j++) {
      var left;
      var right;
      var up;
      var bot;
      //setting horizontal adject points;
      if (i != 0 && i != width - 1) {
        right = points.elementAt(j).elementAt(i + 1);
        left = points.elementAt(j).elementAt(i - 1);
        points.elementAt(j).elementAt(i).addPoint(right);
        points.elementAt(j).elementAt(i).addPoint(left);
      } else {
        //edge cases only left/right adject point
        if (i == 0) {
          right = points.elementAt(j).elementAt(i + 1);
          points.elementAt(j).elementAt(i).addPoint(right);
        }
        if (i == width - 1) {
          left = points.elementAt(j).elementAt(i - 1);
          points.elementAt(j).elementAt(i).addPoint(left);
        }
      }
      //setting vertical adject points
      if (j != 0 && j != haight - 1) {
        up = points.elementAt(j - 1).elementAt(i);
        bot = points.elementAt(j + 1).elementAt(i);
        points.elementAt(j).elementAt(i).addPoint(up);
        points.elementAt(j).elementAt(i).addPoint(bot);
      } else {
        //edge cases only up/bot adjeect point
        if (j == 0) {
          up = points.elementAt(j + 1).elementAt(i);
          points.elementAt(j).elementAt(i).addPoint(up);
        }
        if (j == haight - 1) {
          bot = points.elementAt(j - 1).elementAt(i);
          points.elementAt(j).elementAt(i).addPoint(bot);
        }
      }
    }
  }
  //naw we hev full field structure (graph) with setted adject points and we can start finding shortest path
  var result = bfs(points, startX, startY, 27);
  print(result);
}

int bfs(List<List<Point>> points, int startX, int startY, int searchedValue) {
  var moves = 0;
  var nodesLayer =
      1; //for counting nodes in actual layer and know when counting moves
  var nodesNext = 0; //for counting node in next layer
  bool reachEnd = false;
  var visited = Set<Point>();
  var queue = Queue<Point>();
  var actual = points.elementAt(startY).elementAt(startX);

  queue.add(actual); //add starting element to the queue
  visited.add(actual);
  while (queue.isNotEmpty && !reachEnd) {
    actual = queue.elementAt(0); //dequeued the element
    visited.add(actual);
    queue.removeFirst();
    var adj = actual.getConnectedPoints();
    for (var point in adj) {
      //add next nodes to queue (if not already added)
      if (point.getHaight() == searchedValue) {
        reachEnd = true;
      }
      if (!visited.contains(point)) {
        visited.add(point);
        queue.add(point);
        nodesNext++;
      }
    }
    nodesLayer--; //remove one from actual layer
    if (nodesLayer == 0) {
      //if there is no nodes in layer we go to the next layer and increment moves counter
      nodesLayer = nodesNext;
      nodesNext = 0;
      moves++;
    }
  }

  return moves;
}

class Point {
  int _x;
  int _y;
  int _haight;
  bool _visited = false;
  List<Point> _connectPoint = [];

  Point(this._x, this._y, this._haight);

  void setVisited() {
    _visited = true;
  }

//method to add points, according to task when points have different haight values by more than 2 thera are not adject
  void addPoint(Point point) {
    if (point.getHaight() <= _haight + 1 && point.getHaight() >= _haight - 1) {
      _connectPoint.add(point);
    }
  }

  int getX() => _x;
  int getY() => _y;
  int getHaight() => _haight;
  bool isVisited() => _visited;
  List<Point> getConnectedPoints() => _connectPoint;

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
