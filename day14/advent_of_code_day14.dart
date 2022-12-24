import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart';
import 'package:path/path.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File('/path/file.txt');
  file.readAsLines().then(processLinesFirstTask);
}

//first task solutions
processLinesFirstTask(List<String> lines) {
  Cave cave = Cave();
  var flor = -1; //to check the flor level in second task

  for (var line in lines) {
    //parsing input to rocks (Set<Point>) in cave class
    var isFirst = true; //flag for first interval in line
    var intervals = line.split(' -> ');
    var xStart;
    var yStart;
    var xNext;
    var yNext;

    for (var interval in intervals) {
      var rocks = []; //for storing rocks from line
      var borders = interval.split(','); //split x and y
      if (isFirst) {
        //for first value set first start
        xStart = int.parse(borders.elementAt(0));
        yStart = int.parse(borders.elementAt(1));
        isFirst = false;
        flor = flor > yStart ? flor : yStart;
      } else {
        //if not first values
        xNext = int.parse(borders.elementAt(0));
        yNext = int.parse(borders.elementAt(1));
        if (xNext == xStart) {
          //if the changing value is column (row=const.)
          var diff = (yNext - yStart).abs();
          var min = yNext < yStart ? yNext : yStart; //to get lower index value
          for (int i = min; i < min + diff + 1; i++) {
            //add all rocks from interval
            cave.addRock(Point(xStart, i));
          }
          flor = flor > yNext ? flor : yNext;
        }
        if (yNext == yStart) {
          //if the changing value is row (column=const.)
          var diff = (xNext - xStart).abs();
          var min = xNext < xStart ? xNext : xStart; //to get lower index value
          for (int i = min; i < min + diff + 1; i++) {
            //add alle rocks from interval
            cave.addRock(Point(i, yStart));
          }
        }
        // replace starting value for the next interval
        xStart = xNext;
        yStart = yNext;
      }
    }
  }
  flor += 2;
  cave.setFlor(flor);
/* for first task sand movment 
  var stopped; //variable to store the bool value if sand stop
  do {
    stopped = cave.moveSand(Point(500, 0), 0);
  } while (stopped);
  */
  var stopped; //variable to store the bool value if sand stop
  do {
    stopped = cave.moveSandFlor(Point(500, 0));
  } while (stopped);

  displayCave(cave);
  print(cave.getSands().length);
}

//method for displaying cave and sand in cave for first task (assumption: width x haight 505x505)
void displayCave(Cave cave) {
  var rocks = cave.getRocks();
  var sands = cave.getSands();
  for (int i = 0; i < 700; i++) {
    var builder = '';
    for (int j = 0; j < 700; j++) {
      if (rocks.contains(Point(j, i))) {
        builder += chalk.bold.gray('#'); //find rock
      } else {
        if (sands.contains(Point(j, i))) {
          builder += chalk.yellow('o'); //find static sand
        } else {
          builder += '.';
        }
      }
    }
    print(builder);
  }
}

class Point {
  int _x;
  int _y;
  Point(this._x, this._y);

  int getX() => _x;
  int getY() => _y;

  @override
  bool operator ==(Object other) =>
      other is Point &&
      other.runtimeType == runtimeType &&
      other._x == this._x &&
      other._y == this._y;

  @override
  int get hashCode => _x.hashCode + _y.hashCode;
}

class Cave {
  Set<Point> _rocks = Set(); //parsing rocks from input
  Set<Point> _sands = Set(); //the quantity of fallen sand
  int? _flor; //flor level for second task

  void addRock(Point rock) {
    _rocks.add(rock);
  }

  void setFlor(int flor) {
    _flor = flor;
  }

  Set<Point> getRocks() => _rocks;
  Set<Point> getSands() => _sands;

  //method for moving sand acording to first task
  bool moveSand(Point sand, int counter) {
    if (_sands.contains(Point(500, 0))) {
      print('start taken');
      return false;
    }
    if (counter > 500) {
      //move for first task
      //if counter is over 500 (haight) the sand fall into the void and doesnt stop (return false)
      return false;
    }
    if (_rocks.contains(Point(
            sand.getX(),
            sand.getY() +
                1)) || //if bellow is not empty check for left diagonal point
        _sands.contains(Point(sand.getX(), sand.getY() + 1))) {
      if ((_rocks.contains(Point(
              sand.getX() - 1,
              sand.getY() +
                  1))) || //if left is not empty check for right diagonal point
          (_sands.contains(Point(sand.getX() - 1, sand.getY() + 1)))) {
        if ((_rocks.contains(Point(sand.getX() + 1, sand.getY() + 1))) ||
            (_sands.contains(Point(sand.getX() + 1, sand.getY() + 1)))) {
          //all points bellow is taken
          _sands.add(
              sand); //there is no empty point to move a sand, add sand to static sand set and return true (sand stopped)
          return true;
        } else {
          counter++; //move sand to the right and go to the next step
          return moveSand(Point(sand.getX() + 1, sand.getY() + 1), counter);
        }
      } else {
        counter++; //move sand to the left and go to the next step
        return moveSand(Point(sand.getX() - 1, sand.getY() + 1), counter);
      }
    } else {
      counter++; //move sand bellow and go to the next step
      return moveSand(Point(sand.getX(), sand.getY() + 1), counter);
    }
  }

  //sand moving method for part 2 of the task
  bool moveSandFlor(Point sand) {
    if (_sands.contains(Point(500, 0))) {
      print('start taken');
      return false;
    }
    if (sand.getY() == _flor! - 1) {
      //move for first task
      _sands.add(sand);
      return true;
    }
    if (_rocks.contains(Point(
            sand.getX(),
            sand.getY() +
                1)) || //if bellow is not empty check for left diagonal point
        _sands.contains(Point(sand.getX(), sand.getY() + 1))) {
      if ((_rocks.contains(Point(
              sand.getX() - 1,
              sand.getY() +
                  1))) || //if left is not empty check for right diagonal point
          (_sands.contains(Point(sand.getX() - 1, sand.getY() + 1)))) {
        if ((_rocks.contains(Point(sand.getX() + 1, sand.getY() + 1))) ||
            (_sands.contains(Point(sand.getX() + 1, sand.getY() + 1)))) {
          //all points bellow is taken
          _sands.add(
              sand); //there is no empty point to move a sand, add sand to static sand set and return true (sand stopped)
          return true;
        } else {
          return moveSandFlor(Point(sand.getX() + 1, sand.getY() + 1));
        }
      } else {
        //move sand to the left and go to the next step
        return moveSandFlor(Point(sand.getX() - 1, sand.getY() + 1));
      }
    } else {
      //move sand bellow and go to the next step
      return moveSandFlor(Point(sand.getX(), sand.getY() + 1));
    }
  }
}
