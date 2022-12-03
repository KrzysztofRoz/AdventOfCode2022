import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesFirstTask);
  file.readAsLines().then(processLinesSecondTask);
}

//this is first part

processLinesFirstTask(List<String> lines) {
  var points = 0;
  for (var line in lines) {
    List<String> roundChoice = line.split(" ");
    switch (roundChoice.elementAt(1)) {
      //Check the result by shape we selected

      case 'X':
        points += 1;
        switch (roundChoice.elementAt(0)) {
          //check the effect of mach 3 point for draw and 6 for win
          case 'A':
            points += 3;
            break;
          case 'B':
            break;
          case 'C':
            points += 6;
            break;
        }
        break;
      case 'Y': //repeat the previous case but with diffrent shape
        points += 2;
        switch (roundChoice.elementAt(0)) {
          case 'A':
            points += 6;
            break;
          case 'B':
            points += 3;
            break;
          case 'C':
            break;
        }
        break;
      case 'Z':
        points += 3;
        switch (roundChoice.elementAt(0)) {
          case 'A':
            break;
          case 'B':
            points += 6;
            break;
          case 'C':
            points += 3;
            break;
        }
        break;
    }
  }
  print('Total points: $points');
}

//part 2 of task

processLinesSecondTask(List<String> lines) {
  var points = 0;
  for (var line in lines) {
    List<String> roundChoice = line.split(" ");
    switch (roundChoice.elementAt(1)) {
      case 'X': //the lose case so no point
        switch (roundChoice.elementAt(0)) {
          //additional points for different shapes
          case 'A':
            points += 3;
            break;
          case 'B':
            points += 1;
            break;
          case 'C':
            points += 2;
            break;
        }
        break;
      case 'Y':
        points += 3; //3 points for draw
        switch (roundChoice.elementAt(0)) {
          //additional points for different shapes
          case 'A':
            points += 1;
            break;
          case 'B':
            points += 2;
            break;
          case 'C':
            points += 3;
            break;
        }
        break;
      case 'Z': //6 points for win
        points += 6;
        switch (roundChoice.elementAt(0)) {
          //additional points for different shapes
          case 'A':
            points += 2;
            break;
          case 'B':
            points += 3;
            break;
          case 'C':
            points += 1;
            break;
        }
        break;
    }
  }
  print('Total points: $points');
}
