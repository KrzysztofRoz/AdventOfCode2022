import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
}

//this is code to create file structure from input lines according to task assumptions
processLinesTask(List<String> lines) {
  Directory mainDirectory = Directory('/');
  Directory actualDirectory =
      mainDirectory; //the directory where we currently are
  List<Directory> directories = [mainDirectory];

  for (var line in lines) {
    if (line == lines.elementAt(0))
      continue; //skip the first element as we already add main directory in code
    List<String> elements = line.split(' ');

    if (elements.elementAt(0) == '\$') {
      //command

      if (elements.elementAt(1) == 'cd') {
        //changing the directory
        if (elements.elementAt(2) == '/') actualDirectory = mainDirectory;
        if (elements.elementAt(2) == '..') {
          actualDirectory = actualDirectory.getParent()!;
          continue;
        } else {
          actualDirectory =
              actualDirectory.childrenByName(elements.elementAt(2))!;
          continue;
        }
      }
      if (elements.elementAt(1) == 'ls') continue;
    }
    if (elements.elementAt(0) == 'dir') {
      //add new directories
      var name = elements.elementAt(1);
      Directory dir = Directory(name, actualDirectory);
      actualDirectory.addChild(dir);
      directories.add(dir);
      continue;
    }
    if (isNumeric(elements.elementAt(0))) {
      //add file data to current directory
      actualDirectory.addFile(int.parse(elements.elementAt(0)));
      continue;
    }
  }
  //now we have completed composite structure according to task

//task 1
  var sum = sumOfSmallDirectories(directories);
  print('task 1 results:==============');
  print('Sum of memory from directories bellow 10000 is $sum');

//task 2
  var min = smallestDirectoryToDelete(directories, mainDirectory);
  print('task 2 results:==============');
  print('The minimal folder to delete have : $min memory ');
}

//simple check if value is numeric using ragEx
bool isNumeric(String string) {
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

//method with task one logic
int sumOfSmallDirectories(List<Directory> directories) {
  var result = 0;

  for (var directory in directories) {
    var data = directory.getData();
    if (data <= 100000) {
      result += data;
    }
  }
  return result;
}

//method with second task logic
int smallestDirectoryToDelete(
    List<Directory> directories, Directory mainDirectory) {
  var missingValue = 30000000 - (70000000 - mainDirectory.getData());
  var min = mainDirectory.getData(); //this is the biggest data in directory
  for (var directory in directories) {
    var data = directory.getData();
    if (data >= missingValue) {
      //we look for directories which data is more tha our minmal requaierments, then we check if this one is smaller then previous minimal
      if (data < min) min = data;
    }
  }
  return min;
}

//the composite design pattern
abstract class HaveData {
  int getData();
}

class Directory implements HaveData {
  final String _name;
  List<Directory> _childrens = [];
  final Directory? _parent;
  int _size = 0;
  bool _isCalculated = false; //flag to don't make already done calculations

  Directory(this._name, [this._parent]);

  //recursion method which collect data contain by directory
  int getData() {
    if (_isCalculated) return _size;
    for (var directory in _childrens) {
      _size += directory.getData();
    }
    _isCalculated = true;
    return _size;
  }

  int getChildrensData() {
    var childrensData = 0;
    if (hasChildren()) {
      for (var children in _childrens) {
        childrensData += children.getData();
      }
    }
    return childrensData;
  }

  bool hasChildren() {
    return _childrens.isNotEmpty;
  }

  void addFile(int data) {
    _size += data;
  }

  void addChild(Directory child) {
    _childrens.add(child);
  }

  Directory? childrenByName(String name) {
    Directory? result;
    for (var children in _childrens) {
      if (children.getName() == name) {
        result = children;
        break;
      }
    }
    return result;
  }

  List<Directory> getChildrens() => _childrens;

  Directory? getParent() => _parent;

  String getName() => _name;
}
