import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

EventBus eventBus = new EventBus();
const int numberOfContent = 24;

class Vision extends StatefulWidget {
  final GamePath path;
  final GameMode mode;
  Vision({this.path, this.mode});
  @override
  _VisionState createState() => _VisionState(path, mode);
}

class _VisionState extends State<Vision> {
  final GamePath path;
  final GameMode mode;
  int cout = numberOfContent - 1;
  Timer _timer;
  Timer _preTimer;
  //答案
  int answer = 0;
  //目标图形
  Widget target;
  List<Image> datalists;
  //游戏准备状态
  bool prepare = true;
  List source;
  _VisionState(this.path, this.mode);
  @override
  Widget build(BuildContext context) {
    if (prepare) {
      source = _dataSource();
    }
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
              image: DecorationImage(
                              image: AssetImage('images/shortBg.png'),
                              fit: BoxFit.fill),
              border: Border.all(width: 12, color: const Color(0xFFFF7720))),
          child: prepare
              ? _preTipWid()
              : Stack(
                  children: source,
                ),
        ),
      ),
    ));
  }

  Widget _preTipWid() {
    return Container(
        child: Center(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('请观察', style: TextStyle(fontSize: 30)),
        target,
        Text('的出现次数', style: TextStyle(fontSize: 30))
      ],
    )));
  }

  List<Widget> _dataSource() {
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
    datalists = List.generate(numberOfContent, (int index) {
      return pics[Random.secure().nextInt(pics.length - 1)];
    });
    target = datalists[Random.secure().nextInt(numberOfContent - 1)];
    answer = 0;
    for (Image obj in datalists) {
      if (obj == target) {
        answer++;
      }
    }
    List array = List<Widget>.generate(numberOfContent, (int idx) {
      double x;
      double y;

      switch (widget.path) {
        case GamePath.pathN:
          int a = idx % 8;
          x = -0.75 + a ~/ 2 * 0.5;
          y = (a % 2 == 0) ? -0.85 : 0.85;
          break;
        case GamePath.pathZ:
          int a = idx % 8;
          x = (a % 2 == 0) ? -0.85 : 0.85;
          y = -0.75 + a ~/ 2 * 0.5;
          break;
        case GamePath.pathW:
          int a = idx % 9;
          x = -0.8 + a * 0.2;
          y = (a % 2 == 0) ? -0.85 : 0.85;
          break;
        case GamePath.pathX:
          int a = idx % 8;
          if (a % 4 < 2) {
            x = -0.5 * pow(-1, idx);
            y = -0.75 * pow(-1, idx);
          } else {
            x = -0.5 * pow(-1, idx + 1);
            y = 0.75 * pow(-1, idx + 1);
          }
          break;
        case GamePath.pathO:
          int i = idx % 8;
          if (i < 4) {
            x = -0.8 + i * 0.4;
            y = -sqrt(0.65 - pow(x, 2));
          } else {
            x = 0.8 - (i - 4) * 0.4;
            y = sqrt(0.65 - pow(x, 2));
          }
          break;
        default:
      }

      return Align(
          child: _UnitView(icon: datalists[idx], index: idx),
          alignment: Alignment(x, y));
    });

    array.add(_getBackBtn());
    return array;
  }

  Widget _getBackBtn() {
    return Align(
      alignment: Alignment(0.98, 0.98),
      child: FlatButton(
        child: Container(
            width: 100,
            height: 40,
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
                              image: const AssetImage('images/an_back_w.png'),
                              fit: BoxFit.fill))),
                  SizedBox(width: 10),
                  Text('返回',
                      style: TextStyle(fontSize: 14, color: Colors.white))
                ])),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepareGame();
  }

  StreamSubscription subscription;

  @override
  void initState() {
    subscription = eventBus.on<ResetNotify>().listen((evnet) {
      this.setState(() {
        cout = numberOfContent - 1;
        _prepareGame();
      });
    });
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    if (!prepare) {
      _startGame();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _preTimer.cancel();
    subscription.cancel();
    super.dispose();
  }

  void _startGame() {
    var callBack = (Timer timer) {
      if (cout < -1) {
        prepare = !prepare;
        timer.cancel();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext ctx) {
              return _QuestAnswer(answer, context, target);
            });
      } else {
        eventBus.fire(FreshEvent((numberOfContent - 1 - cout), datalists));
        cout -= 1;
      }
    };

    var oneSec = Duration(milliseconds: widget.mode.index * 250 + 500);
    _timer = Timer.periodic(oneSec, callBack);
  }

  void _prepareGame() {
    var callBack = (Timer tim) {
      tim.cancel();
      prepare = !prepare;
      this.setState(() {});
    };

    var during = Duration(seconds: 2);
    _preTimer = Timer.periodic(during, callBack);
  }
}

class _UnitView extends StatefulWidget {
  final Image icon;
  final int index;
  _UnitView({this.icon, this.index});
  @override
  _UnitViewState createState() => _UnitViewState(icon, index);
}

class _UnitViewState extends State<_UnitView> {
  Image icon;
  final int index;
  bool hide = true;
  _UnitViewState(this.icon, this.index);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: hide,
      child: Container(
        width: 60,
        height: 60,
        child: Center(
          child: icon,
        ),
      ),
    );
  }

  StreamSubscription subscription;
  @override
  void initState() {
    subscription = eventBus.on<FreshEvent>().listen((event) {
      setState(() {
        hide = event.current == index ? false : true;
        icon = event.datalist[index];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

//弹窗

class _QuestAnswer extends StatefulWidget {
  final int answer;
  final BuildContext ctxx;
  final Image target;
  _QuestAnswer(this.answer, this.ctxx, this.target);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer, ctxx, target);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;
  final BuildContext ctxx;

  List childrens;
  final Image target;
  bool right = true;
  _QuestAnswerState(this.answer, this.ctxx, this.target);

  int groupValue;
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
            SizedBox(height: ScreenUtil().setHeight(110)),
            target,
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text('请选择上面图形的出现次数',
                style: TextStyle(fontSize: 25, color: Colors.black)),
            SizedBox(height: ScreenUtil().setHeight(30)),
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

  //生成选项内容
  List _getEnumAry() {
    List source;
    do {
      do {
        source = List.generate(4, (int idx) {
          return Random.secure().nextInt(numberOfContent - 1) + 1;
        });
      } while (!source.contains(answer));
    } while (Set.from(source).length < 4);
    return source;
  }

  //四个选项
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
              eventBus.fire(ResetNotify());
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
class FreshEvent {
  int current;
  List<Image> datalist;
  FreshEvent(this.current, this.datalist);
}

class ResetNotify {
  ResetNotify();
}
