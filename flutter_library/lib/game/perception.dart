import 'dart:async';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:event_bus/event_bus.dart';
///感知训练
import '../Tools/UIDefine.dart';
import 'package:flutter/material.dart';

List<Image> pics = [
  Image.asset('images/棒冰.png'),
  Image.asset('images/爆米花.png'),
  Image.asset('images/开心果.png'),
  Image.asset('images/马卡龙.png'),
  Image.asset('images/热狗.png'),
  Image.asset('images/寿司.png'),
  Image.asset('images/甜甜圈.png'),
  Image.asset('images/饼干.png')
];

List<String> words = [
  '浏览',
  '诠释',
  '憧憬',
  '萤火',
  '梦幻',
  '精美',
  '弥漫',
  '湍急',
  '酣睡',
  '嘈杂',
  '巍然',
  '屹立',
  '蓦地',
  '摒弃',
  '迸溅',
  '和蔼',
  '惆怅',
  '豁达',
  '清澈',
  '赋予',
  '濒危',
  '钦佩',
  '欣赏',
  '讨论',
  '愉悦',
  '明朗',
  '简单',
  '检查',
  '坚持',
  '善良',
  '祖国',
  '喜欢',
  '观察',
  '偏袒',
  '拘束',
  '冒昧',
  '博弈',
  '馈赠',
  '倦怠',
  '贪婪',
  '憔悴',
  '权衡',
  '淳朴',
  '佯攻',
  '渎职',
  '戒备',
  '迂回',
  '玷污',
  '异议',
  '妄想',
  '腐朽',
  '瑕疵',
  '乔装',
  '诙谐',
  '安全',
  '精湛'
];

EventBus eventBus = new EventBus();

class AlignPoint {
  double x;
  double y;

  AlignPoint() {
    x = Random.secure().nextDouble() * 2 - 1;
    y = Random.secure().nextDouble() * 2 - 1;
  }
}

class PerceptionTrain extends StatefulWidget {
  final GameMode mode;
  final GameCtx content;

  PerceptionTrain({this.mode, this.content});

  @override
  _PerceptionTrainState createState() => _PerceptionTrainState(mode, content);
}

class _PerceptionTrainState extends State<PerceptionTrain> {
  final GameMode mode;
  final GameCtx content;

  int lenth;
  Timer _timer;

  _PerceptionTrainState(this.mode, this.content);
  @override
  Widget build(BuildContext context) {
    lenth = Random.secure().nextInt(8) + 4;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(BgiManager().bgi),
                    fit: BoxFit.fill)),
            child: Padding(
                padding: EdgeInsets.all(50),
                child: ShareInherit(
                    answer: lenth,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('images/shortBg.png'),
                              fit: BoxFit.fill),
                          border: Border.all(
                              width: 12, color: const Color(0xFFFF7720))),
                      child: Stack(children: _getDataSource()),
                    )))));
  }

  List<Widget> _getDataSource() {
    int ran = Random.secure().nextInt(pics.length - 1);
    List source = List.generate(lenth, (int index) {
      switch (content) {
        case GameCtx.ctxNum:
          return Random.secure().nextInt(89) + 10;
          break;
        case GameCtx.ctxStr:
          return words[Random.secure().nextInt(words.length - 1)];
          break;
        case GameCtx.ctxGraphic:
          return pics[Random.secure().nextInt(pics.length - 1)];
          break;
        case GameCtx.ctxGraphicUnion:
          return pics[ran];
        default:
      }
      return null;
    });

    return List.generate(lenth, (int idx) {
      AlignPoint point = _makePoint(); //AlignPoint();

      if(idx == lenth - 1) pointList = List();
      return Align(
        alignment:
            Alignment(point.y, point.x), //AlignmentDirectional(0.8, -0.8),
        child: Container(
          width: 60,
          height: 50,
          child: Center(
            child: (widget.content == GameCtx.ctxGraphic ||
                    widget.content == GameCtx.ctxGraphicUnion)
                ? source[idx]
                : Text('${source[idx]}',
                    style: TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.none,
                        color: Colors.white)),
          ),
        ),
      );
    });
  }

  List<AlignPoint> pointList = List();
  AlignPoint _makePoint() {
    AlignPoint point = AlignPoint();
    if (pointList.isNotEmpty) {
      var fault = pointList.any((t) =>
          ((t.x - point.x).abs() <
              60 / (MediaQuery.of(context).size.width / 2 - 50)) &&
          ((t.y - point.y).abs() <
              60 / (MediaQuery.of(context).size.height / 2 - 50)));
      if (fault) {
        point = _makePoint();
      }
    }
    pointList.add(point);
    return point;
  }

  @override
  void dispose() {
    _timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  void startCount(GameMode curMode) {
    int sec = curMode.index * 500 + 1000;

    var second = Duration(milliseconds: sec);
    var callBack = (Timer tm) {
      tm.cancel();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext ctx) {
            return _QuestAnswer(lenth, ctx, widget.content);
          });
    };

    _timer = Timer.periodic(second, callBack);
  }

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    startCount(mode);
    subscription = eventBus.on<CustomEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
    startCount(mode);
  }
}

class ShareInherit extends InheritedWidget {
  final int answer;

  static ShareInherit of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ShareInherit);

  ShareInherit({Key key, @required Widget child, this.answer})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _QuestAnswer extends StatefulWidget {
  final int answer;
  final BuildContext ctxx;
  final GameCtx content;
  _QuestAnswer(this.answer, this.ctxx, this.content);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer, ctxx);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;
  final BuildContext ctxx;
  List childrens;
  _QuestAnswerState(this.answer, this.ctxx);

  int groupValue;

  bool right = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00),
      body: Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('images/paper.png'),
                  fit: BoxFit.fill)),
          child: Column(children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(170)),
            Text(_queStr(),
                style: TextStyle(fontSize: 28, color: Colors.black)),
            SizedBox(height: ScreenUtil().setHeight(60)),
            Row(
              children: _getOptions(),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Offstage(
                offstage: right,
                child: Text('回答错误',
                    style: TextStyle(fontSize: 20, color: Colors.red))),
            Expanded(
              child: Stack(children: [
                Align(
                  alignment: Alignment(0.9, 0.85),
                  child: FlatButton(
                    child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: const AssetImage('images/an_bg_n.png'),
                                fit: BoxFit.fill)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: const AssetImage(
                                              'images/an_back_w.png'),
                                          fit: BoxFit.fill))),
                              SizedBox(width: 10),
                              Text('返回',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white))
                            ])),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(ctxx).pop();
                    },
                  ),
                )
              ]),
            )
          ])),
    );
  }

  String _queStr() {
    String qstr;
    switch (widget.content) {
      case GameCtx.ctxNum:
        qstr = '请选择数字的数量';
        break;
      case GameCtx.ctxStr:
        qstr = '请选择文字的数量';
        break;
      default:
        qstr = '请选择图片的数量';
        break;
    }
    return qstr;
  }

  List _getEnumAry() {
    List source;
    do {
      do {
        source = List.generate(4, (int idx) {
          return Random.secure().nextInt(8) + 4;
        });
      } while (!source.contains(answer));
    } while (Set.from(source).length < 4);
    return source;
  }

  List<Widget> _getOptions() {
    List<Widget> res = List.generate(4, (int idx) {
      return Flexible(
          child: RadioListTile(
        activeColor: const Color(0xFFFF7720),
        value: childrens[idx],
        groupValue: groupValue,
        title: Text(
          '${childrens[idx]}',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        onChanged: (value) {
          this.setState(() {
            groupValue = childrens[idx];
            right = groupValue == answer;
            if (right) {
              Navigator.of(context).pop();
              eventBus.fire(CustomEvent());
            }
          });
        },
      ));
    });
    return res;
  }

  @override
  void didChangeDependencies() {
    childrens = _getEnumAry();
    super.didChangeDependencies();
  }
}

//通知
class CustomEvent {
  CustomEvent();
}
