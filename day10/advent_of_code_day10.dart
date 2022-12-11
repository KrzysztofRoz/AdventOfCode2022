import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
  file.readAsLines().then(processLinesFirstTask);
}

// first task program
processLinesFirstTask(List<String> lines) {
  var register = 1;
  var cycle = 0;
  var signalStrength = 0;
  var i = 0; //to marking how many 40 is passed
  for (var line in lines) {
    cycle++;
    //check and update signal strength if in 20/60/100/140/180/220 cycle
    if (cycle == 20 + i * 40) {
      i++;
      signalStrength += register * cycle;
    }

    //check which operation to perform
    var elements = line.split(" ");
    if (elements.elementAt(0) == 'noop') {
      continue;
    }
    if (elements.elementAt(0) == 'addx') {
      cycle++;
      var value = int.parse(elements.elementAt(1));
      //check and update signal strength if in 20/60/100/140/180/220 cycle
      if (cycle == 20 + i * 40) {
        i++;
        signalStrength += register * cycle;
      }
      register += value;
    }
  }
  //display if ther is correct number of cycle final register position and our result
  print("cycle is $cycle");
  print("register is $register");
  print("signal Strength is $signalStrength");
}

processLinesTask(List<String> lines) {
  var register = 1;
  var cycle = 1;
  List<List<String>> rows = [];

  //value -1 as row index because first task logic requirement is to increse cycle number at the start of each line
  //and when cycle modulo is 1 we go to another row (we fully insert all pixels in previous row)
  int rowIndex = -1;

  for (var line in lines) {
    //add new row in crt when we fully inesrts all pixels in row
    if (cycle % 40 == 1) {
      List<String> crt = [];
      rows.add(crt);
      rowIndex++;
    }
    //advance crt by one pixel
    cycle++;
    drawPixel(register, rows, rowIndex, cycle % 40 - 2);

    //check what is operation to perform if noop simply go to next line, if addx increment cycle, draw pixel and then draw pixel
    var elements = line.split(" ");
    if (elements.elementAt(0) == 'noop') {
      continue;
    } //
    if (elements.elementAt(0) == 'addx') {
      //add new row in crt when we fully inesrts all pixels in row
      if (cycle % 40 == 1) {
        rowIndex++;
        List<String> crt = [];
        rows.add(crt);
      } //advance crt by one pixel
      cycle++;
      var value = int.parse(elements.elementAt(1));
      drawPixel(register, rows, rowIndex, cycle % 40 - 2);
      register += value;
    }
  }

  //the crt print module (i use the chalk package to add colors in console to make letters more visible (and more christmassy))
  for (var row in rows) {
    var builder = '';
    for (var pixel in row) {
      if (pixel == '#') {
        builder += chalk.green('█');
      } else
        (builder += chalk.red('.'));
    }
    print(builder);
  }
}

//draw method which add draw pixel
void drawPixel(register, List<List<String>> rows, int row, int index) {
  //due to index incompatibility the last to indexes is -2 and -1 to quick fix the issue, i use simply translation to correct values (to do leater!)
  if (index == -2) index = 38;
  if (index == -1) index = 39;
  if (register == index || register + 1 == index || register - 1 == index) {
    rows.elementAt(row).add('#');
  } else {
    rows.elementAt(row).add('.');
  }
}
