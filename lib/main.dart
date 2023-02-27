import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/simulatedData.dart';
import 'package:tv_app/tvControlByListenable.dart';
import 'dart:io';
import 'moviesList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(kIsWeb ){
      TvControl.initWebControl();
    }else if (Platform.isAndroid){
      TvControl.initAndroidTVControl();
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.darkTheme,
      home: const IndexViewPage(),
    );
  }
}

/*




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    super.initState();
    Map<String, String> webDavHeaders = {
      "authorization": authorize("qisftp", "!q@wer")
    };
    _controller = VideoPlayerController.network(
      'http://192.168.1.21:8002/Farewell.My.Concubine.mp4',
      httpHeaders: webDavHeaders,
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class SamplePlayer extends StatefulWidget {
  const SamplePlayer({Key? key}) : super(key: key);

  @override
  State<SamplePlayer> createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    Map<String, String> webDavHeaders = {
      "authorization": authorize("qisftp", "!q@wer")
    };
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        'http://192.168.1.21:8002/Farewell.My.Concubine.mp4',
        httpHeaders: webDavHeaders,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}

class WebDavClientClass {
  Client() {
    var client = newClient(
      'http://localhost:6688/',
      user: 'flyzero',
      password: '123456',
      debug: true,
    );
    // client.read()
  }
}

String authorize(String user, String pwd) {
  List<int> bytes = utf8.encode('$user:$pwd');
  return 'Basic ${base64Encode(bytes)}';
}

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


*/

