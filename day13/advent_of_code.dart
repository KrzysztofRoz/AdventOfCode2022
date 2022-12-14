import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File(
      '/home/krzysztof/Documents/studia/Advent2022/advent_of_code/data/data.txt');
  file.readAsLines().then(processLinesTask);
}

processLinesTask(List<String> lines) {
  var left = [];
  var right = [];
  var correct = 0;
  bool isLeft = true;
  var index = 1;

  for (var line in lines) {
    if (line.isNotEmpty) {
      var elements = line.split('');
      List<List<dynamic>> stack = [];
      for (var element in elements) {
        if (element == '[') {
          var list = [];
          stack.add(list);
        }
        if (element == ',') continue;
        if (isNumeric(element)) {
          stack.last.add(int.parse(element));
        }
        if (element == ']') {
          if (stack.length == 1) continue;
          stack.elementAt(stack.length - 2).add(stack.last);
          stack.removeLast();
        }
      }
      if (isLeft) {
        left = stack.elementAt(0);
        isLeft = false;
      } else {
        right = stack.elementAt(0);
        isLeft = true;
      }
    } else {
      int ans = 0;
      for (int i = 0; i < left.length && ans == 0; i++) {
        if (i == right.length) {
          ans = -1;
          continue;
        }
        ans = compare(left.elementAt(i), right.elementAt(i));
      }
      if (ans == 0 && right.length > left.length) ans = 1;
      print('${left.toString()} length ${left.length}');
      if (ans == 1) {
        //print('${left.toString()} length ${left.length}');
        /*
        for (var element in left) {
          if (element is int) {
            print(chalk.green(element));
          }
          if (element is List) {
            print(chalk.red(element.toString()));
          }

        }*/
        correct += index;
      }
      index++;
    }
  }

  print(chalk.bgBlackBright.white(correct));
}

//simple check if value is numeric using ragEx
bool isNumeric(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

//compare method for lists acording to task
int compare(dynamic left, dynamic right) {
  if (left is int && right is int) {
    //the integer part of compare simply greater 1, lower -1, equal 0
    if (left < right) {
      return 1;
    }
    if (right == left) {
      return 0;
    }
    return -1;
  }

  if (left is List && right is int) {
    //wrapping right value as a list
    right = [right];
  }
  if (left is int && right is List) {
    //wrapping left value to a list
    left = [left];
  }
  //now we have only lists as values

  if (left is List && right is List) {
    var i = 0;
    while (i < left.length && i < right.length) {
      var x = compare(left.elementAt(i), right.elementAt(i));
      if (x == 1) {
        return 1;
      }
      if (x == -1) {
        return -1;
      }
      i++;
    }
    if (i == left.length) {
      //if index is the same length as left array
      if (left.length == right.length) {
        //if both the saame length we need compare more
        return 0;
      }
      return 1; //right is longer
    }
    //if right array have no more indexes its size is smaller then left one so wrong order
    return -1;
  }
  return 0;
}
