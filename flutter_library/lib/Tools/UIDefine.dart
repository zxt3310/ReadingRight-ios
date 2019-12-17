

enum GameMode {
  modeFast,    //快
  modeNormal,  //普通
  modeLow     //慢
}

enum GameCtx {
  ctxNum,     //数字
  ctxStr,     //文字
  ctxGraphic,      //图形
  ctxGraphicUnion, //单一图形
  ctxArtical, //文章
}

enum GamePath {
  pathN,
  pathZ,
  pathO,
  pathX,
  pathW
}

enum RectShape {
  shapeCycle,
  shapeRoundRect
}


class BgiManager {
  String bgi;
  // 工厂模式
  factory BgiManager() =>_getInstance();
  static BgiManager get instance => _getInstance();
  static BgiManager _instance;
  BgiManager._internal() {
    // 初始化
  }
  static BgiManager _getInstance() {
    if (_instance == null) {
      _instance = new BgiManager._internal();
    }
    return _instance;
  }
}