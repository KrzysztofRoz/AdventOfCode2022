import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  File file = new File('path/input.txt');
  file.readAsLines().then(processLinesMax3);
}

/* this is first part */
processLinesHighest(List<String> lines) {
  var max = 0, sum = 0;
  for (int i = 0; i < lines.length; i++) {
    if (lines.elementAt(i).isNotEmpty) {
      sum += int.parse(lines.elementAt(i));
      if (i == lines.length - 1) {
        max = max > sum ? max : sum;
      }
    } else {
      max = max > sum ? max : sum;
      sum = 0;
    }
  }
  print(max);
}

//second part of task
processLinesMax3(List<String> lines) {
  var top1 = 0, top2 = 0, top3 = 0, sum = 0;
  for (int i = 0; i < lines.length; i++) {
    if (lines.elementAt(i).isNotEmpty) {
      //Add all calory lines for each elf until empty line ocurre
      sum += int.parse(lines.elementAt(i));

//this statments is for last element to be corectly check
      if (i == lines.length - 1) {
        //this is hierrarchy for the 3 elves with the most calories
        if (sum > top1) {
          top3 = top2;
          top2 = top1;
          top1 = sum;
        } else if (sum > top2) {
          top3 = top2;
          top2 = sum;
        } else if (sum > top3) {
          top3 = sum;
        }
      }
    } else {
      if (sum > top1) {
        top3 = top2;
        top2 = top1;
        top1 = sum;
      } else if (sum > top2) {
        top3 = top2;
        top2 = sum;
      } else if (sum > top3) {
        top3 = sum;
      }
      //this is sum reset, because the next numbers is the calories, which next Elf carries
      sum = 0;
    }
  }
  print('top1 =$top1');
  print('top2 =$top2');
  print('top3 =$top3');
  print('total is: ${top1 + top2 + top3}');
}
