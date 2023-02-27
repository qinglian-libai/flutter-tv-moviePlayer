import 'dart:math';

import 'package:another_tv_remote/another_tv_remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

PointPosition Function(PointPosition point) pointUp = (PointPosition point) {
  return PointPosition(point.x, point.y - 1);
};
PointPosition Function(PointPosition point) pointDown = (PointPosition point) {
  return PointPosition(point.x, point.y + 1);
};
PointPosition Function(PointPosition point) pointLeft = (PointPosition point) {
  return PointPosition(point.x - 1, point.y);
};
PointPosition Function(PointPosition point) pointRight = (PointPosition point) {
  return PointPosition(point.x + 1, point.y);
};

class PointPosition {
  static PointPosition startPoint = PointPosition(0, 0);

  PointPosition(x, y)
      : _x = x,
        _y = y;

  late int _x; // 横坐标 内部数组的长度
  late int _y; // 纵坐标 外部数组的长度

  int get x => _x;

  int get y => _y;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  bool operator >(Object other) {
    return hashCode > other.hashCode;
  }

  bool operator <(Object other) {
    return hashCode < other.hashCode;
  }

  @override
  String toString() {
    return "($x, $y)";
  }

  @override
  // 横坐标大的点更大，横坐标相同，纵坐标大的点更大。hash(x,y)=(p1+x)∗p2+y 其中p1 p2是质数
  int get hashCode => (229 + x) * 967 + y;

  PointPosition up() {
    return PointPosition(_x, _y + 1);
  }

  PointPosition down() {
    return PointPosition(_x, _y - 1);
  }

  PointPosition left() {
    return PointPosition(_x - 1, _y);
  }

  PointPosition right() {
    return PointPosition(_x + 1, _y);
  }
}

class Vector {
  Vector(this.basePoint, this.destinationPoint);

  final PointPosition basePoint;
  final PointPosition destinationPoint;

  int get x => destinationPoint.x - basePoint.x;

  int get y => destinationPoint.y - basePoint.y;

  // 计算 |p1 p2| X |p1 p|
  int X(Vector p2) {
    return x * p2.y - y * p2.x;
  }

  // https://www.cnblogs.com/tuyang1129/p/9390376.html
  bool cover(Vector data) {
    if (X(data) == 0 && data.X(this) == 0) {
      // 两条线平行
      Vector a1, b2;
      if (basePoint > destinationPoint) {
        a1 = Vector(destinationPoint, basePoint);
      } else {
        a1 = Vector(basePoint, destinationPoint);
      }
      if (data.basePoint > data.destinationPoint) {
        b2 = Vector(data.destinationPoint, data.basePoint);
      } else {
        b2 = Vector(data.basePoint, data.destinationPoint);
      }

      if (Vector(a1.destinationPoint, b2.basePoint).X(data) != 0) {
        // 不等于代表两条线 平行且不共线
        return false;
      }
      // 等于0代表两条线共线
      // 点排序：横坐标大的点更大，横坐标相同，纵坐标大的点更大。
      return a1.destinationPoint > b2.basePoint;
    }
    return true;
  }
}

class MyGrid {
  const MyGrid(
      {required this.topLeftPosition,
      required this.topRightPosition,
      required this.bottomLeftPosition,
      required this.bottomRightPosition,
      required this.lengthX,
      required this.lengthY,
      required this.gridLength,
      required this.initPosition});

  final PointPosition topLeftPosition;
  final PointPosition topRightPosition;
  final PointPosition bottomLeftPosition;
  final PointPosition bottomRightPosition;
  final int lengthX;
  final int lengthY;
  final int gridLength;
  final PointPosition? initPosition; // 当用户选中到这个组件的时候，强制选中的位置

  Vector get xProjection => Vector(topLeftPosition, topRightPosition);

  Vector get yProjection => Vector(topLeftPosition, bottomLeftPosition);

  // https://www.cnblogs.com/fangsmile/p/9306510.html
  // 计算 |p1 p2| X |p1 p|
  int getCross(PointPosition p1, PointPosition p2, PointPosition p) {
    return (p2.x - p1.x) * (p.y - p1.y) - (p.x - p1.x) * (p2.y - p1.y);
  }

  // todo 判断这个点是不是在矩形内
  // https://www.cnblogs.com/fangsmile/p/9306510.html
  bool isPointInGrid(PointPosition point) {
    if (gridLength == 1) {
      return topLeftPosition == point;
    }
    return Vector(topLeftPosition, bottomLeftPosition)
                    .X(Vector(topLeftPosition, point)) *
                Vector(bottomRightPosition, topRightPosition)
                    .X(Vector(bottomRightPosition, point)) >=
            0 &&
        Vector(bottomLeftPosition, bottomRightPosition)
                    .X(Vector(bottomLeftPosition, point)) *
                Vector(topRightPosition, topLeftPosition)
                    .X(Vector(topRightPosition, point)) >=
            0;
  }

  // 判断点是否在矩形的边界线上
  bool isPointInBorder(PointPosition point) {
    if (Vector(point, topLeftPosition)
            .X(Vector(topLeftPosition, topRightPosition)) ==
        0) {
      return true;
    }
    if (Vector(point, topRightPosition)
            .X(Vector(topRightPosition, bottomLeftPosition)) ==
        0) {
      return true;
    }
    if (Vector(point, bottomLeftPosition)
            .X(Vector(bottomLeftPosition, bottomRightPosition)) ==
        0) {
      return true;
    }
    if (Vector(point, bottomRightPosition)
            .X(Vector(bottomRightPosition, topLeftPosition)) ==
        0) {
      return true;
    }
    return false;
  }

  // 判断移动后是否还在这个矩形内
  bool canHorizontalOrVerticalMove(PointPosition point, String direction) {
    if (!isPointInBorder(point)) {
      return true;
    }
    return true;
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
      topLeftPosition.hashCode +
      topRightPosition.hashCode +
      bottomLeftPosition.hashCode +
      bottomRightPosition.hashCode;

  @override
  bool operator ==(Object other) {
    return super == other;
  }
}

class ViewMap {
  ViewMap();

  // 手动指定坐标了，就不自动寻找最小的坐标了
  late bool setPoint = false;
  final List<PointPosition> _directionPoint = [];
  final List<MyGrid> _components = [];
  late PointPosition selectPoint = PointPosition.startPoint;
  late MyGrid? selectComponents;
  late Function(KeyType event) pageKeyEventProcess = TvControl.oneTouch;
  late Function(KeyType event) pageKeyEventLongProcess =
      TvControl.longTouchKeyEvent;
  final ValueNotifier<ViewMapButton> valueListenable =
      ValueNotifier<ViewMapButton>(
          ViewMapButton(position: PointPosition.startPoint));

  late PointPosition maxPoint = PointPosition.startPoint;

  int get getComponentsLength => _components.length;

  clear() {
    _components.clear();
    selectPoint = PointPosition.startPoint;
  }

  MyGrid? getPointInComponents(PointPosition point) {
    for (var c in _components) {
      if (c.isPointInGrid(point)) {
        return c;
      }
    }
    return null;
  }

  registerGrid(MyGrid grid) {
    for (var g in _components) {
      if (gridOverlapping(g, grid)) {
        if (g != grid) {
          throw ("${grid.topLeftPosition}组件有重叠部分，无法注册");
        }
        // 改组件已经注册过了，不在执行
        return;
      }
    }
    if (!setPoint && grid.topLeftPosition < selectPoint) {
      selectPoint = grid.topLeftPosition;
      selectComponents = grid;
    }
    if (maxPoint.x < grid.bottomRightPosition.x) {
      maxPoint._x = grid.bottomRightPosition.x;
    }
    if (maxPoint.y < grid.bottomRightPosition.y) {
      maxPoint._y = grid.bottomRightPosition.y;
    }
    _components.add(grid);
  }

  // 移动节点 true 移动成功 false 移动失败，已到达边界无法移动
  bool move(KeyType direction) {
    PointPosition Function(PointPosition point) moveButton;
    selectComponents ??= getPointInComponents(selectPoint);
    if (selectComponents == null) {
      return false;
    }
    if (!selectComponents!
        .canHorizontalOrVerticalMove(selectPoint, direction.name)) {
      return false;
    }
    switch (direction) {
      case KeyType.dPadUp:
        moveButton = pointUp;
        break;
      case KeyType.dPadDown:
        moveButton = pointDown;
        break;
      case KeyType.dPadLeft:
        moveButton = pointLeft;
        break;
      case KeyType.dPadRight:
        moveButton = pointRight;
        break;
      default:
        return false;
    }
    // 移动
    PointPosition coordinate = moveButton(selectPoint);
    // 获取移动后在哪个组件中
    MyGrid? nowComponents = getPointInComponents(coordinate);
    // 沿着当前方向一直寻找可用组件，一直到边界
    while (coordinate.x < maxPoint.x &&
        coordinate.y < maxPoint.y &&
        nowComponents == null) {
      coordinate = moveButton(coordinate);
      if (coordinate.x < 0 || coordinate.y < 0) {
        break;
      }
      nowComponents = getPointInComponents(coordinate);
    }
    if (nowComponents == null) {
      // 不在任何组件内，在上下左右方向,往（0，0）找最近的组件
      coordinate = moveButton(selectPoint);
      return horizontalOrVerticalMove(coordinate, direction);
    }
    // 如果切换组件了，并且组件设置了初始位置，则跳转到初始位置
    if (selectComponents != nowComponents &&
        nowComponents.initPosition != null) {
      coordinate = nowComponents.initPosition ?? nowComponents.topLeftPosition;
    }
    if (selectComponents != nowComponents) {
      selectComponents = nowComponents;
    }
    selectPoint = coordinate;
    return true;
  }

  // 判断矩形是否和现有的图形重叠
  bool gridOverlapping(MyGrid left, MyGrid right) {
    // 对x、y轴做投影，两个方向的投影都重叠那就是有重叠
    return (left.xProjection.cover(right.xProjection) &&
        left.yProjection.cover(right.yProjection));
  }

  // 当前点到达边界，尝试在当前行寻找可选中的按键。
  bool horizontalOrVerticalMove(PointPosition point, KeyType keyName) {
    PointPosition Function(PointPosition point) moveButton;
    switch (keyName) {
      case KeyType.dPadUp:
      case KeyType.dPadDown:
        moveButton = pointLeft;
        break;
      case KeyType.dPadLeft:
      case KeyType.dPadRight:
        moveButton = pointUp;
        break;
      default:
        return false;
    }
    point = moveButton(point);
    MyGrid? nowComponents = getPointInComponents(point);
    while (
        point.x < maxPoint.x && point.y < maxPoint.y && nowComponents == null) {
      point = moveButton(point);
      if (point.x < 0 || point.y < 0) {
        break;
      }
      nowComponents = getPointInComponents(point);
    }
    if (nowComponents == null) {
      return false;
    }
    selectComponents = nowComponents;
    selectPoint = point;
    return true;
  }

  setSelectPoint(PointPosition point) {
    MyGrid? a = getPointInComponents(point);
    if (a == null) {
      throw ('$point 点不在任何已注册的组件内部');
    }
    selectComponents = a;
    selectPoint = point;
    setPoint = true;
  }
}

class ViewMapButton {
  ViewMapButton({required this.position, this.selectStatus = false});

  final PointPosition position;
  late bool selectStatus = false;

  @override
  int get hashCode => position.hashCode * 10 + (selectStatus ? 1 : 0);

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}

class TvControl {
  static initAndroidTVControl() {
    AnotherTvRemote.getTvRemoteEvents().listen((event) {
      keyEvent(MyKeyEvent(
          type: KeyType.fromName(name: event.type.name),
          action: KeyAction.fromName(name: event.action.name)));
    });
  }

  static initWebControl() {
    RawKeyboard.instance.addListener((RawKeyEvent value) {
      // print('网页端接收按键事件,按键：${value.data.logicalKey.keyLabel}，事件类型${value is RawKeyDownEvent?"按下":"抬起"}');
      keyEvent(MyKeyEvent.byRawKeyEvent(value));
    });
  }

  // 默认页面，如果不注册页面的话，所有的数据都是在这个页面上修改
  static ViewMap defaultMap = ViewMap();

  // 当前展示的页面
  static ViewMap _activationPage = defaultMap;

  static final Map<String, ViewMap> _pageMap = {};

  // 在进入页面的时候切换下
  static activationPageMap(String pageName) {
    if (!_pageMap.containsKey(pageName)) {
      if (_pageMap.isEmpty) {
        // 第一个使用默认值
        _pageMap[pageName] = defaultMap;
      } else {
        _pageMap[pageName] = ViewMap();
      }
    }
    _activationPage = getPageMap(pageName);
  }

  static ViewMap getPageMap(String pageName) {
    return _pageMap[pageName] ?? defaultMap;
  }

  static disposePage(String pageName) {
    if (_pageMap.containsKey(pageName)) {
      _pageMap.remove(pageName);
      _activationPage = defaultMap;
    }
  }

  static appendKeyEventProcess(Function(KeyType event) callBack) {
    _activationPage.pageKeyEventProcess = callBack;
  }

  static appendKeyEventLongProcess(Function(KeyType event) callBack) {
    _activationPage.pageKeyEventLongProcess = callBack;
  }

  static MyKeyEvent lastKeyEvent = MyKeyEvent(
      type: KeyType.fromName(name: "unknown"),
      action: KeyAction.fromName(name: "unknown"));

  // @override
  // (startX,startY) 左上角坐标，定位组件所在的位置。
  // lenX 组件的宽度。
  // gridLength ：组件按键的总长度
  // controller：控制器，用来在按键未展示在屏幕上的时候，滚过将为展示的展示出来
  static registerGrid(int startX, int startY, int lenX, int gridLength,
      [PointPosition? initPosition]) {
    if (startX < 0 || startY < 0) {
      throw ("坐标禁止小于(0,0)点");
    }
    int lenY =
        gridLength % lenX > 0 ? gridLength ~/ lenX + 1 : gridLength ~/ lenX;
    MyGrid grid = MyGrid(
        topLeftPosition: PointPosition(startX, startY),
        topRightPosition: PointPosition(startX + lenX - 1, startY),
        bottomLeftPosition: PointPosition(startX, startY + lenY - 1),
        bottomRightPosition:
            PointPosition(startX + lenX - 1, startY + lenY - 1),
        lengthX: lenX,
        lengthY: lenY,
        gridLength: gridLength,
        initPosition: initPosition);

    if (initPosition != null && !grid.isPointInGrid(initPosition)) {
      throw ("$initPosition 不在组件内部");
    }
    _activationPage.registerGrid(grid);
  }

  static getComponent(int x, int y) {
    return _activationPage.getPointInComponents(PointPosition(x, y));
  }

  static keyEvent(MyKeyEvent event) {
    if (event.type == lastKeyEvent.type &&
        event.action == KeyAction.up &&
        lastKeyEvent.action == KeyAction.down) {
      _activationPage.pageKeyEventProcess(event.type);
      lastKeyEvent = MyKeyEvent(
          type: KeyType.fromName(name: "unknown"),
          action: KeyAction.fromName(name: "unknown"));
      return;
    }
    if (event.type == lastKeyEvent.type &&
        event.action == KeyAction.down &&
        lastKeyEvent.action == KeyAction.down) {
      _activationPage.pageKeyEventLongProcess(event.type);
    }
    lastKeyEvent = event;
  }

  static oneTouch(KeyType event) {
    print('listen按键事件$event');
    switch (event) {
      case KeyType.unknown:
        {
          break;
        }
      case KeyType.ok:
        {
          _activationPage.valueListenable.value = ViewMapButton(
              position: _activationPage.selectPoint, selectStatus: true);
          break;
        }
      case KeyType.back:
        {
          break;
        }
      case KeyType.fastForward:
        {
          break;
        }
      case KeyType.rewind:
        {
          break;
        }
      case KeyType.skipForward:
        {
          break;
        }
      case KeyType.skipBackward:
        {
          break;
        }
      case KeyType.dPadUp:
      case KeyType.dPadDown:
      case KeyType.dPadLeft:
      case KeyType.dPadRight:
        if (_activationPage.move(event)) {
          _activationPage.valueListenable.value = ViewMapButton(
              position: _activationPage.selectPoint, selectStatus: false);
        }
        break;
      default:
        {
          break;
        }
    }
  }

  static longTouchKeyEvent(KeyType event) {}

  static selectDefaultButton() {
    _activationPage.valueListenable.value = ViewMapButton(
        position: _activationPage.selectPoint, selectStatus: true);
  }

  static setDefaultButton(int X, int Y) {
    _activationPage.setSelectPoint(PointPosition(X, Y));
  }
}

/////////////////////////////////////
enum KeyType {
  unknown,
  ok,
  //play,
  back,
  fastForward,
  rewind,
  skipForward,
  skipBackward,
  dPadUp,
  dPadDown,
  dPadLeft,
  dPadRight;

  static KeyType fromName({required String name}) {
    for (var value in values) {
      if (value.toShortString() == name) {
        return value;
      }
    }
    return KeyType.unknown;
  }

  String toShortString() {
    return toString().split('.').last;
  }
}

enum KeyAction {
  unknown,
  down,
  up;

  static KeyAction fromName({required String name}) {
    for (var value in values) {
      if (value.toShortString() == name) {
        return value;
      }
    }
    return KeyAction.unknown;
  }

  String toShortString() {
    return toString().split('.').last;
  }
}

class MyKeyEvent {
  const MyKeyEvent({required this.type, required this.action});

  factory MyKeyEvent.byRawKeyEvent(RawKeyEvent keyEvent) {
    switch (keyEvent.data.logicalKey.keyId) {
      case 0x100000304: // "Arrow Up"
        return MyKeyEvent(
            type: KeyType.dPadUp,
            action: keyEvent is RawKeyUpEvent ? KeyAction.up : KeyAction.down);
      case 0x100000301: //"Arrow Down"
        return MyKeyEvent(
            type: KeyType.dPadDown,
            action: keyEvent is RawKeyUpEvent ? KeyAction.up : KeyAction.down);
      case 0x100000302: //"Arrow Left"
        return MyKeyEvent(
            type: KeyType.dPadLeft,
            action: keyEvent is RawKeyUpEvent ? KeyAction.up : KeyAction.down);
      case 0x100000303: //"Arrow Right"
        return MyKeyEvent(
            type: KeyType.dPadRight,
            action: keyEvent is RawKeyUpEvent ? KeyAction.up : KeyAction.down);
      case 0x00000020: //空格键
        return MyKeyEvent(
            type: KeyType.ok,
            action: keyEvent is RawKeyUpEvent ? KeyAction.up : KeyAction.down);
      default:
        return const MyKeyEvent(
            type: KeyType.unknown, action: KeyAction.unknown);
    }
  }

  final KeyType type;
  final KeyAction action;

  @override
  String toString() {
    return "Key: $type - Action: $action";
  }
}
