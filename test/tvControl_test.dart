import 'package:tv_app/simulatedData.dart';
import 'package:tv_app/tvControlByListenable.dart';
import 'dart:math';
import 'package:maps_toolkit/maps_toolkit.dart';



MyKeyEvent upKeyDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadUp'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent upKeyUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadUp'), action: KeyAction.fromName(name: 'up'));

MyKeyEvent downKeyDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadDown'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent downKeyUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadDown'), action: KeyAction.fromName(name: 'up'));

MyKeyEvent leftKeyDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadLeft'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent leftKeyUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadLeft'), action: KeyAction.fromName(name: 'up'));

MyKeyEvent rightKeyDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadRight'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent rightKeyUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadRight'), action: KeyAction.fromName(name: 'up'));

void main(){
  TvControl.defaultMap.valueListenable.addListener(() { print(TvControl.defaultMap.valueListenable.value);});
  pointInGrid();
}

pointInGrid(){
  TvControl.registerGrid(0, 0, 1, 1);
  TvControl.registerGrid(0, 1, 10, 24);
  TvControl.registerGrid(10, 1, 3, 13);

  TvControl.setDefaultButton(4,1);
  print(TvControl.defaultMap.selectPoint);
}






