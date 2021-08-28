import 'package:carrot_market/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> datas = [];
  String currentLocation = 'ara';
  late ContentsRepository contentsRepository;
  final Map<String, String> locationTypeToString = {
    "ara": "아라동",
    "ora": "오라동",
    "donam": "도남동",
  };

  void initState() {
    super.initState();
    currentLocation = "ara";
    contentsRepository = ContentsRepository();
  }

  String calcStringToWon(String priceString) {
    if (priceString == "무료나눔") return priceString;
    final oCcy = new NumberFormat("#,###", "ko_KR");
    return '${oCcy.format(int.parse(priceString))}원';
  }

  AppBar _appbarwidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print('click!');
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 25),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String where) {
            print(where);
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (conetext) {
            return [
              PopupMenuItem(value: 'ara', child: Text('아라동')),
              PopupMenuItem(value: 'ora', child: Text('오라동')),
              PopupMenuItem(value: 'donam', child: Text('도남동'))
            ];
          },
          child: Row(children: [
            Text(locationTypeToString[currentLocation]!),
            Icon(Icons.arrow_drop_down)
          ]),
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            ))
      ],
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // 로딩처리
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        // 오류 처리
        if (snapshot.hasError) {
          return Center(child: Text('데이터 오류'));
        }

        if (snapshot.hasData) {
          return _makeListData(snapshot.data);
        }

        return Center(child: Text('해당 지역의 데이터가 없습니다.'));
      },
      future: _loadContents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appbarwidget(), body: _bodyWidget());
  }

  _loadContents() {
    return contentsRepository.loadContentsFronLocation(currentLocation);
  }

  Widget _makeListData(datas) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        datas[index]["image"]!,
                        width: 100,
                        height: 100,
                      )),
                  Expanded(
                    child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas[index]['title']!,
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              datas[index]['location']!,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black.withOpacity(0.3)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              calcStringToWon(datas[index]['price']!),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/heart_off.svg',
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(width: 5),
                                    Text(datas[index]['likes']!)
                                  ]),
                            ),
                          ],
                        )),
                  )
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return Container(height: 1, color: Colors.black);
        },
        itemCount: datas.length);
  }
}
