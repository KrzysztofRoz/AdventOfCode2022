import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File('/path/file.txt');
  file.readAsLines().then(processLinesFirstTask);
  file.readAsLines().then(processLinesSecondTask);
}

//first task solutions , IMPORTANT the solution need modification to input, its need additional empty line before end of file to calculate all indexes
processLinesFirstTask(List<String> lines) {
  var left = [];
  var right = [];
  var correct = 0;
  bool isLeft = true;
  var index = 1;

  for (var line in lines) {
    if (line.isNotEmpty) {
      var elements = line.split('');
      //for inserting 2 digit numbers in elements list
      for (int i = 0; i < elements.length - 1; i++) {
        if (isNumeric(elements.elementAt(i)) &&
            isNumeric(elements.elementAt(i + 1))) {
          String value = elements.elementAt(i);
          value += elements.elementAt(i + 1);
          elements.insert(i, value);
          elements.removeAt(i + 1);
        }
      }
      //for collect lists according to brackets
      List<List<dynamic>> stack = [];
      //parsing input
      for (var element in elements) {
        //starting new list and add it to the stack
        if (element == '[') {
          var list = [];
          stack.add(list);
        }
        //skip to next element
        if (element == ',') {
          continue;
        }
        //add element to last open list
        if (isNumeric(element)) {
          stack.last.add(int.parse(element));
        }
        //closing list and add it to the previous one
        if (element == ']') {
          if (stack.length == 1) continue;
          stack.elementAt(stack.length - 2).add(stack.last);
          stack.removeLast();
        }
      } //add to the left and rigt value
      if (isLeft) {
        left = stack.elementAt(0);
        isLeft = false;
      } else {
        right = stack.elementAt(0);
        isLeft = true;
      }
    } else {
      var ans = 0;
      ans = compare(left, right);
//if right is bigger the add its index to the answer
      if (ans == 1) {
        correct += index;
      }
      index++;
    }
  }

  print(chalk.bgBlack.white(correct));
}

//second task proggram the parser is the same, only difference is that now store lists in signals list
processLinesSecondTask(List<String> lines) {
  var signal = [];
  List<dynamic> signals = [
    [
      [2]
    ],
    [
      [6]
    ]
  ];
  var correct = 0;

  for (var line in lines) {
    if (line.isNotEmpty) {
      var elements = line.split('');
      //for inserting 2 digit numbers in elements list
      for (int i = 0; i < elements.length - 1; i++) {
        if (isNumeric(elements.elementAt(i)) &&
            isNumeric(elements.elementAt(i + 1))) {
          String value = elements.elementAt(i);
          value += elements.elementAt(i + 1);
          elements.insert(i, value);
          elements.removeAt(i + 1);
        }
      }
      //for collect lists according to brackets
      List<List<dynamic>> stack = [];
      //parsing input
      for (var element in elements) {
        //starting new list and add it to the stack
        if (element == '[') {
          var list = [];
          stack.add(list);
        }
        //skip to next element
        if (element == ',') {
          continue;
        }
        //add element to last open list
        if (isNumeric(element)) {
          stack.last.add(int.parse(element));
        }
        //closing list and add it to the previous one
        if (element == ']') {
          if (stack.length == 1) continue;
          stack.elementAt(stack.length - 2).add(stack.last);
          stack.removeLast();
        }
      }
      //put new created list in the correct place of signals list
      bool isBiger = true;
      signal = stack.elementAt(0);
      for (int i = 0; i < signals.length && isBiger; i++) {
        var ans = compare(signal, signals.elementAt(i));
        if (ans == 1) {
          signals.insert(i, signal);
          isBiger = false;
        }
      } //if list is bigger than all elements i put it at the end
      if (isBiger) {
        signals.add(signal);
      }
    }
  }
  //the index reciver using compare method
  var firstMark;
  var secondMark;
  for (int i = 0; i < signals.length; i++) {
    var ans = compare([
      [2]
    ], signals.elementAt(i));
    if (ans == 0) {
      firstMark = i + 1;
    }
    ans = compare([
      [6]
    ], signals.elementAt(i));
    if (ans == 0) {
      secondMark = i + 1;
    }
  }

  print(chalk.red(
      'first: $firstMark second: $secondMark result: ${firstMark * secondMark}'));
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
