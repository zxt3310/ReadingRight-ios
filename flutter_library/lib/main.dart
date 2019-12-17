import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Tools/UIDefine.dart';
import 'game/FocusTrain.dart';
import 'game/perception.dart';
import 'game/visionTrain.dart';
import 'game/vistaExtent.dart';
import 'game/contentExtent.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const platform = const MethodChannel('Read_excellent');

EventBus eventBus = EventBus();
const List menu = [
  ['数字舒尔特表格训练', '文字舒尔特表格训练'],
  ['数字感知训练', '中文感知训练', '第一图形感知训练', '多图形感知训练'],
  ['矩形扩展训练', '圆形扩展训练', '数字扩展训练', '文字扩展训练', '短文扩展训练'],
  ['N字形移动训练', '之字形移动训练', '波浪移动训练', '交叉移动训练', '圆形移动训练']
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 强制横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  Future<void> _getBgi() async {
    try {
      int a = await platform.invokeMethod('getBgi');
      var bgiMan = BgiManager();
      bgiMan.bgi = a == 0 ? 'images/bg.png' : 'images/wood.png';
      runApp(MyApp());
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  _getBgi();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ShareInherit(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: const Color(0xFFFF7720),
      ),
      home: HomeView(),
    ));
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(allowFontScaling: true, width: 1024.0, height: 768.0)
          ..init(context);
    return Scaffold(
      backgroundColor: const Color(0xFF448D60),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(BgiManager().bgi), fit: BoxFit.fill)),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF5A622),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.zero,
                        right: Radius.circular(ScreenUtil().setHeight(60)))),
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TrainSuperButton(
                      idx: 0,
                      title: '专注力训练',
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TrainSuperButton(
                      idx: 1,
                      title: '视觉感知训练',
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TrainSuperButton(
                      idx: 2,
                      title: '视幅拓展训练',
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TrainSuperButton(
                      idx: 3,
                      title: '视点移动训练',
                    )
                  ],
                ),
              ),
              Expanded(
                child: GameDetailView(),
              )
            ],
          )),
    );
  }
}

class TrainSuperButton extends StatefulWidget {
  final int idx;
  final String title;
  final List children;

  TrainSuperButton({this.idx, this.title, this.children});
  @override
  _TrainSuperButtonState createState() => _TrainSuperButtonState();
}

class _TrainSuperButtonState extends State<TrainSuperButton> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      child: Column(
        children: <Widget>[
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 5.5,
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Text('${widget.title}',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontFamily: 'PingFangSC-Medium',
                    color: hide ? Colors.white : Color(0xFFF99A2F))),
            color: hide ? Color(0xFFF99A2F) : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setHeight(30)),
                side: BorderSide(
                    width: ScreenUtil().setHeight(6),
                    color: Color(0xFFFFC85F))),
            onPressed: _btnPress,
          ),
          SizedBox(height: 2),
          Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setHeight(18)),
                  color: Colors.white),
              child: Offstage(
                offstage: hide,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: getChildren()),
              ))
        ],
      ),
    );
  }

  List<Widget> getChildren() {
    List temp = menu[widget.idx];
    return List.generate(temp.length, (index) {
      return ChildGameSel(superIdx: widget.idx, childIdx: index);
    });
  }

  void _btnPress() {
    eventBus.fire(SuperSelEvent(widget.idx));

    int modeId = _ShareInherit.of(context).gameSize;
    eventBus
        .fire(ChildSelEvent(childIdx: 0, subIdx: widget.idx, modeIdx: modeId));
    _ShareInherit.of(context).superIdx = widget.idx;
    _ShareInherit.of(context).childIdx = 0;
  }

  StreamSubscription subscription;
  @override
  void initState() {
    subscription = eventBus.on<SuperSelEvent>().listen((event) {
      hide = widget.idx == event.curidx ? false : true;
      this.setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class ChildGameSel extends StatefulWidget {
  final int superIdx;
  final int childIdx;
  ChildGameSel({this.superIdx, this.childIdx});
  @override
  _ChildGameSelState createState() => _ChildGameSelState();
}

class _ChildGameSelState extends State<ChildGameSel> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    List temp = menu[widget.superIdx];
    return Container(
        height: ScreenUtil().setHeight(50),
        child: FlatButton(
          child: Text('${temp[widget.childIdx]}',
              style: TextStyle(fontSize: ScreenUtil().setSp(16)),
              textAlign: TextAlign.center),
          textColor: pressed ? Color(0xFFFF7720) : Colors.black,
          onPressed: () {
            int modeId = _ShareInherit.of(context).gameSize;
            eventBus.fire(ChildSelEvent(
                childIdx: widget.childIdx,
                subIdx: widget.superIdx,
                modeIdx: modeId));
            _ShareInherit.of(context).superIdx = widget.superIdx;
            _ShareInherit.of(context).childIdx = widget.childIdx;
          },
        )); // Text('${temp[
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<ChildSelEvent>().listen((event) {
      pressed =
          (event.subIdx == widget.superIdx && event.childIdx == widget.childIdx)
              ? true
              : false;
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class GameDetailView extends StatefulWidget {
  @override
  _GameDetailViewState createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  int superIdx = -1;
  int childIdx = -1;
  int modeIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setHeight(50),
            ScreenUtil().setHeight(20),
            ScreenUtil().setHeight(50),
            ScreenUtil().setHeight(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
              FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setHeight(20),
                        height: ScreenUtil().setHeight(20),
                        child: Image.asset('images/an_back_w.png')),
                    SizedBox(width: 5),
                    Text('返 回',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  //Navigator.of(context).pop();
                  platform.invokeMethod('popRoute');
                  eventBus
                      .fire(ChildSelEvent(subIdx: -1, childIdx: 0, modeIdx: 0));
                  eventBus.fire(SuperSelEvent(-1));
                },
              )
            ]),
            Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setHeight(30)),
                    image: DecorationImage(
                        image: const AssetImage('images/shortBg.png'),
                        fit: BoxFit.fill),
                    border: Border.all(
                        width: ScreenUtil().setHeight(12),
                        color: Color(0xFFFF7720))),
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      superIdx == -1
                          ? SizedBox(height: 0)
                          : Text(_scribe(),
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(36),
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                      superIdx == 2 && childIdx > 1
                          ? ContentExtentOptionWidget()
                          : Container(
                              width: ScreenUtil().setHeight(400),
                              height: ScreenUtil().setHeight(300),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(_shortCutName()),
                                      fit: BoxFit.fill)),
                            )
                    ],
                  ),
                )),
            SizedBox(height: ScreenUtil().setHeight(20)),
            superIdx == -1
                ? Container()
                : Expanded(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Flexible(
                            flex: 5,
                            child: superIdx > 0 ? ModeOption() : FocusOption(),
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                    FlatButton(
                                      child: Container(
                                          width: ScreenUtil().setHeight(162),
                                          height: ScreenUtil().setHeight(70),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: const AssetImage(
                                                      'images/an_bg_n.png'),
                                                  fit: BoxFit.fill)),
                                          child: Center(
                                              child: Text('开始',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18),
                                                      color: Colors.white)))),
                                      onPressed: _startGame,
                                    )
                                  ])))
                        ],
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
  }

  String _scribe() {
    return childIdx == -1 ? '欢迎来到训练场' : '${menu[superIdx][childIdx]}';
  }

  String _shortCutName() {
    if (superIdx == -1) {
      return 'images/blank.png';
    }
    String name;
    switch (superIdx) {
      case 0:
        if (childIdx == 0) {
          name = 'images/shuzi/${modeIdx}X$modeIdx.png';
        } else {
          name = 'images/wenzi/${modeIdx}X$modeIdx.png';
        }
        break;
      case 1:
        switch (childIdx) {
          case 0:
            name = 'images/数字感知.png';
            break;
          case 1:
            name = 'images/中文感知.png';
            break;
          case 2:
            name = 'images/第一图形感知.png';
            break;
          case 3:
            name = 'images/多图形感知.png';
            break;
          default:
        }
        break;
      case 2:
        switch (childIdx) {
          case 0:
            name = 'images/矩形拓展.png';
            break;
          case 1:
            name = 'images/圆形拓展.png';
            break;
          case 2:
            name = 'images/矩形拓展.png';
            break;
          case 3:
            name = 'images/圆形拓展.png';
            break;
        }
        break;
      case 3:
        switch (childIdx) {
          case 0:
            name = 'images/N字形.png';
            break;
          case 1:
            name = 'images/之字形.png';
            break;
          case 2:
            name = 'images/波浪形.png';
            break;
          case 3:
            name = 'images/交叉.png';
            break;
          case 4:
            name = 'images/圆形移动.png';
            break;
        }
        break;
      default:
    }
    return name;
  }

  void _startGame() {
    int supIdx = _ShareInherit.of(context).superIdx;
    int chilIdx = _ShareInherit.of(context).childIdx;
    GameMode mode = _ShareInherit.of(context).mode;
    int size = _ShareInherit.of(context).gameSize;
    int contentSize = _ShareInherit.of(context).contentSize;

    GameAssistant helper = GameAssistant(
        childIdx: chilIdx,
        superIdx: supIdx,
        mode: mode,
        gameSize: size,
        contentSize: contentSize);

    print(helper.getTargetGame());
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => helper.getTargetGame()));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => GamePrepare(filter: helper)));
  }

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<ChildSelEvent>().listen((event) {
      superIdx = event.subIdx;
      childIdx = event.childIdx;
      modeIdx = event.modeIdx;
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

//游戏速度选项
class ModeOption extends StatefulWidget {
  @override
  _ModeOptionState createState() => _ModeOptionState();
}

class _ModeOptionState extends State<ModeOption> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: RadioListTile(
                activeColor: const Color(0xFFFF7720),
                title: Text('快',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(18), color: Colors.white)),
                value: 0,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
          Flexible(
            child: RadioListTile(
                activeColor: const Color(0xFFFF7720),
                title: Text('中',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(18), color: Colors.white)),
                value: 1,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
          Flexible(
            child: RadioListTile(
                activeColor: const Color(0xFFFF7720),
                title: Text('慢',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(18), color: Colors.white)),
                value: 2,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
        ],
      ),
    );
  }

  void changed(value) {
    groupValue = value;
    this.setState(() {});
    _ShareInherit.of(context).mode = GameMode.values[value];
    _ShareInherit.of(context).gameSize = 3;
  }
}

//专注力训练选项
class FocusOption extends StatefulWidget {
  @override
  _FocusOptionState createState() => _FocusOptionState();
}

class _FocusOptionState extends State<FocusOption> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('3x3',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 0,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('4x4',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('5x5',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              )
            ],
          )),
          Container(
              child: Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('6x6',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 3,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('7x7',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 4,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    activeColor: const Color(0xFFFF7720),
                    title: Text('8x8',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white)),
                    value: 5,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupValue = _ShareInherit.of(context).gameSize - 3;
    this.setState(() {});
  }

  void changed(value) {
    groupValue = value;
    this.setState(() {});
    _ShareInherit.of(context).gameSize = value + 3;
    int cid = _ShareInherit.of(context).childIdx;
    eventBus.fire(ChildSelEvent(childIdx: cid, subIdx: 0, modeIdx: value + 3));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// 事件类型定义
// 游戏类型选择 点击事件
class SuperSelEvent {
  @required
  int curidx;
  SuperSelEvent(this.curidx);
}

// 游戏分支选择 点击事件
class ChildSelEvent {
  @required
  int subIdx;
  @required
  int childIdx;

  int modeIdx = 3;
  ChildSelEvent({this.subIdx, this.childIdx, this.modeIdx});
}

class ModeRadioEvent {
  @required
  int curValue;
  ModeRadioEvent(this.curValue);
}

class _ShareInherit extends InheritedWidget {
  _ShareInherit({Key key, this.child}) : super(key: key, child: child);

  final Widget child;

  int superIdx = 0;
  int childIdx = 0;

  GameMode mode = GameMode.modeFast;
  int gameSize = 3;

  int contentSize = 4;

  static _ShareInherit of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_ShareInherit)
        as _ShareInherit);
  }

  @override
  bool updateShouldNotify(_ShareInherit oldWidget) {
    return false;
  }
}

//辅助工类 筛选���戏

class GameAssistant {
  @required
  final int superIdx;

  @required
  final int childIdx;

  final int gameSize;
  final GameMode mode;

  final int contentSize;

  GameAssistant(
      {this.superIdx,
      this.childIdx,
      this.gameSize,
      this.mode,
      this.contentSize});

  Widget getTargetGame() {
    Widget wid;
    switch (superIdx) {
      case 0:
        if (childIdx == 0) {
          wid = FocusTrain.number(size: gameSize, ctx: GameCtx.ctxNum);
        } else {
          wid = FocusTrain.number(size: gameSize, ctx: GameCtx.ctxStr);
        }
        break;
      case 1:
        switch (childIdx) {
          case 0:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxNum);
            break;
          case 1:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxStr);
            break;
          case 2:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxGraphicUnion);
            break;
          case 3:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxGraphic);
        }
        break;
      case 2:
        switch (childIdx) {
          case 0:
            wid = VistaTrain(
              shape: RectShape.shapeRoundRect,
              mode: mode,
            );
            break;
          case 1:
            wid = VistaTrain(shape: RectShape.shapeCycle, mode: mode);
            break;
          case 2:
            wid = ContentContainor(
                ctx: GameCtx.ctxNum, range: contentSize, mode: mode);
            break;
          case 3:
            wid = ContentContainor(
                ctx: GameCtx.ctxStr, range: contentSize, mode: mode);
            break;
          case 4:
            wid = ContentContainor(
                ctx: GameCtx.ctxArtical, range: contentSize, mode: mode);
            break;
          default:
            wid = VistaTrain(
              shape: RectShape.shapeRoundRect,
              mode: mode,
            );
            break;
        }
        break;
      case 3:
        switch (childIdx) {
          case 0:
            wid = Vision(path: GamePath.pathN, mode: mode);
            break;
          case 1:
            wid = Vision(path: GamePath.pathZ, mode: mode);
            break;
          case 2:
            wid = Vision(path: GamePath.pathW, mode: mode);
            break;
          case 3:
            wid = Vision(path: GamePath.pathX, mode: mode);
            break;
          case 4:
            wid = Vision(path: GamePath.pathO, mode: mode);
            break;
          default:
        }

        break;
      default:
    }

    return wid;
  }
}

List<String> options = [
  '每行四个字',
  '每行五个字',
  '每行六个字',
  '每行七个字',
  '每行八个字',
  '每行九个字',
  '每行十个字',
  '每行十一个字',
  '每行十二个字'
];

class ContentExtentOptionWidget extends StatefulWidget {
  ContentExtentOptionWidget({Key key}) : super(key: key);

  @override
  _ContentExtentOptionWidgetState createState() =>
      _ContentExtentOptionWidgetState();
}

class _ContentExtentOptionWidgetState extends State<ContentExtentOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //width: 630,
        height: ScreenUtil().setHeight(220),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: ScreenUtil().setHeight(25),
          runSpacing: 0,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          children: _getOptions(),
        ));
  }

  int groupValue = 4;

  List<Widget> _getOptions() {
    return List.generate(options.length, (idx) {
      return Container(
          width: ScreenUtil().setWidth(210),
          height: ScreenUtil().setHeight(40),
          child: RadioListTile(
              dense: true,
              activeColor: const Color(0xFFFF7720),
              title: Text(options[idx],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(20), color: Colors.black)),
              value: idx + 4,
              groupValue: groupValue,
              onChanged: (value) {
                groupValue = value;
                _ShareInherit.of(context).contentSize = value;
                this.setState(() {});
              }));
    });
  }
}

//倒计时页面

class GamePrepare extends StatelessWidget {
  final GameAssistant filter;
  const GamePrepare({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(BgiManager().bgi), fit: BoxFit.fill)),
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 12, color: const Color(0xFFFF7720))),
                    child: TimerWidget(filter: filter)))));
  }
}

class TimerWidget extends StatefulWidget {
  final GameAssistant filter;
  TimerWidget({Key key, this.filter}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int count = 3;
  Timer timer;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/shortBg.png'), fit: BoxFit.fill)),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('倒计时',
                    style: TextStyle(fontSize: 80, color: Colors.white)),
                Text('$count',
                    style: TextStyle(
                        fontSize: 140,
                        color: Colors.white,
                        decoration: TextDecoration.none))
              ]),
        ));
  }

  startCount() {
    var callBack = (tim) {
      if (count == 1) {
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    widget.filter.getTargetGame()));
      } else {
        count--;
        this.setState(() {});
      }
    };

    var sec = Duration(seconds: 1);
    timer = Timer.periodic(sec, callBack);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.startCount();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
