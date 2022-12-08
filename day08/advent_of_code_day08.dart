import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //only for color in terminal for debbuging

import 'package:path/path.dart';

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
}

processLinesTask(List<String> lines) {
  List<List<Tree>> treeRows = [];
  //Data parser for tree grid
  for (var line in lines) {
    List<Tree> row = [];
    List<String> hights = line.split('');

    for (var hight in hights) {
      var value = int.parse(hight);
      Tree tree = Tree(value);
      row.add(tree);
    }
    treeRows.add(row);
  }
  //this method setup viewing distances for all trees
  scenicScoreChecker(treeRows);
  //nested loop to get the tree with maximum decore score
  var max = 0;
  for (var rows in treeRows) {
    for (var tree in rows) {
      max = max > tree.getScore() ? max : tree.getScore();
    }
  }
  print('result is: $max');
}

int visibleTrees(List<List<Tree>> map) {
  var result = 0;
  var rowMax =
      -1; //-1 becouse we need valu smaller than any number to make edge always visible
  var columnMax = -1;
  //loking if tree is visible from left or right
  for (var row in map) {
    rowMax = -1;
    for (var tree in row) {
      //check left side visibility also here marking/coloring all the tree
      var value = tree.getHaight();
      if (value > rowMax) {
        result++;
        tree.Visible();
      } else {
        tree.notVisible();
      }
      rowMax = value > rowMax ? value : rowMax;
    }
    rowMax = -1;
    for (var tree in row.reversed) {
      //right visibility check
      //look only at trees which is not already colored
      var value = tree.getHaight();
      if (tree.isVisible()!) {
        rowMax = value > rowMax ? value : rowMax;
        continue;
      }
      if (value > rowMax) {
        result++;
        tree.Visible();
      }
      rowMax = value > rowMax ? value : rowMax;
    }
  }
  //now we will check top and bottom visibility
  var width = map.elementAt(0).length;
  for (int i = 0; i < width; i++) {
    columnMax = -1;
    for (var row in map) {
      //top visibility check
      var currentTree = row.elementAt(i);
      var value = currentTree.getHaight();

      if (currentTree.isVisible()!) {
        //if tree is already marked/colored
        //if (value > columnMax) print('top: $value on $i');
        columnMax = value > columnMax ? value : columnMax;
        continue;
      }
      if (value > columnMax) {
        result++;
        //print('Max in column is $columnMax');
        //print('top: $value on $i');
        row.elementAt(i).Visible();
      }
      columnMax = value > columnMax ? value : columnMax;
    }

    columnMax = -1;
    for (var row in map.reversed) {
      //bottom visibility check
      var currentTree = row.elementAt(i);
      var value = currentTree.getHaight();

      if (currentTree.isVisible()!) {
        //if tree is already marked/colored
        //if (value > columnMax) print('bot: $value on $i');
        columnMax = value > columnMax ? value : columnMax;
        continue;
      }
      if (value > columnMax) {
        result++;
        row.elementAt(i).Visible();
      }
      columnMax = value > columnMax ? value : columnMax;
    }
  }
  return result;
}

//Task 2 method
void scenicScoreChecker(List<List<Tree>> map) {
  var treeIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  var max = -1;

  //for setting value of right and left score to the tree
  for (var row in map) {
    treeIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    var j = 1;
    max = -1;
    for (var tree in row) {
      //set the left score to trees
      var value = tree.getHaight();
      if (value > max) {
        treeIndex[value] = j;
        tree.setLeft(j - 1);
        max = value;
        if (j == 1) tree.setLeft(0);
      } else {
        var dist = 1;
        for (int k = value; k < treeIndex.length; k++) {
          dist = dist < treeIndex[k] ? treeIndex[k] : dist;
        }
        tree.setLeft(j - dist);

        treeIndex[value] = j;
      }
      j++;
    }
    treeIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    j = 1;
    for (var tree in row.reversed) {
      //set the right score to trees
      var value = tree.getHaight();
      if (value > max) {
        treeIndex[value] = j;
        tree.setRight(j - 1);
        max = value;
        if (j == 1) tree.setRight(0);
      } else {
        var dist = 1;
        for (int k = value; k < treeIndex.length; k++) {
          dist = dist < treeIndex[k] ? treeIndex[k] : dist;
        }
        tree.setRight(j - dist);

        treeIndex[value] = j;
      }
      j++;
    }
  }

  var width = map.elementAt(0).length;
  for (int i = 0; i < width; i++) {
    treeIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    var j = 1;
    max = -1;
    for (var row in map) {
      //top visibility check
      var currentTree = row.elementAt(i);
      var value = currentTree.getHaight();

      if (value > max) {
        treeIndex[value] = j;
        row.elementAt(i).setTop(j - 1);
        max = value;
        if (j == 1) row.elementAt(i).setTop(0);
      } else {
        var dist = 1;
        for (int k = value; k < treeIndex.length; k++) {
          dist = dist < treeIndex[k] ? treeIndex[k] : dist;
        }
        row.elementAt(i).setTop(j - dist);

        treeIndex[value] = j;
      }
      j++;
    }

    treeIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    j = 1;
    max = -1;
    for (var row in map.reversed) {
      //bottom visibility check
      var currentTree = row.elementAt(i);
      var value = currentTree.getHaight();

      if (value > max) {
        treeIndex[value] = j;
        row.elementAt(i).setBot(j - 1);
        max = value;
        if (j == 1) row.elementAt(i).setBot(0);
      } else {
        var dist = 1;
        for (int k = value; k < treeIndex.length; k++) {
          dist = dist < treeIndex[k] ? treeIndex[k] : dist;
        }
        row.elementAt(i).setBot(j - dist);

        treeIndex[value] = j;
      }
      j++;
    }
  }
}

class Tree {
  bool? _visible;
  int _haight;

  //fields for task 2
  int _botScore = 1;
  int _topScore = 1;
  int _rightScore = 1;
  int _leftScore = 1;

  Tree(this._haight);

  void Visible() {
    _visible = true;
  }

  void notVisible() {
    _visible = false;
  }

  void setBot(int value) {
    _botScore = value;
  }

  void setTop(int value) {
    _topScore = value;
  }

  void setRight(int value) {
    _rightScore = value;
  }

  void setLeft(int value) {
    _leftScore = value;
  }

  int getScore() => _botScore * _topScore * _rightScore * _leftScore;

  int getHaight() => _haight;
  bool? isVisible() => _visible;
}
