import 'package:tv_app/simulatedData.dart';
import 'package:tv_app/tvControlByListenable.dart';
import 'dart:math';
import 'package:maps_toolkit/maps_toolkit.dart';

MyKeyEvent leftDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadLeft'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent leftUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadLeft'), action: KeyAction.fromName(name: 'up'));

MyKeyEvent upDown = MyKeyEvent(type: KeyType.fromName(name: 'dPadUp'), action: KeyAction.fromName(name: 'down'));
MyKeyEvent upUp = MyKeyEvent(type: KeyType.fromName(name: 'dPadUp'), action: KeyAction.fromName(name: 'up'));

int index=-1;
void main(){
  pointInGrid();
}

indexPage(){
  TvControl.registerGrid(
      0, 0, 1, optionsButtonName.length + optionsButtonName.length);
  TvControl.registerGrid(1, 0, 3, 3);
  TvControl.registerGrid(
      1, 1, 5,  84,PointPosition(1,1));
}

detailPage(){
  TvControl.registerGrid(0, 0, 1, 1);
  TvControl.registerGrid(0, 1, 10, testMovieData.tagList.length);
  TvControl.registerGrid(9, 1, 3, testMovieData.actorList.length);
}


testIndex(){
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
  index++;
  print('$index: (${index % 10}, ${(index ~/ 10) + 1})');
}

testGrid(){
  MyGrid grid = MyGrid(
      topLeftPosition: PointPosition(9, 0),
      topRightPosition: PointPosition(9, 9),
      bottomLeftPosition: PointPosition(0, 0),
      bottomRightPosition: PointPosition(0, 9),
      lengthX: 10,
      lengthY: 10,
      gridLength: 100,
      initPosition: PointPosition(0, 0));

  print(grid.isPointInBorder(PointPosition(0, 7)));
}

pointInGrid(){
  TvControl.registerGrid(0, 0, 1, 1);
  TvControl.registerGrid(0, 1, 10, 24);
  TvControl.registerGrid(10, 1, 3, 13);

  TvControl.setDefaultButton(4,1);
  TvControl.keyEvent(upDown);
  TvControl.keyEvent(upUp);
  print(TvControl.defaultMap.selectPoint);
}






