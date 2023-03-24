import 'package:flutter/material.dart';

import 'detail.dart';

const testMovieData = MovieModel(
    name: "Black Widow",
    score: 7.8,
    coverImgUrl: './assets/Black_Widow/cover.jpg',
    describe:
    "一部充满动作戏的间谍惊悚片。娜塔莎·罗曼诺夫/黑寡妇遭遇与她的过去相关的一场危险阴谋，将直面自己那些更为黑暗的经历。一股不惜一切要击倒她的力量袭来，娜塔莎必须面对自己在成为复仇者的很久之前那作为间谍的过往，和曾远离的破碎关系",
    posterList: [
      "./assets/Black_Widow/p2516457397.jpg",
      "./assets/Black_Widow/p2590026183.jpg",
      "./assets/Black_Widow/p2638380930.jpg",
      "./assets/Black_Widow/p2659392109.jpg",
      "./assets/Black_Widow/p2662453960.jpg"
    ],
    tagList: [
      '动作',
      "科幻",
      '冒险',
      '剧情',
      '喜剧',
      '科幻',
      '爱情',
      '动画',
      '悬疑',
      '犯罪',
      '惊悚',
      '冒险',
      '音乐',
      '历史',
      '奇幻',
      '恐怖',
      '战争',
      '传记',
      '歌舞',
      '武侠',
      '情色',
      '灾难',
      '西部',
      '励志',
      '亲情',
      '惊悚',
      '冒险',
      '音乐',
      '历史',
      '奇幻',
      '恐怖',
      '战争',
      '传记',
      '歌舞',
      '武侠',
      '情色',
      '灾难',
      '西部',
      '励志',
    ],
    actorList: [
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/David-Harbour.jpg',
          name: 'David Harbour'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Ever Anderson.jpg',
          name: 'Ever Anderson'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Florence_Pugh.jpg',
          name: 'Florence Pugh'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/O-T Fagbenle.jpg',
          name: 'O-T Fagbenle'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Olga Kurylenko.jpg',
          name: 'Olga Kurylenko'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Rachel eisz.jpg',
          name: 'Rachel eisz'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Ray Winstone.jpg',
          name: 'Ray Winstone'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Scarlett Johansson.jpg',
          name: 'Scarlett Johansson'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/Violet McGraw.jpg',
          name: 'Violet McGraw'),
      ActorModel(
          imageUrl: './assets/Black_Widow/actor/William Hurt.jpg',
          name: 'William Hurt'),
    ]);

List<String> optionsButtonName = ["下载", "换源", "刷新元信息", "管理"];
List<String> tagName = ["喜剧", "科幻", "爱情", "动作"];

class AppThemes {
  static final darkTheme = ThemeData(
    backgroundColor: const Color(0xff191A32),
    scaffoldBackgroundColor: const Color(0xff191A32),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff191A32)),
    primaryColor: const Color(0xffE11A38),
    brightness: Brightness.dark,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            primary: Colors.white)),
  );
}
