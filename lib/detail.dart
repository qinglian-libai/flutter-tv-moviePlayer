import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tv_app/simulatedData.dart';
import 'package:tv_app/tvControlByListenable.dart';

import 'PlayPage.dart';
import 'moviesList.dart';

// UI  https://dribbble.com/shots/11999981-TV-movie-details-page/attachments/3628468?mode=media
const coverColor = Color.fromRGBO(97, 97, 96, 0.7);
const detailColor = Color.fromRGBO(88, 77, 54, 0.5);
const detailPageName = "detail";
class MovieModel {
  final String name;
  final double score;
  final String coverImgUrl;
  final String describe;
  final List<String> posterList;
  final List<String> tagList;
  final List<ActorModel> actorList;

  const MovieModel({
    required this.name,
    required this.score,
    required this.coverImgUrl,
    required this.describe,
    required this.posterList,
    required this.tagList,
    required this.actorList,
  });
}

class ActorModel {
  final String imageUrl;
  final String name;

  const ActorModel({required this.imageUrl, required this.name});
}

class TVMovieDetailPage extends StatefulWidget {
  const TVMovieDetailPage({Key? key,required this.movieData}) : super(key: key);
  final MovieModel movieData;
  @override
  State<StatefulWidget> createState() => _TVMovieDetailPage();
}

class _TVMovieDetailPage extends State<TVMovieDetailPage> {
  late Size windowsSize;

  @override
  initState() {
    super.initState();
    TvControl.activationPageMap(detailPageName);
    TvControl.registerGrid(0, 0, 1, 1);
    TvControl.registerGrid(0, 1, 10, widget.movieData.tagList.length);
    TvControl.registerGrid(10, 1, 3, widget.movieData.actorList.length);
  }

  posterPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: windowsSize.height * 0.40)),
        Padding(
          padding: const EdgeInsets.only(left: 50, bottom: 10),
          child: Text(
            widget.movieData.name,
            style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "TiroDevanagariHindi"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              XFStarRating(rating: widget.movieData.score),
              Text(
                widget.movieData.score.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 100),
            child: GridView(
              controller: ScrollController(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10, //横轴三个子widget
                  childAspectRatio: 1.0 //宽高比为1时，子widget
                  ),
              children:moveTagList(),
            ),
          ),
        )
      ],
    );
  }

  playPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayMoviesButton(coverImgUrl: widget.movieData.coverImgUrl),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Row(
            children: [
              XFStarRating(rating: widget.movieData.score),
              Text(
                widget.movieData.score.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 1,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            widget.movieData.describe,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          height: 300,
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GridView(
            controller: ScrollController(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
            children: actorTagList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    windowsSize = MediaQuery.of(context).size;
    print('windowsSize.height = ${windowsSize.height}');
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/Black_Widow/cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: windowsSize.width * 0.7,
            height: windowsSize.height,
            child: Container(
              color: coverColor,
              child: posterPage(),
            ),
          ),
          SizedBox(
            width: windowsSize.width * 0.3,
            height: windowsSize.height,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: detailColor,
                  child: playPage(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> moveTagList(){
    List<Widget> result=[];
    for(var i=0;i<widget.movieData.tagList.length;i++){
      result.add(MoveTag(tagName:widget.movieData.tagList[i],index: i,));

    }
    return result;
  }

  List<Widget> actorTagList(){
    List<Widget> result=[];
    for(var i=0;i<widget.movieData.actorList.length;i++){
      result.add(ActorIcon(actor:widget.movieData.actorList[i],index: i,));
    }
    return result;
  }
}

class XFStarRating extends StatefulWidget {
  final double rating;
  final double maxRating;
  final Widget unselectedImage;
  final Widget selectedImage;
  final int count;
  final double size;
  final Color unselectedColor;
  final Color selectedColor;

  XFStarRating({
    required this.rating,
    this.maxRating = 10,
    this.size = 20,
    this.unselectedColor = const Color(0xffbbbbbb),
    this.selectedColor = const Color(0xffe0aa46),
    Widget? unselectedImage,
    Widget? selectedImage,
    this.count = 5,
  })  : unselectedImage = unselectedImage ??
            Icon(
              Icons.star,
              size: size,
              color: unselectedColor,
            ),
        selectedImage = selectedImage ??
            Icon(
              Icons.star,
              size: size,
              color: selectedColor,
            );

  @override
  _XFStarRatingState createState() => _XFStarRatingState();
}

class _XFStarRatingState extends State<XFStarRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: getUnselectImage(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: getSelectImage(),
          ),
        ],
      ),
    );
  }

  List<Widget> getUnselectImage() {
    return List.generate(widget.count, (index) {
      return widget.unselectedImage;
    });
  }

  List<Widget> getSelectImage() {
    //1.计算Star个数和剩余比例等
    double oneVale = widget.maxRating / widget.count;
    int entireCount = (widget.rating / oneVale).floor();
    double leftValue = widget.rating - entireCount * oneVale;
    double leftRatio = leftValue / oneVale;

    //2.获取Star
    List<Widget> selectedImages = [];
    for (int i = 0; i < entireCount; i++) {
      selectedImages.add(widget.selectedImage);
    }

    //3.计算
    Widget leftStar = ClipRect(
      clipper: MyRectClipper(width: leftRatio * widget.size),
      child: widget.selectedImage,
    );
    selectedImages.add(leftStar);
    return selectedImages;
  }
}

class MyRectClipper extends CustomClipper<Rect> {
  final double width;

  MyRectClipper({required this.width});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}

class PlayMoviesButton extends StatefulWidget{
  const PlayMoviesButton({super.key,required this.coverImgUrl});
  final String coverImgUrl;
  @override
  State<StatefulWidget> createState() =>_PlayMoviesButton();

}

class _PlayMoviesButton extends State<PlayMoviesButton>{
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    TvControl.getPageMap(detailPageName).valueListenable.addListener(() {
      ViewMapButton eventPoint = TvControl.getPageMap(indexPageName).valueListenable.value;
      if(eventPoint.position != PointPosition.startPoint){
        if (isSelect){
          setState(() {
            isSelect = false;
          });
        }
      }else{
        if (isSelect && eventPoint.selectStatus){
          // 确定事件
          onSelected();
        }else if (!isSelect){
          // 光标移动到这个节点了
          setState(() {
            isSelect = true;
          });

        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
      decoration: isSelect
          ? BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(2),
      )
          : null,
      child: Padding(
        padding:const EdgeInsets.all(3),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(widget.coverImgUrl),
            const Center(
              child: Icon(Icons.play_arrow_outlined,size:80),
            )
          ],
        ),
      ),
    );
  }

  onSelected() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoadVideo();
    })).then((value){
      print('处理返回页面操作');
      TvControl.activationPageMap(detailPageName);
    });
  }

}

class MoveTag extends StatefulWidget{
  const MoveTag({super.key, required this.tagName, required this.index});

  final String tagName;
  final int index;

  @override
  State<StatefulWidget> createState() =>_MoveTag();
}

class _MoveTag extends State<MoveTag>{
  bool isSelect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TvControl.registerChildButton(
    //     widget.index % 10, (widget.index ~/ 10) + 1, this);
    TvControl.getPageMap(detailPageName).valueListenable.addListener(() {
      ViewMapButton eventPoint = TvControl.getPageMap(indexPageName).valueListenable.value;
      if(eventPoint.position != PointPosition(widget.index % 10, (widget.index ~/ 10) + 1)){
        if (isSelect){
          setState(() {
            isSelect = false;
          });
        }
      }else{
        if (!isSelect && !eventPoint.selectStatus){
          // 光标移动到这个节点了
          setState(() {
            isSelect = true;
          });
        }else if (isSelect && eventPoint.selectStatus){
          // 确定事件
        }
      }
    });
  }

  changeSelect() {
    setState(() {
      isSelect = !isSelect;
    });
  }

  onSelected() {
    // TODO: implement onSelected
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.all(8),
      alignment:const Alignment(0, 0),
      decoration: isSelect
          ? BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(10))
          : null,
      child: Text(
        widget.tagName,
        style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            decoration: TextDecoration.none,
            fontFamily: "MaShanZhengChines"),
      ),
    );
  }
}

class ActorIcon extends StatefulWidget {
  const ActorIcon({super.key, required this.actor,required this.index});

  final ActorModel actor;
  final int index;

  @override
  State<StatefulWidget> createState() => _ActorIcon();

}

class _ActorIcon extends State<ActorIcon> {
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    // TvControl.registerChildButton(
    //     (widget.index % 3) + 10, (widget.index ~/ 3) + 1, this);
    TvControl.getPageMap(detailPageName).valueListenable.addListener(() {
      ViewMapButton eventPoint = TvControl.getPageMap(indexPageName).valueListenable.value;
      if(eventPoint.position != PointPosition((widget.index % 3) + 10, (widget.index ~/ 3) + 1)){
        if (isSelect){
          setState(() {
            isSelect = false;
          });
        }
      }else{
        if (!isSelect && !eventPoint.selectStatus){
          // 光标移动到这个节点了
          setState(() {
            isSelect = true;
          });
        }else if (isSelect && eventPoint.selectStatus){
          // 确定事件
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:Alignment.center,
      child: Column(
        children: [
          SizedBox.fromSize(
            size: const Size.fromRadius(23),
            child: Container(
              decoration: isSelect
                  ? BoxDecoration(
                border: Border.all(color: Colors.white,width: 1),
                borderRadius: BorderRadius.circular(23),
              )
                  : null,
              child: CircleAvatar(
                //头像半径
                radius: 20,
                //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                backgroundImage: AssetImage(widget.actor.imageUrl),
              ),
            ),
          ),
          Text(
            widget.actor.name,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "TiroDevanagariHindi"),
          )
        ],
      ),
    );
  }

  changeSelect() {
    setState(() {
      isSelect = !isSelect;
    });
  }

  onSelected() {
    // TODO: implement onSelected
    throw UnimplementedError();
  }

}
