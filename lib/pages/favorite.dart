import 'dart:ui';

import 'package:carrot_market/pages/detail.dart';
import 'package:carrot_market/repository/contents_repository.dart';
import 'package:carrot_market/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  late ContentsRepository contentsRepository;

  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: Text("관심목록", style: TextStyle(fontSize: 15)),
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
      future: _loadMyFavoriteContentsList(),
    );
  }

  Widget _makeListData(List<dynamic> datas) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print(datas[index]['title']);
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return DetailContentView(data: datas[index]);
              }));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Hero(
                          tag: datas[index]["cid"],
                          child: Image.asset(
                            datas[index]["image"]!,
                            width: 100,
                            height: 100,
                          ),
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
                                DataUtils.calcStringToWon(datas[index]['price']!),
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
                )),
          );
        },
        separatorBuilder: (context, index) {
          return Container(height: 1, color: Colors.grey.withOpacity(0.3));
        },
        itemCount: datas.length);
  }

  Future<List<dynamic>> _loadMyFavoriteContentsList() async {
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
