import 'package:tv_app/tvControlByListenable.dart';

List<List<String>> data = [
  ['0,0' '0,1', '0,2' '0,3', '0,4'],
  ['1,0' '1,1', '1,2' '1,3', '1,4'],
  ['2,0' '2,1', '2,2' '2,3', '2,4'],
  ['3,0' '3,1', '3,2' '3,3', '3,4'],
  ['4,0' '4,1', '4,2' '4,3', '4,4'],
];

void main() {
  // print(data);
  // for(var i=data[0].length-1;i<0;i--){
  //   data[0][i];
  // }
  ViewMapButton a = ViewMapButton(
    position:PointPosition(0,0),
    selectStatus:false,
  );
  print( a.position == PointPosition.startPoint);
  print(PointPosition.startPoint.hashCode);
}
