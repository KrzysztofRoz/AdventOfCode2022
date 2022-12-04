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
    //split each line into elves and than split to start and end of interval
    var elf1 = line.split(',').elementAt(0);
    var elf2 = line.split(',').elementAt(1);
    var start1 = int.parse(elf1.split('-').elementAt(0));
    var start2 = int.parse(elf2.split('-').elementAt(0));
    var end1 = int.parse(elf1.split('-').elementAt(1));
    var end2 = int.parse(elf2.split('-').elementAt(1));

    if (subsetAssigment(start1, end1, start2, end2)) {
      result++; //add pair when one is subset
    }
  }
  print(result);
}

bool subsetAssigment(int start1, int end1, int start2, int end2) {
  var isSubset = false;
  //checking witch start is after another and looking if end of that interval is before end of another interval
  if (start1 <= start2 && end1 >= end2) {
    isSubset = true;
  }

  if (start1 >= start2 && end1 <= end2) {
    isSubset = true;
  }

  return isSubset;
}

//part 2 of task

processLinesSecondTask(List<String> lines) {
  var result = 0;
  //split each line into elves and than split to start and end of interval

  for (var line in lines) {
    var elf1 = line.split(',').elementAt(0);
    var elf2 = line.split(',').elementAt(1);
    var start1 = int.parse(elf1.split('-').elementAt(0));
    var start2 = int.parse(elf2.split('-').elementAt(0));
    var end1 = int.parse(elf1.split('-').elementAt(1));
    var end2 = int.parse(elf2.split('-').elementAt(1));

    if (isIntersection(start1, end1, start2, end2)) result++;
  }
  print(result);
}

bool isIntersection(int start1, int end1, int start2, int end2) {
  var intersection = false;
  //add rules for intersection. The start of first interval can only be before(line 64) or after (line 65) start of second interval (for the same position add equality), so that was all possible cases
  if ((start1 <= start2 && end1 >= start2) ||
      (start1 >= start2 && start1 <= end2)) {
    intersection = true;
  }

  return intersection;
}
