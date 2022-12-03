import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesFirstTask);
  file.readAsLines().then(processLinesSecondTask);
}

//this is first part

processLinesFirstTask(List<String> lines) {
  var result = 0;
  for (var line in lines) {
    var letter = duplicateItem(line).codeUnitAt(0);
    if (letter >= 'a'.codeUnitAt(0) && letter <= 'z'.codeUnitAt(0)) {
      //this converts letters to numbers by ASCII code i need to first check the exact code of a and A to make correct translation
      result += letter - 96;
    }
    if (letter >= 'A'.codeUnitAt(0) && letter <= 'Z'.codeUnitAt(0)) {
      result += letter - 38;
    }
  }
  print('Priorieties sum is $result');
  print('=========== end of first task ===========');
}

//this metod check the duplicate characters (in this exercise this is only one letter)
String duplicateItem(String ruckSack) {
  List<String> items = ruckSack.split('');
  var duplicate;
  for (int i = 0; i < items.length / 2; i++) {
    for (int j = items.length - 1; j > items.length / 2 - 1; j--) {
      if (items.elementAt(i) == items.elementAt(j)) {
        duplicate = items.elementAt(i);
        break;
      }
    }
  }
  return duplicate;
}

//part 2 of task

processLinesSecondTask(List<String> lines) {
  var result = 0;
  for (int i = 0; i < lines.length; i += 3) {
    var letter = CheckDuplicateItems(
            lines.elementAt(i), lines.elementAt(i + 1), lines.elementAt(i + 2))
        .codeUnitAt(0);
    if (letter >= 'a'.codeUnitAt(0) && letter <= 'z'.codeUnitAt(0)) {
      result += letter - 96;
    }
    if (letter >= 'A'.codeUnitAt(0) && letter <= 'Z'.codeUnitAt(0)) {
      result += letter - 38;
    }
  }
  print('==========================================');
  print('Priorieties sum is $result');
  print('=========== end of second task ===========');
}

String CheckDuplicateItems(
    String ruckSack1, String ruckSack2, String ruckSack3) {
  List<String> item1 = ruckSack1.split('');
  List<String> item2 = ruckSack2.split('');
  List<String> item3 = ruckSack3.split('');
  var badge;
  List<String> duplicates =
      []; //this variable will contain all duplicate items in first and second line
  for (int i = 0; i < item1.length; i++) {
    for (int j = 0; j < item2.length; j++) {
      if (item1.elementAt(i) == item2.elementAt(j) &&
          !duplicates.contains(item1.elementAt(i))) {
        duplicates.add(item1.elementAt(i));
      }
    }
  } //Beacouse we check the first 2 lines the last duplicate (triplicate?) search is from list with much fewer elements
  for (int i = 0; i < duplicates.length; i++) {
    for (int j = 0; j < item3.length; j++) {
      if (duplicates.elementAt(i) == item3.elementAt(j)) {
        badge = duplicates.elementAt(
            i); //due to task assumptions we only got one letter for each group of 3, so we cen stop imidietly when we found it
        break;
      }
    }
  }
  return badge;
}
