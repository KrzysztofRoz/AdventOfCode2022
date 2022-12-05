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
  //create the list of stacks
  List<List<String>> stackList = [];
  for (int i = 0; i < 9; i++) {
    List<String> stack = [];
    stackList.add(stack);
  }
  //insert the data from file to acording stacks
  int i = 0;
  for (i = 0; i < lines.length; i++) {
    List<String> line = lines.elementAt(i).split('');

    for (int j = 1; j <= line.length; j += 4) {
      if (line.elementAt(j) != ' ') {
        var c = j ~/ 4;
        stackList.elementAt(c).insert(0, line.elementAt(j));
      }
    }
    if (lines.elementAt(i).isEmpty) {
      i++;
      break;
    }
  }

  //block of code which interprete command from task
  for (i; i < lines.length; i++) {
    List<String> elements = lines.elementAt(i).split(" ");
    var quantity = int.parse(elements.elementAt(1));
    var from = int.parse(elements.elementAt(3));
    var to = int.parse(elements.elementAt(5));

    List<String> chosenFromStack = stackList.elementAt(from - 1);
    List<String> chosenToStack = stackList.elementAt(to - 1);

    transport(chosenFromStack, quantity, chosenToStack);
  }

  var result = '';
  for (List<String> stack in stackList) {
    result += stack.last;
  }
  print(result);
}

//transport method for task 1
void transportTask1(List<String> from, int quantity, List<String> to) {
  for (int i = 0; i < quantity; i++) {
    to.add(from.last);
    from.removeLast();
  }
}

//transport method for the second task
void transport(List<String> from, int quantity, List<String> to) {
  List<String> buff = [];
  for (int i = 0; i < quantity; i++) {
    buff.add(from.last);
    from.removeLast();
  }
  var n = buff.length;
  for (int j = 0; j < n; j++) {
    to.add(buff.last);
    buff.removeLast();
  }
}
