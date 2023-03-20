import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tv_app/simulatedData.dart';
import 'package:tv_app/tvControlByListenable.dart';
import 'detail.dart';
// UI https://dribbble.com/shots/10799678-Rainway-Dashboard-2-0

const classificationPageColor = Color.fromARGB(255, 12, 14, 36);
const titleSelectColor = Color.fromARGB(255, 35, 37, 58);
const moviesGridColor = Color.fromARGB(255, 15, 18, 45);
const leftWidthPercentage = 0.15;
late double deviceWidth;
late double deviceHeight;
const indexPageName = "index";
var textStyle = const TextStyle(
  color: Colors.white,
  fontSize: 18,
  height: 1.5,
  decoration: TextDecoration.none,
);

class IndexViewPage extends StatefulWidget {
  const IndexViewPage({super.key});

  @override
  State<StatefulWidget> createState() =>_IndexViewPage();
}

class _IndexViewPage extends State<IndexViewPage>{
  @override
  Widget build(BuildContext context) {
    TvControl.activationPageMap(indexPageName); // 切换页面
    List<String> optionsButtonName = ["下载", "换源", "刷新", "管理",'movie'];
    List<String> tagName = ["喜剧", "科幻", "爱情", "动作"];
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        ClassificationPage(
            optionsButtonName: optionsButtonName, tagName: tagName),
        const IndexViewBodyPage(),
      ],
    );
  }
}

// 左侧功能栏
class ClassificationPage extends StatelessWidget {
  const ClassificationPage(
      {super.key, required this.optionsButtonName, required this.tagName});

  final List<String> optionsButtonName;
  final List<String> tagName;

  leftOptionsButton() {
    print("固定功能");
    return ListView.builder(
      controller: ScrollController(),
      itemCount: optionsButtonName.length,
      itemBuilder: (BuildContext context, int index) {
        return RowTitleButton(
          x: 0,
          y: index,
          title: Text(
            optionsButtonName[index],
            style: textStyle,
          ),
        );
      },
    );
  }

  Widget movieTageTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 25),
      child: Text(
        "标签",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          height: 2,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  movieTageList() {
    print("标签页");
    return ListView.builder(
      controller: ScrollController(),
      itemCount: tagName.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return movieTageTitle();
        }
        return RowTitleButton(
          x: 0,
          y: optionsButtonName.length + index - 1,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.ac_unit,
                  color: Colors.white,
                ),
              ),
              Text(tagName[index - 1], style: textStyle)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("功能区渲染");
    TvControl.registerGrid(0, 0, 1, optionsButtonName.length + optionsButtonName.length);
    return Container(
      decoration: const BoxDecoration(
        color: classificationPageColor,
      ),
      width: deviceWidth * leftWidthPercentage,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          SizedBox(
            height: deviceHeight * 0.3,
            child: leftOptionsButton(),
          ),
          SizedBox(
            height: deviceHeight * 0.6,
            child: movieTageList(),
          ),
        ],
      ),
    );
  }
}

class RowTitleButton extends StatefulWidget {
   RowTitleButton(
      {super.key, required this.title, required this.x, required this.y, this.isSelect=false});

  final Widget title;
  final int x;
  final int y;
  late bool isSelect = false;

  @override
  State<StatefulWidget> createState() => _RowTitleButton();
}

class _RowTitleButton extends State<RowTitleButton> {


  @override
  initState() {
    super.initState();
    // TvControl.registerChildButton(widget.x, widget.y, this);
    TvControl.getPageMap(indexPageName).valueListenable.addListener(listStatus);
  }

  listStatus(){
    ViewMapButton eventPoint = TvControl.getPageMap(indexPageName).valueListenable.value;
    if(eventPoint.position != PointPosition(widget.x, widget.y)){
      if (widget.isSelect){
        setState(() {
          widget.isSelect = !widget.isSelect;
        });
      }
    }else{
      if (!widget.isSelect && !eventPoint.selectStatus){
        // 光标移动到这个节点了
        setState(() {
          widget.isSelect = !widget.isSelect;
        });
      }else if (widget.isSelect && eventPoint.selectStatus){
        // 确定事件
      }
    }
  }

  changeSelect() {
    setState(() {
      widget.isSelect = !widget.isSelect;
    });
  }

  onSelected() {
    print("(${widget.x}, ${widget.y})按键响应事件");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical:2),
      child: Container(
        decoration: widget.isSelect
            ? BoxDecoration(
                color: titleSelectColor,
                borderRadius: BorderRadius.circular(50))
            : null,
        child: widget.title,
      ),
    );
  }

  @override
  dispose(){
    super.dispose();
    TvControl.getPageMap(indexPageName).valueListenable.addListener(listStatus);
  }
}

// 右侧主界面显示
class IndexViewBodyPage extends StatelessWidget {
  const IndexViewBodyPage({super.key});

  body() {
    TvControl.registerGrid(1, 0, 3, 3);
    return Scaffold(
      backgroundColor: moviesGridColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RowTitleButton(
                    x: 1,
                    y: 0,
                    title: Padding(padding: const EdgeInsets.all(5),child: Text("主页", style: textStyle),),
                  ),
                  RowTitleButton(
                    x: 2,
                    y: 0,
                    title: Padding(padding: const EdgeInsets.all(5),child: Text("上次观看", style: textStyle),),
                  ),
                  RowTitleButton(
                    x: 3,
                    y: 0,
                    title: Padding(padding: const EdgeInsets.all(5),child: Text("收藏", style: textStyle),),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 180),
                child: TextButton(
                  onPressed: TvControl.selectDefaultButton,
                  child: Text(
                    "输入框",
                    style: textStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: const MoviesList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: deviceWidth * (1 - leftWidthPercentage),
      child: body(),
    );
  }
}

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<StatefulWidget> createState() => _MoviesList();
}

class _MoviesList extends State<MoviesList> {
  late List<MovieListModel> moviesData = [];
  bool loading = true;
  int crossAxisCount = 5;

  @override
  initState() {
    super.initState();
    initJsonFile();
  }

  initJsonFile() async {
    String jsonString = await rootBundle.loadString("assets/data/movies.json");
    final jsonResult = json.decode(jsonString);
    for (Map<String, dynamic> map in jsonResult) {
      moviesData.add(MovieListModel.fromJson(map));
    }
    TvControl.registerGrid(1, 1, crossAxisCount,  moviesData.length,PointPosition(1,1));
    setState(() => loading = false);
  }

  showGridView() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: moviesData.length,
        controller: ScrollController(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.only(left: 16.0, top: 0, right: 16),
        itemBuilder: (context, index) {
          return MoviePage(
              x: (index % 5) + 1, y: (index ~/ 5) + 1, data: moviesData[index],isSelect: index==0);
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Text(
            "加载中",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          )
        : showGridView();
  }
}

class MoviePage extends StatefulWidget {
  MoviePage(
      {super.key, required this.data, required this.x, required this.y, this.isSelect=false});

  final int x;
  final int y;
  final MovieListModel data;
  late  bool isSelect;
  @override
  State<MoviePage> createState() => _MoviePage();
}

class _MoviePage extends State<MoviePage>{

  @override
  initState() {
    super.initState();
    TvControl.getPageMap(indexPageName).valueListenable.addListener(listStatus);
  }

  listStatus(){
    ViewMapButton eventPoint = TvControl.getPageMap(indexPageName).valueListenable.value;
    if(eventPoint.position != PointPosition(widget.x, widget.y)){
      if (widget.isSelect){
        setState(() {
          widget.isSelect = false;
        });
      }
    }else{
      if (!widget.isSelect && !eventPoint.selectStatus){
        // 光标移动到这个节点了
        changeSelect();
      }else if(widget.isSelect&&eventPoint.selectStatus){
        // 确定事件
        onSelected();
      }
    }
  }

  @override
  dispose() {
    super.dispose();
    TvControl.getPageMap(indexPageName).valueListenable.removeListener(listStatus);
  }

  changeSelect() {
    ScrollableState? scrollableState = Scrollable.of(context);
    if (scrollableState == null) return;
    ScrollPosition position = scrollableState.position;
    final RenderObject? object = context.findRenderObject();
    if (object == null) return;
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(object);
    if (viewport == null) return;

    double alignment = 0;
    // 如果偏移量大于 (当前cell顶部与视口顶部之间的距离), 则当前cell靠上对齐滚入屏幕内(cell上边已经超出视口)
    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
      //  如果偏移量小于 (当前cell底部与视口底部之间的距离, 可能为负), 则当前cell靠下对齐滚入屏幕内(cell下边还未进入视口内)
    } else if (position.pixels <
        viewport.getOffsetToReveal(object, 1.0).offset) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      setState(() {
        widget.isSelect = !widget.isSelect;
      });
      return;
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: const Duration(milliseconds: 222),
    );

    setState(() {
      widget.isSelect = !widget.isSelect;
    });
  }

  onSelected() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const TVMovieDetailPage(movieData: testMovieData);
    })).then((value){
      print('处理返回页面操作');
      TvControl.activationPageMap(indexPageName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: widget.isSelect
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color.fromARGB(255, 2, 154, 235), width: 1),
            )
          : null,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            widget.data.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MovieListModel {
  MovieListModel(this.name, this.image, this.title, {this.rating = "0"});

  MovieListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    title = json['title'];
    rating = json['rating'];
  }

  late String name;
  late String image;
  late String title;
  late String rating;
}


