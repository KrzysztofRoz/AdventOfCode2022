import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
}

//this is first part
//due to the similar nature of code for task one and two, processLinesTask method is use for both task the diferences is extracted to transport method
processLinesTask(List<String> lines) {
  //this variable is only to change the code in one place when we need more uniq digits in buffer
  var decodeDigits = 14; //=4 for first task

  for (var line in lines) {
    List<String> signal = line.split('');
    var index =
        0; //the starting index position in main string (from the file) of first letter in buffer
    List<String> buffer = [];

    for (var data in signal) {
      buffer.add(data);

      if (buffer.length == decodeDigits) {
        //when stored letters have the sema size as our decode message code
        List<String> uniq =
            buffer.toSet().toList(); //make list with only uniq letters
        if (uniq.length != decodeDigits) {
          //when the uniq list has different length then our code  we  move buffer to the place
          index++;
          buffer.removeAt(0);
        } else {
          break; //we find code
        }
      }
    }
    print(
        'solution: ${index + decodeDigits}'); //postiono where code ended (according to task)
  }
}
