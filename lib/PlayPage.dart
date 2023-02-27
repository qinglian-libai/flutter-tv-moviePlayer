import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/play/PlayBarIndicator.dart';
import 'package:video_player/video_player.dart';
import 'package:tv_app/tvControlByListenable.dart';
import 'package:volume_control/volume_control.dart';

String webDAVAuthorize(String user, String pwd) {
  List<int> bytes = utf8.encode('$user:$pwd');
  return 'Basic ${base64Encode(bytes)}';
}

const playPageName = 'playPage';
const netFileUrl = 'http://192.168.1.87:8058/不成问题的问题.mp4';

class PlayVideoValueNotifier {
  PlayVideoValueNotifier({required this.playController}) {
    VolumeControl.volume.then((value) => volumeValue = value);
    playController.addListener(listenStatus);
    TvControl.activationPageMap(playPageName);
    TvControl.appendKeyEventProcess(keyEvent);
    TvControl.appendKeyEventLongProcess(kuaijing);
  }

  late VideoPlayerController playController;
  late ValueNotifier<bool> playStatus = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> playTime =
  ValueNotifier<Duration>(Duration.zero);
  Timer? _timer;
  late double volumeValue;

  listenStatus() {
    playStatus.value = playController.value.isPlaying;
    _fluidVideoProgressListener();
  }

  Future<void> _fluidVideoProgressListener() async {
    if (playController.value.isPlaying) {
      _timer ??= Timer.periodic(const Duration(milliseconds: 100),
          (Timer timer) async {
        if (playController.value.isInitialized) {
          playTime.value = await playController.position ?? playTime.value;
        }
      });
    } else {
      if (_timer != null) {
        _timer?.cancel();
        _timer = null;
        if (playController.value.isInitialized) {
          playTime.value = (await playController.position)!;
        }
      }
    }
  }

  dispose() {
    TvControl.disposePage(playPageName);
    playController.removeListener(listenStatus);
    playStatus.dispose();
    playTime.dispose();
  }

  // 处理按键事件
  keyEvent(KeyType event) {
    print('播放页按键事件$event');
    switch (event) {
      case KeyType.unknown:
        {
          break;
        }
      case KeyType.ok:
        {
          if (playController.value.isPlaying) {
            playController.pause();
          } else {
            playController.play();
          }
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
        VolumeControl.setVolume(volumeValue + 0.1);
        break;
      case KeyType.dPadDown:
        VolumeControl.setVolume(volumeValue - 0.1);
        break;
      case KeyType.dPadLeft:
        playController.seekTo(Duration(
            seconds: playController.value.position.inSeconds - 10));
        break;
      case KeyType.dPadRight:
        playController.seekTo(Duration(
            seconds: playController.value.position.inSeconds + 10));
        break;
      default:
        {
          break;
        }
    }
  }
  // 处理长按事件
  kuaijing(KeyType event) {}
}

class LoadVideo extends StatefulWidget {
  const LoadVideo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadVideo();
}

class _LoadVideo extends State<LoadVideo> {
  late VideoPlayerController _videoPlayerController;
  late bool initStatus = false;
  late PlayVideoValueNotifier myVideoController;


  @override
  initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(netFileUrl);
    myVideoController =
        PlayVideoValueNotifier(playController: _videoPlayerController);
    _videoPlayerController.addListener(playError);
    _videoPlayerController
        .initialize()
        .then((value) => {
              Future.delayed(const Duration(seconds: 2),
                  () => {setState(() => initStatus = true)})
            })
        .catchError((e) {
          print("视频初始化出错$e");
    });
  }

  playError() {
    if (_videoPlayerController.value.hasError) {
      print("视频出错");
      print(_videoPlayerController.value.errorDescription);
    }
  }

  @override
  Widget build(BuildContext context) {
    return initStatus
        ? MyVideoPlayer(myVideoController: myVideoController)
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  dispose() {
    super.dispose();
    myVideoController.dispose();
    _videoPlayerController.dispose();

  }

}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({Key? key, required this.myVideoController})
      : super(key: key);
  final PlayVideoValueNotifier myVideoController;

  @override
  State<StatefulWidget> createState() => _MyVideoPlayer();
}

class _MyVideoPlayer extends State<MyVideoPlayer> {
  late bool operateStatus = false;

  @override
  Widget build(BuildContext context) {
    Size windowsSie = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 1),
        () => {widget.myVideoController.playController.play()});
    return AspectRatio(
      aspectRatio: windowsSie.width / windowsSie.height,
      child: Stack(
        children: [
          Container(
            width: windowsSie.width,
            height: windowsSie.height,
            color: Colors.black87,
            child: AspectRatio(
              aspectRatio:
                  widget.myVideoController.playController.value.aspectRatio,
              child: VideoPlayer(widget.myVideoController.playController),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() => {operateStatus = !operateStatus});
              },
              child: const Text("展示"),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              child: operateStatus
                  ? ClipRect(
                      //使图片模糊区域仅在子组件区域中
                      child: BackdropFilter(
                        //背景过滤器
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        //设置图片模糊度
                        child: Opacity(
                          //悬浮的内容
                          opacity: 0.6,
                          child: Container(
                            width: windowsSie.width,
                            height: windowsSie.height * 0.05,
                            color: Colors.grey.shade200,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text("中国特色社会主义“农二代”",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              child: operateStatus
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: windowsSie.width * 0.15,
                          right: windowsSie.width * 0.15,
                          bottom: 20),
                      child: MyVideoPlayToolUI(
                        myVideoController: widget.myVideoController,
                      ),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

class MyVideoPlayToolUI extends StatefulWidget {
  const MyVideoPlayToolUI({Key? key, required this.myVideoController})
      : super(key: key);
  final PlayVideoValueNotifier myVideoController;

  @override
  State<MyVideoPlayToolUI> createState() => _MyVideoPlayToolUIPage();
}

class _MyVideoPlayToolUIPage extends State<MyVideoPlayToolUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(children: [
        ValueListenableBuilder<bool>(
            valueListenable: widget.myVideoController.playStatus,
            builder: (context, isPlaying, _) {
              return isPlaying
                  ? const CustomVideoPlayerPauseButton()
                  : const CustomVideoPlayerPlayButton();
              // return GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () => {},
              //   child: isPlaying
              //       ? const CustomVideoPlayerPauseButton()
              //       : const CustomVideoPlayerPlayButton(),
              // );
            }),
        Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          child: ValueListenableBuilder<Duration>(
            valueListenable: widget.myVideoController.playTime,
            builder: ((context, progress, child) {
              return Text(
                getDurationAsString(progress),
                style: durationPlayedTextStyle,
              );
            }),
          ),
        ),
        Expanded(
          child: MyVideoPlayerProgressBar(
              myVideoController: widget.myVideoController),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          child: ValueListenableBuilder<Duration>(
            valueListenable: widget.myVideoController.playTime,
            builder: ((context, progress, child) {
              return Text(
                "-${getDurationAsString(widget.myVideoController.playController.value.duration - progress)}",
                style: durationRemainingTextStyle,
              );
            }),
          ),
        )
      ]),
    );
  }

  touchPlayButton() {
    print(
        "isPlaying: ${widget.myVideoController.playController.value.isPlaying}");
    if (widget.myVideoController.playController.value.isPlaying) {
      widget.myVideoController.playController.pause();
    } else {
      widget.myVideoController.playController.play();
    }
    setState(() => {});
  }
}

class MyVideoPlayerProgressBar extends StatefulWidget {
  final PlayVideoValueNotifier myVideoController;

  const MyVideoPlayerProgressBar({Key? key, required this.myVideoController})
      : super(key: key);

  @override
  State<MyVideoPlayerProgressBar> createState() => _MyVideoPlayerProgressBar();
}

class _MyVideoPlayerProgressBar extends State<MyVideoPlayerProgressBar> {
  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (widget.myVideoController.playController.value.isInitialized) {
      print('isInitialized');
      final int duration =
          widget.myVideoController.playController.value.duration.inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range
          in widget.myVideoController.playController.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            CustomVideoPlayerProgressIndicator(
              progress: maxBuffering / duration,
              progressColor: bufferedColor,
              backgroundColor: backgroundColor,
            ),
            ValueListenableBuilder<Duration>(
              valueListenable: widget.myVideoController.playTime,
              builder: (context, progress, child) {
                return CustomVideoPlayerProgressIndicator(
                  progress: progress.inMilliseconds / duration,
                  progressColor: progressColor,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ],
        ),
      );
    } else {
      print('else');

      progressIndicator = const LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor,
        ),
        backgroundColor: backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: const EdgeInsets.all(5),
      child: progressIndicator,
    );

    return paddedProgressIndicator;
  }
}

class CustomVideoPlayerPlayButton extends StatelessWidget {
  const CustomVideoPlayerPlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: Icon(
        CupertinoIcons.play,
        color: CupertinoColors.white,
      ),
    );
  }
}

class CustomVideoPlayerPauseButton extends StatelessWidget {
  const CustomVideoPlayerPauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: Icon(
        CupertinoIcons.pause,
        color: CupertinoColors.white,
      ),
    );
  }
}

String getDurationAsString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration > const Duration(hours: 1)) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

TextStyle durationPlayedTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontFeatures: [FontFeature.tabularFigures()],
  decoration: TextDecoration.none,
);
TextStyle durationRemainingTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontFeatures: [FontFeature.tabularFigures()],
  decoration: TextDecoration.none,
);
const progressColor = Color.fromRGBO(255, 255, 255, 1);
const bufferedColor = Color.fromRGBO(255, 255, 255, 0.3);
const backgroundColor = Color.fromRGBO(156, 156, 156, 0.5);
