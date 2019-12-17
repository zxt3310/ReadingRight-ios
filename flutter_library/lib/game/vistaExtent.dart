import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Tools/UIDefine.dart';

class VistaTrain extends StatelessWidget {
  final RectShape shape;
  final GameMode mode;
  VistaTrain({this.shape, this.mode});
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Stack(
              children: <Widget>[
                Center(
                  child: VistaRect(shape, mode),
                ),
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
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class VistaRect extends StatefulWidget {
  final RectShape shape;
  final GameMode mode;
  VistaRect(this.shape, this.mode);
  @override
  _VistaRectState createState() => _VistaRectState();
}

class _VistaRectState extends State<VistaRect> {
  double dr = ScreenUtil().setHeight(20);
  double cdr = ScreenUtil().setHeight(20);
  Timer _timer;
  int count = 1;
  @override
  Widget build(BuildContext context) {
    print(dr);
    return Container(
        width: dr,
        height: dr,
        decoration: dr > ScreenUtil().setHeight(20)
            ? BoxDecoration(
                border: Border.all(width: 6, color: Colors.white),
                borderRadius: widget.shape == RectShape.shapeCycle
                    ? BorderRadius.circular(dr / 2)
                    : BorderRadius.circular(0))
            : BoxDecoration(),
        child: Center(
          child: Container(
            width: cdr,
            height: cdr,
            decoration: BoxDecoration(
                color: const Color(0xFFF99A2f),
                borderRadius: BorderRadius.circular(cdr / 2)),
          ),
        ));
  }

  void startVis() {
    var oneSec = Duration(milliseconds: widget.mode.index * 250 + 500);
    var callBack = (timer) {
      if (count == 4) {
        dr = cdr;
        count = 1;
        this.setState(() {});
      } else {
        dr = count * 8 * cdr;
        count += 1;
        this.setState(() {});
      }
    };

    _timer = Timer.periodic(oneSec, callBack);
  }

  @override
  void initState() {
    super.initState();
    startVis();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
}
