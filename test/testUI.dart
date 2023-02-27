import 'dart:ui';

test(){
  var point = Offset(2, 4);  // 定义点 (2, 4)
  var path = Path();         // 定义路径

  path.lineTo(3, 3);       // 添加线
  path.lineTo(8, 3);
  path.lineTo(8, 1);
  path.lineTo(9, 1);
  path.lineTo(9, 7);       // 添加线
  path.lineTo(7, 7);
  path.lineTo(7, 13);
  path.lineTo(3, 13);
  if (path.contains(point)) {
    print("在图形中");
  } else {
    print("在图案之外");
  }
}
main(){
  test();


}