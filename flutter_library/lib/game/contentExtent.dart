import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';

const List<String> words = [
  '可',
  '品',
  '露',
  '央',
  '团',
  '爬',
  '然',
  '理',
  '接',
  '着',
  '落',
  '从',
  '本',
  '心',
  '熟',
  '横',
  '荣',
  '甲',
  '乃',
  '与',
  '同',
  '京',
  '开',
  '国',
  '年',
  '如',
  '十',
  '个',
  '遇',
  '吃',
  '福',
  '乐',
  '昧',
  '眨',
  '有',
  '白',
  '题',
  '篇',
  '入',
  '邻',
  '卜',
  '点',
  '明',
  '总',
  '揽',
  '亲',
  '言',
  '倾',
  '圭',
  '达',
  '训',
  '各',
  '考',
  '学',
  '得',
  '权',
  '博',
  '贺',
  '途',
  '淘',
  '鸽',
  '爱',
  '笔',
  '海'
];

String artical =
    "我与父亲不相见已二年余了，我最不能忘记的是他的背影。那年冬天，祖母死了，父亲的差使也交卸了，正是祸不单行的日子，我从北京到徐州，打算跟着父亲奔丧回家。到徐州见着父亲，看见满院狼藉的东西，又想起祖母，不禁簌簌地流下眼泪。父亲说，“事已如此，不必难过，好在天无绝人之路！”回家变卖典质，父亲还了亏空；又借钱办了丧事。这些日子，家中光景很是惨淡，一半为了丧事，一半为了父亲赋闲。丧事完毕，父亲要到南京谋事，我也要回北京念书，我们便同行。到南京时，有朋友约去游逛，勾留了一日；第二日上午便须渡江到浦口，下午上车北去。父亲因为事忙，本已说定不送我，叫旅馆里一个熟识的茶房陪我同去。他再三嘱咐茶房，甚是仔细。但他终于不放心，怕茶房不妥帖；颇踌躇了一会。其实我那年已二十岁，北京已来往过两三次，是没有甚么要紧的了。他踌躇了一会，终于决定还是自己送我去。我两三回劝他不必去；他只说，“不要紧，他们去不好！”我们过了江，进了车站。我买票，他忙着照看行李。行李太多了，得向脚夫行些小费，才可过去。他便又忙着和他们讲价钱。我那时真是聪明过分，总觉他说话不大漂亮，非自己插嘴不可。但他终于讲定了价钱；就送我上车。他给我拣定了靠车门的一张椅子；我将他给我做的紫毛大衣铺好坐位。他嘱我路上小心，夜里警醒些，不要受凉。又嘱托茶房好好照应我。我心里暗笑他的迂；他们只认得钱，托他们直是白托！而且我这样大年纪的人，难道还不能料理自己么？唉，我现在想想，那时真是太聪明了！我说道，“爸爸，你走吧。”他望车外看了看，说，“我买几个橘子去。你就在此地，不要走动。”我看那边月台的栅栏外有几个卖东西的等着顾客。走到那边月台，须穿过铁道，须跳下去又爬上去。父亲是一个胖子，走过去自然要费事些。我本来要去的，他不肯，只好让他去。我看见他戴着黑布小帽，穿着黑布大马褂，深青布棉袍，蹒跚地走到铁道边，慢慢探身下去，尚不大难。可是他穿过铁道，要爬上那边月台，就不容易了。他用两手攀着上面，两脚再向上缩；他肥胖的身子向左微倾，显出努力的样子。这时我看见他的背影，我的泪很快地流下来了。我赶紧拭干了泪，怕他看见，也怕别人看见。我再向外看时，他已抱了朱红的橘子望回走了。过铁道时，他先将橘子散放在地上，自己慢慢爬下，再抱起橘子走。到这边时，我赶紧去搀他。他和我走到车上，将橘子一股脑儿放在我的皮大衣上。于是扑扑衣上的泥土，心里很轻松似的，过一会说，“我走了；到那边来信！”我望着他走出去。他走了几步，回过头看见我，说，“进去吧，里边没人。”等他的背影混入来来往往的人里，再找不着了，我便进来坐下，我的眼泪又来了近几年来，父亲和我都是东奔西走，家中光景是一日不如一日。他少年出外谋生，独力支持，做了许多大事。那知老境却如此颓唐！他触目伤怀，自然情不能自已。情郁于中，自然要发之于外；家庭琐屑便往往触他之怒。他待我渐渐不同往日。但最近两年的不见，他终于忘却我的不好，只是惦记着我，惦记着我的儿子。我北来后，他写了一信给我，信中说道，“我身体平安，惟膀子疼痛利害，举箸提笔，诸多不便，大约大去之期不远矣。”我读到此处，在晶莹的泪光中，又看见那肥胖的，青布棉袍，黑布马褂的背影。唉！我不知何时再能与他相见！";

class ContentContainor extends StatelessWidget {
  final GameCtx ctx;
  final int range;
  final GameMode mode;
  const ContentContainor({Key key, this.ctx, this.range, this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(BgiManager().bgi), fit: BoxFit.fill)),
            child: Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage('images/shortBg.png'),
                          fit: BoxFit.fill),
                      border: Border.all(
                          width: 12, color: const Color(0xFFFF7720))),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment(0, 0.5),
                              child: ContentExtentView(
                                  ctx: ctx, range: range, mode: mode),
                            ),
                            Align(
                              alignment: Alignment(0.9, 0.85),
                              child: FlatButton(
                                child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: const AssetImage(
                                                'images/an_bg_n.png'),
                                            fit: BoxFit.fill)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  fontSize: 14,
                                                  color: Colors.white))
                                        ])),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }
}

class ContentExtentView extends StatefulWidget {
  final GameCtx ctx;
  final int range;
  final GameMode mode;
  ContentExtentView({Key key, this.ctx, this.range, this.mode})
      : super(key: key);

  @override
  _ContentExtentViewState createState() => _ContentExtentViewState();
}

class _ContentExtentViewState extends State<ContentExtentView> {
  bool hide = false;
  Timer timer;
  List mutableArtical;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: !hide
            ? Text('')
            : Text(contentStr(),
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
      ),
    );
  }

  String contentStr() {
    int length = widget.range < mutableArtical.length
        ? widget.range
        : mutableArtical.length;
    List contentAry = List.generate(length, (idx) {
      if (widget.ctx == GameCtx.ctxNum) {
        int num = Random.secure().nextInt(9);
        return '$num';
      } else if (widget.ctx == GameCtx.ctxStr) {
        int index = Random.secure().nextInt(words.length - 1);
        return words[index];
      } else if (widget.ctx == GameCtx.ctxArtical) {
        String word = mutableArtical[idx];
        return word;
      }
    });

    if (widget.ctx == GameCtx.ctxArtical) {
      mutableArtical.removeRange(0, length);
    }

    return contentAry.sublist(0, length).join('');
  }

  List<String> mutablelize() {
    List copy = artical.split('');
    return List.generate(copy.length, (idx) {
      return copy[idx];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mutableArtical = mutablelize();
  }

  @override
  void initState() {
    super.initState();
    this.startTrain();
  }

  void startTrain() {
    var callBack = (tim) {
      if (widget.ctx == GameCtx.ctxArtical && mutableArtical.length == 0) {
        tim.cancel();
        Navigator.of(context).pop();
      }

      hide = !hide;
      this.setState(() {});
    };
    var unitSec = Duration(milliseconds: (widget.mode.index * 250 + 500));
    timer = Timer.periodic(unitSec, callBack);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

