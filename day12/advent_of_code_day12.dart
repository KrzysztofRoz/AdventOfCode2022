import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:chalkdart/chalk.dart'; //package for coloring letters in console output

void main(List<String> arguments) {
  var file = new File('path/file.txt');
  file.readAsLines().then(processLinesTask);
}

//program for parsing monkeys
processLinesTask(List<String> lines) {
  List<Monkey> monkeys = []; //list of our monkeys
  var actualMonkey = 0; //index of monkey we set values
  //start parsing input i also remove all tabs for easier parsing
  for (var line in lines) {
    //increment monkey to create new one
    if (line.isEmpty) {
      actualMonkey++;
      continue;
    }
    var elements = line.split(' ');
    var first = elements.elementAt(0);
    //create new monkey
    if (first == 'Monkey') {
      var monkey = Monkey();
      monkeys.add(Monkey());
    } //setting items on monkeys
    if (first == 'Starting') {
      var itemsLine = line.split(':').elementAt(1);
      var items = itemsLine.split(', ');
      for (var item in items) {
        monkeys.elementAt(actualMonkey).addItem(BigInt.parse(item));
      }
    } //setting operation parameters
    if (first == 'Operation:') {
      if (elements.elementAt(4) == '*') {
        if (elements.elementAt(5) == 'old') {
          monkeys.elementAt(actualMonkey).isSquare();
        } else {
          monkeys.elementAt(actualMonkey).setOperation('*');
          monkeys
              .elementAt(actualMonkey)
              .setOpValue(BigInt.parse(elements.elementAt(5)));
        }
      } else {
        if (elements.elementAt(4) == '+') {
          monkeys.elementAt(actualMonkey).setOperation('+');
          monkeys
              .elementAt(actualMonkey)
              .setOpValue(BigInt.parse(elements.elementAt(5)));
        }
      }
    } //setting test values
    if (first == 'Test:') {
      monkeys
          .elementAt(actualMonkey)
          .setTest(BigInt.parse(elements.elementAt(3)));
    }
    if (first == 'If') {
      var second = elements.elementAt(1);
      if (second == 'true:') {
        monkeys
            .elementAt(actualMonkey)
            .setPass(int.parse(elements.elementAt(5)));
      }
      if (second == 'false:') {
        monkeys
            .elementAt(actualMonkey)
            .setFail(int.parse(elements.elementAt(5)));
      }
    }
  }
  //perform rounds
  for (int rounds = 0; rounds < 10000; rounds++) {
    for (var monkey in monkeys) {
      var items = monkey.getItems();
      for (var item in items) {
        Pair pair = monkey.operation(item);
        monkeys.elementAt(pair.getMonkey()).addItem(pair.getItem());
      }
      monkey.removeItems();
    }
  }
  //each monkey counter display
  int i = 0;
  for (var monkey in monkeys) {
    print('Monkey $i : ${monkey.getCounter()}');
    i++;
  }

  //monkey business finder
  BigInt max1 = BigInt.from(0);
  BigInt max2 = BigInt.from(0);
  for (var monkey in monkeys) {
    if (monkey.getCounter() > max1) {
      max2 = max1;
      max1 = monkey.getCounter();
    } else {
      if (monkey.getCounter() > max2) {
        max2 = monkey.getCounter();
      }
    }
  }
  print('monkey business is ${max1 * max2}');
}

class Monkey {
  //seted value for each monkey by parser to perform correct operation
  BigInt _inspectCounter = BigInt.from(0);
  List<BigInt> _items = [];
  BigInt _opValue = BigInt.from(0);
  String _operation = '';
  //value for tests
  BigInt _testDiv = BigInt.from(0);
  //the index of monkey to
  int _failMonkey = 0;
  int _passMonkey = 0;
  bool _square = false;

  Monkey();
  //method which perform monkey operation
  Pair operation(BigInt old) {
    _inspectCounter += BigInt.from(1);
    BigInt newItem = BigInt.from(0);
    if (_square) {
      newItem = old * old;
    } else {
      if (_operation == '*') {
        newItem = old * _opValue;
      }
      if (_operation == '+') {
        newItem = old + _opValue;
      }
    }
    //newItem = newItem ~/ 3; for task one
    newItem = newItem %
        BigInt.from(2 *
            17 *
            7 *
            11 *
            19 *
            5 *
            13 *
            3); //the prime numbers from my monkeys,
    //due to the euclid theorem this doesn't change the resulto of devision as we got all monkeys divisable factor

    if (newItem % _testDiv == BigInt.from(0)) {
      return Pair(_passMonkey, newItem);
    }
    return Pair(_failMonkey, newItem);
  }

  void removeItems() {
    _items = [];
  }

  void addItem(BigInt item) {
    _items.add(item);
  }

  void setOpValue(BigInt value) {
    _opValue = value;
  }

  void setOperation(String operation) {
    _operation = operation;
  }

  void setTest(BigInt test) {
    _testDiv = test;
  }

  void setFail(int monkey) {
    _failMonkey = monkey;
  }

  void setPass(int monkey) {
    _passMonkey = monkey;
  }

  void isSquare() {
    _square = true;
  }

  BigInt getCounter() => _inspectCounter;
  List<BigInt> getItems() => _items;
}

class Pair {
  int _monkey;
  BigInt _item;
  Pair(this._monkey, this._item);

  int getMonkey() => _monkey;
  BigInt getItem() => _item;
}
